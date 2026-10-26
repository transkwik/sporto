import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/tournament_prizes_info.dart';
import '../tournament/tournament_detail_screen.dart';

/// Tournament prize breakdown from `GET user/tournaments/{id}/prizes`.
/// Everything shown is driven by the API response; pull down to refresh.
class PrizeDetailsScreen extends StatefulWidget {
  const PrizeDetailsScreen({
    super.key,
    required this.tournamentId,
    this.tournamentName,
  });

  final int tournamentId;

  /// Optional name shown while the first response is loading.
  final String? tournamentName;

  @override
  State<PrizeDetailsScreen> createState() => _PrizeDetailsScreenState();
}

class _PrizeDetailsScreenState extends State<PrizeDetailsScreen> {
  TournamentPrizes? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    if (!refresh) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    TournamentPrizes? data;
    String? error;
    try {
      final res = await UserApis().getTournamentPrizes(widget.tournamentId);
      if (res is! Map) {
        error = 'Unexpected response from server.';
      } else if (res['session_expired'] == true) {
        error = 'Your session has expired. Please log in again.';
      } else if (res['error'] != null) {
        error = res['error'].toString();
      } else if (res['success'] != true) {
        error = res['message']?.toString() ?? 'Could not load prize details.';
      } else if (res['data'] is! Map) {
        error = 'Prize details are not available.';
      } else {
        data = TournamentPrizes.fromJson(
          Map<String, dynamic>.from(res['data'] as Map),
          fallbackId: widget.tournamentId,
        );
      }
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (data != null) {
        _data = data;
        _error = null;
      } else if (_data == null) {
        _error = error;
      } else if (refresh) {
        // Keep showing the last good data; just tell the user the refresh failed.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Could not refresh.')),
        );
      }
    });
  }

  void _openTournament() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TournamentDetailScreen(tournamentId: widget.tournamentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _data?.tournamentName ?? widget.tournamentName;

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prize Details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (name != null && name.isNotEmpty)
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.mintGreen));
    }

    final data = _data;
    final Widget content;
    if (data == null) {
      content = _Message(
        icon: Icons.error_outline_rounded,
        text: _error ?? 'Could not load prize details.',
        actionLabel: 'Retry',
        onAction: _load,
      );
    } else if (data.prizes.isEmpty) {
      content = _Message(
        icon: Icons.emoji_events_outlined,
        text: 'No prizes have been configured for this tournament yet.',
        header: _PoolCard(data: data),
      );
    } else {
      content = _PrizeList(data: data, onOpenTournament: _openTournament);
    }

    return RefreshIndicator(
      color: AppColors.mintGreen,
      backgroundColor: AppColors.secondary,
      onRefresh: () => _load(refresh: true),
      child: content,
    );
  }
}

class _PrizeList extends StatelessWidget {
  const _PrizeList({required this.data, required this.onOpenTournament});

  final TournamentPrizes data;
  final VoidCallback onOpenTournament;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        _PoolCard(data: data),
        const SizedBox(height: 18),
        Text(
          'Prizes (${data.prizes.length})',
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
        ),
        const SizedBox(height: 10),
        for (final p in data.prizes) ...[
          _PrizeCard(prize: p),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onOpenTournament,
          child: Container(
            width: double.infinity,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: AppColors.infoBlue),
            ),
            child: Text(
              'Tournament Details',
              style: GoogleFonts.quicksand(
                color: AppColors.infoBlue,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PoolCard extends StatelessWidget {
  const _PoolCard({required this.data});

  final TournamentPrizes data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2048), Color(0xFF1A1224)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.amberAccent.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: AppColors.amberAccent, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Prize Pool',
                  style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 12.5),
                ),
                const SizedBox(height: 2),
                Text(
                  data.formattedPool,
                  style: GoogleFonts.quicksand(
                    color: AppColors.amberAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrizeCard extends StatelessWidget {
  const _PrizeCard({required this.prize});

  final TournamentPrizeItem prize;

  @override
  Widget build(BuildContext context) {
    final rows = prize.details;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.emoji_events_rounded, color: Colors.white70, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prize.title,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (prize.category.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _prettify(prize.category),
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    prize.formattedAmount,
                    style: GoogleFonts.quicksand(
                      color: AppColors.amberAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (!prize.isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: Text(
                          'Inactive',
                          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 10.5),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (rows.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: AppColors.glassBorder),
            const SizedBox(height: 12),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rows[i].$1,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  static String _prettify(String raw) => raw
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');
}

/// Scrollable message (so pull-to-refresh also works on empty/error states).
class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
    this.header,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight - 44),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (header != null) ...[header!, const SizedBox(height: 40)],
              Icon(icon, color: Colors.white38, size: 48),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(color: Colors.white60, fontSize: 14),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.mintGreen),
                    ),
                    child: Text(
                      actionLabel!,
                      style: GoogleFonts.quicksand(
                        color: AppColors.mintGreen,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
