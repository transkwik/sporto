import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_schedule_screen.dart';

enum _LocationStep { empty, current, venue }

/// Select Sport → Game Location (dummy in-page flow).
class RefereeGameLocationScreen extends StatefulWidget {
  const RefereeGameLocationScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeGameLocationScreen> createState() => _RefereeGameLocationScreenState();
}

class _RefereeGameLocationScreenState extends State<RefereeGameLocationScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _chipBg = Color(0xFF1A1224);
  static const _fieldBg = Color(0xFF1A1F28);
  static const _mint = Color(0xFF3DDC97);
  static const _questionBlue = Color(0xFF4EB4E8);

  _LocationStep _step = _LocationStep.empty;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _useCurrent() {
    setState(() {
      _step = _LocationStep.current;
      _searchController.clear();
    });
  }

  void _changeLocation() {
    setState(() {
      _step = _LocationStep.empty;
      _searchController.clear();
    });
  }

  void _confirmContinue() {
    setState(() => _step = _LocationStep.venue);
  }

  void _selectVenue() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchController.text = 'KPHB Indoor Stadium';
      _step = _LocationStep.venue;
    });
  }

  void _quickBook() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RefereeScheduleScreen(
          draft: widget.draft.copyWith(location: 'KPHB Indoor Stadium, Kompally, Hyderabad'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _step == _LocationStep.empty ? 'Game Location' : 'Book A Referee';

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
                        GlassBackButton(onTap: () => Navigator.of(context).pop()),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.my_location_rounded, color: _questionBlue, size: 20),
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
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectVenue,
                      child: Container(
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
                              child: AbsorbPointer(
                                child: TextField(
                                
                                  controller: _searchController,
                                  readOnly: true,
                                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5),
                                  decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14.5),
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
                            ),
                            const Icon(Icons.search_rounded, color: _questionBlue, size: 22),
                          ],
                        ),
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
                      Container(
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
                                  child: Icon(Icons.location_on_rounded, color: _mint, size: 18),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _step == _LocationStep.current
                                      ? Text(
                                          'Kompally, Hyderabad',
                                          style: GoogleFonts.quicksand(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'KPHB Indoor Stadium',
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'Kompally, Hyderabad',
                                              style: GoogleFonts.quicksand(
                                                color: Colors.white54,
                                                fontSize: 12.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This is where your referee will be required to report.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
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
                            child: Text(
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
              else if (_step == _LocationStep.venue)
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
                  child: GestureDetector(
                    onTap: _quickBook,
                    child: Container(
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.bannerGradient,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        'Quick Book',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
