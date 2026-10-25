/// Pure helpers that read a match object from the `/matches` list API
/// (live / upcoming / completed) into display values. Shared by the match
/// feed cards and the completed-match detail screen so every tab shows the
/// same real data instead of per-screen guesses.
class MatchDataParser {
  MatchDataParser._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Team on side [isA] (`team_a` / `team_b`). Falls back to the `teams`
  /// list and finally to the bracket source label ("Winner of Match 4029").
  static ({String name, String? id}) team(Map<String, dynamic> m, {required bool isA}) {
    final direct = m[isA ? 'team_a' : 'team_b'];
    if (direct is Map && direct['name'] != null) {
      return (name: direct['name'].toString(), id: direct['id']?.toString());
    }

    final source = m[isA ? 'team_a_source' : 'team_b_source'];
    final teams = m['teams'];
    if (teams is List) {
      // Only trust the list for a side when it is not the other side's team.
      final otherDirect = m[isA ? 'team_b' : 'team_a'];
      final otherId = otherDirect is Map ? otherDirect['id']?.toString() : null;
      for (final t in teams) {
        if (t is Map && t['name'] != null && t['id']?.toString() != otherId) {
          return (name: t['name'].toString(), id: t['id']?.toString());
        }
      }
    }

    if (source is Map && source['label'] != null) {
      return (name: source['label'].toString(), id: null);
    }
    return (name: 'TBD', id: null);
  }

  /// Score ("51/0") and overs ("3.0") of a team from `scoring.score.teams`.
  static ({String score, String overs, bool hasData}) score(Map<String, dynamic> m, String? teamId) {
    final teamsScore = m['scoring']?['score']?['teams'];
    if (teamId != null && teamsScore is Map && teamsScore[teamId] is Map) {
      final s = teamsScore[teamId] as Map;
      final runs = s['score']?.toString() ?? '0';
      final wickets = s['wickets']?.toString();
      return (
        score: wickets != null ? '$runs/$wickets' : runs,
        overs: s['overs']?.toString() ?? '',
        hasData: true,
      );
    }
    return (score: '0/0', overs: '', hasData: false);
  }

  /// Winner shown on completed cards (never guesses a team).
  static String winnerName(Map<String, dynamic> m) {
    final result = m['result'];
    if (result is Map) {
      final w = result['winner_team'];
      if (w is Map && w['name'] != null) return w['name'].toString();
      if (result['is_tie'] == true) return 'Match Tied';
      if (result['is_draw'] == true) return 'Match Drawn';
      final winnerId = result['winner_team_id']?.toString();
      if (winnerId != null) {
        final a = team(m, isA: true);
        final b = team(m, isA: false);
        if (a.id == winnerId) return a.name;
        if (b.id == winnerId) return b.name;
      }
    }
    return 'No result';
  }

  static DateTime? startTime(Map<String, dynamic> m) {
    final s = m['schedule'];
    final raw = (s is Map ? (s['start_at'] ?? s['scheduled_start_at']) : null)?.toString();
    return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _clock(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return '$h:${_two(t.minute)} ${t.hour >= 12 ? 'PM' : 'AM'}';
  }

  static bool _isToday(DateTime t) {
    final n = DateTime.now();
    return t.year == n.year && t.month == n.month && t.day == n.day;
  }

  /// "15 Oct, 10:16 PM" (or "Today, 10:16 PM").
  static String timeLabel(Map<String, dynamic> m) {
    final t = startTime(m);
    if (t == null) return '';
    final day = _isToday(t) ? 'Today' : '${t.day} ${_months[t.month - 1]}';
    return '$day, ${_clock(t)}';
  }

  /// "15 Oct" / "15 Oct Today".
  static String dateShort(Map<String, dynamic> m) {
    final t = startTime(m);
    if (t == null) return '';
    return '${t.day} ${_months[t.month - 1]}${_isToday(t) ? ' Today' : ''}';
  }

  /// "Oct 15, 2026".
  static String dateFull(Map<String, dynamic> m) {
    final t = startTime(m);
    if (t == null) return '';
    return '${_months[t.month - 1]} ${_two(t.day)}, ${t.year}';
  }

  /// "10:16 PM".
  static String clock(Map<String, dynamic> m) {
    final t = startTime(m);
    return t == null ? '' : _clock(t);
  }

  /// "Starts in 2h 10m" for upcoming matches.
  static String startsIn(Map<String, dynamic> m) {
    final t = startTime(m);
    if (t == null) return 'Starts soon';
    final diff = t.difference(DateTime.now());
    if (diff.isNegative || diff.inMinutes < 1) return 'Starting soon';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final mins = diff.inMinutes % 60;
    if (days > 0) return 'Starts in ${days}d ${hours}h';
    if (diff.inHours > 0) return 'Starts in ${diff.inHours}h ${mins}m';
    return 'Starts in ${diff.inMinutes}m';
  }

  /// "Innings 2" style label for live matches.
  static String liveStatus(Map<String, dynamic> m) {
    final scoring = m['scoring'];
    if (scoring is Map && scoring['current_period'] != null) {
      final type = scoring['period_type']?.toString();
      final unit = type == 'INNINGS' ? 'Innings' : 'Period';
      return '$unit ${scoring['current_period']}';
    }
    return m['status_label']?.toString() ?? 'Live';
  }
}
