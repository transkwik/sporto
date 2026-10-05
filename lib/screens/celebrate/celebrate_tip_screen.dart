import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import 'celebrate_identity_screen.dart';
import 'widgets/celebrate_team_hero.dart';

enum CelebrateTipKind { player, team }

class CelebrateTipScreen extends StatefulWidget {
  const CelebrateTipScreen({
    super.key,
    required this.campaign,
    required this.kind,
    this.player,
  });

  final CelebrateCampaign campaign;
  final CelebrateTipKind kind;
  final CelebrateChampionPlayer? player;

  @override
  State<CelebrateTipScreen> createState() => _CelebrateTipScreenState();
}

class _CelebrateTipScreenState extends State<CelebrateTipScreen> {
  static const _pink = Color(0xFFE85AD4);
  static const _amounts = [50, 100, 250, 500, 1000, 2500];
  static const _quick = [
    'Congratulations Champions! 🔥',
    'What a performance!',
    'Well deserved!',
  ];

  int? _preset = 50;
  final _customController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  int? get _amount {
    final custom = int.tryParse(_customController.text.trim());
    if (custom != null && custom > 0) return custom;
    return _preset;
  }

  void _pickPreset(int value) {
    setState(() {
      _preset = value;
      _customController.clear();
    });
  }

  void _continue() {
    final amount = _amount;
    if (amount == null || amount < 20 || amount > 25000) {
      MCP.showMessage(context, 'Enter an amount between ₹20 and ₹25,000');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CelebrateIdentityScreen(
          campaign: widget.campaign,
          kind: widget.kind,
          amount: amount,
          message: _messageController.text.trim(),
          player: widget.player,
        ),
      ),
    );
  }

  String get _title {
    if (widget.kind == CelebrateTipKind.player && widget.player != null) return 'Celebrate';
    return widget.kind == CelebrateTipKind.player ? 'TIP A PLAYER' : 'TIP TEAM';
  }

  String get _prompt => widget.kind == CelebrateTipKind.player
      ? 'Loved their performance? Show them\nyour support.'
      : 'Loved their game? Show them\nyour support.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    if (widget.kind == CelebrateTipKind.player && widget.player != null)
                      _PlayerTipHero(campaign: widget.campaign, player: widget.player!)
                    else ...[
                      CelebrateTeamHero(campaign: widget.campaign),
                      const SizedBox(height: 18),
                      Text(
                        _prompt,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: _pink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (widget.kind == CelebrateTipKind.player && widget.player != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _MiniStat(value: '${widget.player!.runs}', label: 'Run')),
                          const SizedBox(width: 8),
                          Expanded(child: _MiniStat(value: '${widget.player!.wickets}', label: 'Wicket')),
                          const SizedBox(width: 8),
                          Expanded(child: _MiniStat(value: '${widget.player!.catches}', label: 'Catches')),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Choose Tip Amount',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final amount in _amounts)
                          _AmountChip(
                            label: '₹$amount',
                            selected: _preset == amount && _customController.text.isEmpty,
                            onTap: () => _pickPreset(amount),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Custom Amount',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: TextField(
                        controller: _customController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() => _preset = null),
                        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15),
                        cursorColor: _pink,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: false,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixText: '₹  ',
                          prefixStyle: GoogleFonts.quicksand(color: Colors.white54, fontSize: 15),
                          hintText: 'Enter amount (₹20 – ₹25,000)',
                          hintStyle: GoogleFonts.quicksand(color: Colors.white38, fontSize: 13.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Add A Message',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optional — write a congratulatory message.',
                      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _messageController,
                            maxLength: 120,
                            maxLines: 4,
                            onChanged: (_) => setState(() {}),
                            style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14),
                            cursorColor: _pink,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: false,
                              fillColor: Colors.transparent,
                              counterText: '',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Write a congratulatory message...',
                              hintStyle: GoogleFonts.quicksand(color: Colors.white38, fontSize: 14),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${_messageController.text.length}/120',
                              style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final text in _quick)
                          GestureDetector(
                            onTap: () => setState(() => _messageController.text = text),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161A22),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.glassBorderStrong),
                              ),
                              child: Text(
                                text,
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GestureDetector(
                  onTap: _continue,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: _pink.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
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

class _PlayerTipHero extends StatelessWidget {
  const _PlayerTipHero({required this.campaign, required this.player});

  final CelebrateCampaign campaign;
  final CelebrateChampionPlayer player;

  static const _gold = Color(0xFFE3A93D);
  static const _pink = Color(0xFFE85AD4);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161222),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _pink.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tournament',
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
          ),
          Text(
            campaign.tournamentTitle,
            style: GoogleFonts.quicksand(
              color: _gold,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFF2A2230),
                child: Text(
                  player.initials,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: campaign.sport,
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '  •  ${campaign.teamName}',
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${player.role}  •  ${player.mvpAwards} MVP Awards',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (player.awardLabel != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _gold.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: _gold, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      player.awardLabel!,
                      style: GoogleFonts.quicksand(
                        color: _gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4A1848) : const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFE85AD4) : AppColors.glassBorderStrong,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: selected ? const Color(0xFFE85AD4) : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
