import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import '../auth/providers/location_provider.dart';
import 'referee_choose_mode_screen.dart';

const String _kGoogleMapsApiKey = 'AIzaSyBl0Pm1-cZM3-IdYhEkmEQ2A4XxSJpIRdQ';

enum _LocationStep { empty, current }

/// City name for [pos]: native geocoder `locality` first, then the Google
/// Geocoding API `locality` component. Returns '' if nothing is found.
Future<String> _resolveCity(LatLng pos) async {
  try {
    final placemarks = await Geocoding().placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    for (final p in placemarks) {
      final city = [
        p.locality,
        p.subAdministrativeArea,
      ].firstWhere((v) => v != null && v.trim().isNotEmpty, orElse: () => '');
      if (city != null && city.trim().isNotEmpty) return city.trim();
    }
  } catch (e) {
    debugPrint('City (native) error: $e');
  }

  try {
    final uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$_kGoogleMapsApiKey',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final results = jsonDecode(res.body)['results'] as List<dynamic>?;
      for (final r in results ?? const []) {
        final comps = (r is Map ? r['address_components'] : null) as List?;
        for (final c in comps ?? const []) {
          final types = (c is Map ? c['types'] : null) as List?;
          if (types != null && types.contains('locality')) {
            final name = c['long_name']?.toString() ?? '';
            if (name.isNotEmpty) return name;
          }
        }
      }
    }
  } catch (e) {
    debugPrint('City (Google) error: $e');
  }
  return '';
}

/// Select Sport → Game Location with real GPS + Google Maps location picker & search.
class RefereeGameLocationScreen extends StatefulWidget {
  const RefereeGameLocationScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeGameLocationScreen> createState() =>
      _RefereeGameLocationScreenState();
}

class _RefereeGameLocationScreenState extends State<RefereeGameLocationScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _chipBg = Color(0xFF1A1224);
  static const _fieldBg = Color(0xFF1A1F28);
  static const _mint = Color(0xFF3DDC97);
  static const _questionBlue = Color(0xFF4EB4E8);

  _LocationStep _step = _LocationStep.empty;
  final _searchController = TextEditingController();
  bool _isFetchingGps = false;

  LatLng _selectedLatLng = const LatLng(17.5366, 78.4845); // Default Hyderabad
  String _locationTitle = '';
  String _locationSubtitle = '';

  /// `city` for the booking API (resolved from the selected coordinates).
  String _city = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locProvider = context.read<LocationProvider>();
      if (locProvider.latitude != 0.0 && locProvider.longitude != 0.0) {
        _selectedLatLng = LatLng(locProvider.latitude, locProvider.longitude);
        if (locProvider.address.isNotEmpty &&
            locProvider.address != 'Unknown location') {
          _locationTitle = locProvider.address;
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _combinedLocation {
    if (_locationTitle.isNotEmpty &&
        _locationSubtitle.isNotEmpty &&
        _locationTitle != _locationSubtitle) {
      return '$_locationTitle, $_locationSubtitle';
    }
    if (_locationTitle.isNotEmpty) return _locationTitle;
    if (_locationSubtitle.isNotEmpty) return _locationSubtitle;
    return 'Selected Location';
  }

  Future<void> _useCurrent() async {
    if (_isFetchingGps) return;
    setState(() => _isFetchingGps = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location services.'),
            ),
          );
        }
        setState(() => _isFetchingGps = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required.'),
            ),
          );
        }
        setState(() => _isFetchingGps = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final latLng = LatLng(position.latitude, position.longitude);
      final resolved = await _reverseGeocode(latLng);

      if (mounted) {
        context.read<LocationProvider>().setLocation(
          position,
          resolved.$1.isNotEmpty ? resolved.$1 : resolved.$2,
        );
        setState(() {
          _selectedLatLng = latLng;
          _locationTitle = resolved.$1;
          _locationSubtitle = resolved.$2;
          _city = '';
          _searchController.clear();
          _step = _LocationStep.current;
        });
        _updateCity(latLng);
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (mounted) {
        // Open map picker as fallback if GPS fails
        await _openMapPicker();
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingGps = false);
      }
    }
  }

  Future<(String, String)> _reverseGeocode(LatLng pos) async {
    // 1. Try native Geocoding package first
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final name = (p.name ?? '').trim();
        final subLocality = (p.subLocality ?? '').trim();
        final locality = (p.locality ?? '').trim();
        final adminArea = (p.administrativeArea ?? '').trim();

        final cityPart = [
          if (subLocality.isNotEmpty) subLocality,
          if (locality.isNotEmpty && locality != subLocality) locality,
          if (locality.isEmpty && adminArea.isNotEmpty) adminArea,
        ].join(', ');

        if (name.isNotEmpty &&
            name != subLocality &&
            !RegExp(r'^\d+$').hasMatch(name)) {
          return (name, cityPart.isNotEmpty ? cityPart : locality);
        }
        if (cityPart.isNotEmpty) {
          return (cityPart, '');
        }
      }
    } catch (e) {
      debugPrint('Native reverse geocode error: $e');
    }

    // 2. Fallback to Google Geocoding HTTP API with provided key
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$_kGoogleMapsApiKey',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final formatted =
              results.first['formatted_address']?.toString() ?? '';
          if (formatted.isNotEmpty) {
            final parts = formatted
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
            if (parts.length >= 2) {
              return (parts.first, parts.sublist(1).take(2).join(', '));
            }
            return (formatted, '');
          }
        }
      }
    } catch (e) {
      debugPrint('Google Geocode API error: $e');
    }

    return (
      '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}',
      '',
    );
  }

  Future<void> _openMapPicker({String initialQuery = ''}) async {
    FocusScope.of(context).unfocus();
    final result = await Navigator.of(context).push<_PickedMapLocation>(
      MaterialPageRoute(
        builder: (_) => _RefereeGoogleMapPickerScreen(
          initialPosition: _selectedLatLng,
          initialQuery: initialQuery,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLatLng = result.latLng;
        _locationTitle = result.title;
        _locationSubtitle = result.subtitle;
        _city = '';
        _searchController.text = result.title;
        _step = _LocationStep.current;
      });
      _updateCity(result.latLng);
    }
  }

  void _changeLocation() {
    _openMapPicker(initialQuery: _searchController.text.trim());
  }

  /// Resolves the city for [pos] in the background (ignored if the user has
  /// picked another location meanwhile).
  Future<void> _updateCity(LatLng pos) async {
    final city = await _resolveCity(pos);
    if (!mounted || pos != _selectedLatLng) return;
    setState(() => _city = city);
  }

  /// Last-resort city from the address text, e.g. "Kompally, Hyderabad" → "Hyderabad".
  String get _cityFromAddress {
    final parts = _locationSubtitle
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !RegExp(r'^\d+$').hasMatch(e))
        .toList();
    return parts.isNotEmpty ? parts.last : '';
  }

  bool _isContinuing = false;

  /// Location confirmed → "How would you like to book?" (Quick Book / Browse).
  Future<void> _confirmContinue() async {
    if (_isContinuing) return;
    setState(() => _isContinuing = true);

    var city = _city;
    if (city.isEmpty) city = await _resolveCity(_selectedLatLng);
    if (city.isEmpty) city = _cityFromAddress;
    if (!mounted) return;
    setState(() {
      _city = city;
      _isContinuing = false;
    });

    final draft = widget.draft.copyWith(
      location: _combinedLocation,
      venueName: _locationTitle.isNotEmpty
          ? _locationTitle
          : 'Selected Location',
      city: city,
      latitude: _selectedLatLng.latitude,
      longitude: _selectedLatLng.longitude,
    );
    debugPrint(
      'Referee location → venue_name: ${draft.venueName}, city: ${draft.city}',
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RefereeChooseModeScreen(draft: draft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _step == _LocationStep.empty
        ? 'Game Location'
        : 'Book A Referee';

    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  children: [
                    Row(
                      children: [
                        GlassBackButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Book A Referee',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _chipBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Sport',
                            style: GoogleFonts.quicksand(
                              color: const Color(0xFF8B7AA8),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Text('🏏', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            widget.draft.sport,
                            style: GoogleFonts.quicksand(
                              color: _mint,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Where is your game?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: _questionBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The referee needs to know exactly where they’re\nexpected to report.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _useCurrent,
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _fieldBg,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: const Color(0xFF2A3140)),
                        ),
                        child: _isFetchingGps
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: _questionBlue,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.my_location_rounded,
                                    color: _questionBlue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Use My Current Location',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Or search venue, area or address',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _fieldBg,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFF2A3140)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              readOnly: true,
                              onTap: () => _openMapPicker(
                                initialQuery: _searchController.text.trim(),
                              ),
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14.5,
                              ),
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                filled: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: GoogleFonts.quicksand(
                                  color: Colors.white38,
                                  fontSize: 14.5,
                                ),
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: 'Select Current Location',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _openMapPicker(
                              initialQuery: _searchController.text.trim(),
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: _questionBlue,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_step != _LocationStep.empty) ...[
                      const SizedBox(height: 22),
                      Text(
                        'Your Game Location',
                        style: GoogleFonts.quicksand(
                          color: _mint,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _openMapPicker(
                          initialQuery: _searchController.text.trim(),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10241C),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF1F4A38)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Location',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white54,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      color: _mint,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _locationTitle.isNotEmpty
                                              ? _locationTitle
                                              : 'Selected Location',
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (_locationSubtitle.isNotEmpty &&
                                            _locationSubtitle !=
                                                _locationTitle) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            _locationSubtitle,
                                            style: GoogleFonts.quicksand(
                                              color: Colors.white54,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This is where your referee will be required to report.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white38,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_step == _LocationStep.current)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _changeLocation,
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C2430),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Text(
                              'Change Location',
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: _confirmContinue,
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: AppColors.bannerGradient,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: _isContinuing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Confirm & Continue',
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class _PickedMapLocation {
  const _PickedMapLocation({
    required this.latLng,
    required this.title,
    required this.subtitle,
  });

  final LatLng latLng;
  final String title;
  final String subtitle;
}

class _PlaceSuggestion {
  const _PlaceSuggestion({
    required this.description,
    required this.mainText,
    required this.secondaryText,
    this.placeId,
    this.latLng,
  });

  final String description;
  final String mainText;
  final String secondaryText;
  final String? placeId;
  final LatLng? latLng;
}

/// Interactive Google Maps location picker screen with live address search.
class _RefereeGoogleMapPickerScreen extends StatefulWidget {
  const _RefereeGoogleMapPickerScreen({
    required this.initialPosition,
    this.initialQuery = '',
  });

  final LatLng initialPosition;
  final String initialQuery;

  @override
  State<_RefereeGoogleMapPickerScreen> createState() =>
      _RefereeGoogleMapPickerScreenState();
}

class _RefereeGoogleMapPickerScreenState
    extends State<_RefereeGoogleMapPickerScreen> {
  GoogleMapController? _mapController;
  late LatLng _currentPin;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;

  bool _isResolvingAddress = false;
  bool _isSearching = false;
  bool _isCameraMoving = false;
  LatLng? _suggestionTarget;
  String _title = 'Fetching location...';
  String _subtitle = '';
  List<_PlaceSuggestion> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _currentPin = widget.initialPosition;
    if (widget.initialQuery.isNotEmpty) {
      _searchCtrl.text = widget.initialQuery;
    }
    _resolveCoordinates(_currentPin);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _resolveCoordinates(LatLng pos) async {
    setState(() => _isResolvingAddress = true);
    try {
      // 1. Native Geocoding
      final placemarks = await Geocoding().placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final name = (p.name ?? '').trim();
        final subLocality = (p.subLocality ?? '').trim();
        final locality = (p.locality ?? '').trim();
        final adminArea = (p.administrativeArea ?? '').trim();

        final cityPart = [
          if (subLocality.isNotEmpty) subLocality,
          if (locality.isNotEmpty && locality != subLocality) locality,
          if (locality.isEmpty && adminArea.isNotEmpty) adminArea,
        ].join(', ');

        if (mounted) {
          setState(() {
            if (name.isNotEmpty &&
                name != subLocality &&
                !RegExp(r'^\d+$').hasMatch(name)) {
              _title = name;
              _subtitle = cityPart.isNotEmpty ? cityPart : locality;
            } else if (cityPart.isNotEmpty) {
              _title = cityPart;
              _subtitle = adminArea;
            } else {
              _title =
                  '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
              _subtitle = '';
            }
            _isResolvingAddress = false;
          });
        }
        return;
      }
    } catch (_) {}

    // 2. Fallback: Google Geocoding API
    try {
      final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$_kGoogleMapsApiKey',
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final results = data['results'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final formatted =
              results.first['formatted_address']?.toString() ?? '';
          if (formatted.isNotEmpty && mounted) {
            final parts = formatted
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
            setState(() {
              _title = parts.isNotEmpty ? parts.first : formatted;
              _subtitle = parts.length > 1
                  ? parts.sublist(1).take(2).join(', ')
                  : '';
              _isResolvingAddress = false;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _title =
            '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
        _subtitle = '';
        _isResolvingAddress = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 380), () {
      _searchPlaces(trimmed);
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearching = true);
    final List<_PlaceSuggestion> results = [];

    try {
      // 1. Try Google Places Autocomplete API
      final autoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&key=$_kGoogleMapsApiKey',
      );
      final autoRes = await http.get(autoUri);
      if (autoRes.statusCode == 200) {
        final data = jsonDecode(autoRes.body);
        final preds = data['predictions'] as List<dynamic>?;
        if (preds != null && preds.isNotEmpty) {
          for (final p in preds.take(5)) {
            if (p is Map) {
              final desc = p['description']?.toString() ?? '';
              final fmt = p['structured_formatting'] as Map?;
              final mainText = fmt?['main_text']?.toString() ?? desc;
              final secText = fmt?['secondary_text']?.toString() ?? '';
              results.add(
                _PlaceSuggestion(
                  description: desc,
                  mainText: mainText,
                  secondaryText: secText,
                  placeId: p['place_id']?.toString(),
                ),
              );
            }
          }
        }
      }

      // 2. If Places Autocomplete returned none, try Google Geocode search
      if (results.isEmpty) {
        final geoUri = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$_kGoogleMapsApiKey',
        );
        final geoRes = await http.get(geoUri);
        if (geoRes.statusCode == 200) {
          final data = jsonDecode(geoRes.body);
          final geoList = data['results'] as List<dynamic>?;
          if (geoList != null && geoList.isNotEmpty) {
            for (final g in geoList.take(5)) {
              if (g is Map) {
                final formatted = g['formatted_address']?.toString() ?? query;
                final loc = g['geometry']?['location'];
                final lat = double.tryParse(loc?['lat']?.toString() ?? '');
                final lng = double.tryParse(loc?['lng']?.toString() ?? '');
                final parts = formatted
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                results.add(
                  _PlaceSuggestion(
                    description: formatted,
                    mainText: parts.isNotEmpty ? parts.first : query,
                    secondaryText: parts.length > 1
                        ? parts.sublist(1).join(', ')
                        : '',
                    latLng: (lat != null && lng != null)
                        ? LatLng(lat, lng)
                        : null,
                  ),
                );
              }
            }
          }
        }
      }

      // 3. Fallback to native Geocoding.locationFromAddress
      if (results.isEmpty) {
        final locations = await Geocoding().locationFromAddress(query);
        if (locations.isNotEmpty) {
          final first = locations.first;
          results.add(
            _PlaceSuggestion(
              description: query,
              mainText: query,
              secondaryText:
                  '${first.latitude.toStringAsFixed(4)}, ${first.longitude.toStringAsFixed(4)}',
              latLng: LatLng(first.latitude, first.longitude),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Search error: $e');
    }

    if (mounted) {
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    }
  }

  Future<void> _selectSuggestion(_PlaceSuggestion s) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _suggestions = [];
      _searchCtrl.text = s.mainText;
      _title = s.mainText;
      _subtitle = s.secondaryText;
    });

    LatLng? target = s.latLng;
    if (target == null && s.placeId != null) {
      try {
        final uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${s.placeId}&fields=geometry&key=$_kGoogleMapsApiKey',
        );
        final res = await http.get(uri);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final loc = data['result']?['geometry']?['location'];
          final lat = double.tryParse(loc?['lat']?.toString() ?? '');
          final lng = double.tryParse(loc?['lng']?.toString() ?? '');
          if (lat != null && lng != null) {
            target = LatLng(lat, lng);
          }
        }
      } catch (_) {}
    }

    if (target == null) {
      try {
        final locs = await Geocoding().locationFromAddress(s.description);
        if (locs.isNotEmpty) {
          target = LatLng(locs.first.latitude, locs.first.longitude);
        }
      } catch (_) {}
    }

    if (target != null && mounted) {
      // Keep the searched place's name when the camera settles on it.
      _suggestionTarget = target;
      setState(() => _currentPin = target!);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    }
  }

  /// Called when the user stops dragging the map: the centre is the new pin.
  void _onCameraIdle() {
    if (!mounted) return;
    setState(() => _isCameraMoving = false);

    final searched = _suggestionTarget;
    if (searched != null) {
      final dLat = (searched.latitude - _currentPin.latitude).abs();
      final dLng = (searched.longitude - _currentPin.longitude).abs();
      if (dLat < 0.0001 && dLng < 0.0001) {
        // Camera just finished flying to the searched place; keep its name.
        return;
      }
      // User dragged away from the searched place.
      _suggestionTarget = null;
    }
    _resolveCoordinates(_currentPin);
  }

  Future<void> _submitTypedQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    await _searchPlaces(trimmed);
    if (_suggestions.isNotEmpty) {
      await _selectSuggestion(_suggestions.first);
    } else {
      // Allow user to use their typed venue/address directly
      FocusScope.of(context).unfocus();
      setState(() {
        _title = trimmed;
        _suggestions = [];
      });
    }
  }

  Future<void> _goToCurrentGps() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final target = LatLng(pos.latitude, pos.longitude);
      _suggestionTarget = null;
      // Camera idle will resolve the address for the new centre.
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
    } catch (e) {
      debugPrint('Error moving to GPS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: SafeArea(
        child: Stack(
          children: [
            // Google Map (user pans the map; the pin stays fixed in the centre)
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPin,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onCameraMoveStarted: () {
                  if (!_isCameraMoving) {
                    setState(() => _isCameraMoving = true);
                  }
                },
                onCameraMove: (position) {
                  _currentPin = position.target;
                },
                onCameraIdle: _onCameraIdle,
                onTap: (pos) {
                  FocusScope.of(context).unfocus();
                  setState(() => _suggestions = []);
                  _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
                },
              ),
            ),

            // Fixed centre pin (tip sits exactly on the map centre)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          transform: Matrix4.translationValues(
                            0,
                            _isCameraMoving ? -10 : 0,
                            0,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFFE53935),
                            size: 46,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: _isCameraMoving ? 6 : 12,
                          height: _isCameraMoving ? 3 : 5,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Hint chip
            if (_suggestions.isEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 178,
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12161F).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Drag the map to move the pin',
                        style: GoogleFonts.quicksand(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Top Search Bar + Suggestions Overlay
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Container(
                    height: 54,
                    padding: const EdgeInsets.only(left: 6, right: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12161F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2430),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF4EB4E8),
                          size: 21,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) {
                              setState(() {});
                              _onSearchChanged(v);
                            },
                            onSubmitted: _submitTypedQuery,
                            textInputAction: TextInputAction.search,
                            cursorColor: const Color(0xFF4EB4E8),
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search venue, area or address',
                              hintStyle: GoogleFonts.quicksand(
                                color: Colors.white38,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              // Override the global input theme (white fill).
                              filled: false,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_isSearching)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4EB4E8),
                            ),
                          )
                        else if (_searchCtrl.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() => _suggestions = []);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2A3140),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                                size: 15,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_suggestions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12161F),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        itemBuilder: (context, index) {
                          final item = _suggestions[index];
                          return ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            leading: Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF3DDC97,
                                ).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF3DDC97),
                                size: 18,
                              ),
                            ),
                            title: Text(
                              item.mainText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: item.secondaryText.isNotEmpty
                                ? Text(
                                    item.secondaryText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            onTap: () => _selectSuggestion(item),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // My Location Floating Button
            Positioned(
              right: 16,
              bottom: 175,
              child: GestureDetector(
                onTap: _goToCurrentGps,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B24),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Color(0xFF4EB4E8),
                    size: 22,
                  ),
                ),
              ),
            ),

            // Bottom Location Confirmation Card
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                decoration: BoxDecoration(
                  color: const Color(0xFF12161F),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFF3DDC97),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _isResolvingAddress
                              ? Text(
                                  'Resolving location...',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white70,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if (_subtitle.isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        _subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.quicksand(
                                          color: Colors.white54,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        final typed = _searchCtrl.text.trim();
                        final chosenTitle =
                            (_title.isNotEmpty &&
                                _title != 'Fetching location...')
                            ? _title
                            : (typed.isNotEmpty ? typed : 'Selected Location');
                        Navigator.of(context).pop(
                          _PickedMapLocation(
                            latLng: _currentPin,
                            title: chosenTitle,
                            subtitle: _subtitle,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Text(
                          'Confirm Location',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
