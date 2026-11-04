import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import '../home/providers/home_provider.dart';
import 'referee_game_location_screen.dart';

/// Register Individually → Select Sport.
class RefereeSportLocationScreen extends StatefulWidget {
  const RefereeSportLocationScreen({super.key});

  @override
  State<RefereeSportLocationScreen> createState() =>
      _RefereeSportLocationScreenState();
}

class _RefereeSportLocationScreenState
    extends State<RefereeSportLocationScreen> {
  static const _selectedFill = Color(0xFF6A9DB5);
  static const _tileFill = Color(0xFF12161D);
  static const _wellUnselected = Color(0xFF1C222C);
  static const _wellSelected = Color(0xFF5A8CA6);

  /// Selected sport id (index can't be used because the list is filtered).
  String? _selectedId;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchSports();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getStaticSportIcon(String name) {
    switch (name.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'badminton':
      case 'tennis':
      case 'table tennis':
        return Icons.sports_tennis_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      case 'hockey':
        return Icons.sports_hockey_rounded;
      case 'kabaddi':
        return Icons.sports_martial_arts_rounded;
      case 'volleyball':
      case 'throwball':
        return Icons.sports_volleyball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  void _pick(String? id, String sportName) {
    FocusScope.of(context).unfocus();
    setState(() => _selectedId = id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefereeGameLocationScreen(
          draft: RefereeBookingDraft(
            sport: sportName,
            sportId: int.tryParse(id ?? ''),
            location: '',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: Container(
        color: const Color(0xFF0B0D12),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Sport',
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
              ),
              const SizedBox(height: 16),
              Text(
                'Which sport needs an official?',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF4EB4E8),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              // Search box
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _tileFill,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF252A33)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF4EB4E8),
                        size: 21,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v.trim()),
                          textInputAction: TextInputAction.search,
                          cursorColor: const Color(0xFF4EB4E8),
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search sport',
                            hintStyle: GoogleFonts.quicksand(
                              color: Colors.white38,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            // Override the global white-filled input theme.
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
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _query = '');
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
              ),
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, _) {
                    final allSports = homeProvider.sportsList;
                    if (homeProvider.isFetchingSports && allSports.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (allSports.isEmpty) {
                      return Center(
                        child: Text(
                          'No sports available.',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    // Filter by name (case-insensitive, null-safe).
                    final q = _query.toLowerCase();
                    final sports = q.isEmpty
                        ? allSports
                        : allSports.where((s) {
                            final n = s is Map
                                ? (s['name']?.toString() ?? '')
                                : '';
                            return n.toLowerCase().contains(q);
                          }).toList();

                    if (sports.isEmpty) {
                      return Center(
                        child: Text(
                          'No sports match "$_query".',
                          style: GoogleFonts.quicksand(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    // Default selection: first sport of the full list.
                    final firstId = allSports.first is Map
                        ? (allSports.first as Map)['id']?.toString()
                        : null;
                    final activeId = _selectedId ?? firstId;

                    return GridView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.62,
                          ),
                      itemCount: sports.length,
                      itemBuilder: (context, index) {
                        final rawItem = sports[index];
                        final mapItem = rawItem is Map
                            ? rawItem
                            : <String, dynamic>{};
                        final sportId = mapItem['id']?.toString();
                        final selected =
                            sportId != null && sportId == activeId;

                        final rawName = mapItem['name']?.toString().trim();
                        final String name =
                            (rawName != null && rawName.isNotEmpty)
                            ? rawName
                            : 'No Name';

                        final rawIconUrl = mapItem['icon_url']
                            ?.toString()
                            .trim();
                        final String? iconUrl =
                            (rawIconUrl != null && rawIconUrl.isNotEmpty)
                            ? rawIconUrl
                            : null;

                        final fallbackIcon = Icon(
                          _getStaticSportIcon(name),
                          color: selected ? Colors.white : Colors.white70,
                          size: 26,
                        );

                        return GestureDetector(
                          onTap: () => _pick(sportId, name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: selected ? _selectedFill : _tileFill,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? Colors.transparent
                                    : const Color(0xFF252A33),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? _wellSelected
                                        : _wellUnselected,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: iconUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            iconUrl,
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) =>
                                                fallbackIcon,
                                          ),
                                        )
                                      : fallbackIcon,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF8B919C),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
