class TeamInvitation {
  TeamInvitation({
    required this.id,
    required this.teamName,
    required this.captain,
    required this.sport,
    required this.logoUrl,
    required this.createdAt,
    this.rawJson,
  });

  final int id;
  final String teamName;
  final String captain;
  final String sport;
  final String? logoUrl;
  final String createdAt;
  final Map<String, dynamic>? rawJson;

  factory TeamInvitation.fromJson(Map<String, dynamic> json) {
    final team = json['team'] is Map<String, dynamic> ? json['team'] : <String, dynamic>{};
    final invitedBy = json['invited_by_user'] is Map<String, dynamic>
        ? json['invited_by_user']
        : <String, dynamic>{};
    final sportObj = team['sport'] is Map<String, dynamic> ? team['sport'] : <String, dynamic>{};
    final profile = invitedBy['profile'] is Map<String, dynamic> ? invitedBy['profile'] : null;

    final captainName = invitedBy['display_name'] ??
        invitedBy['name'] ??
        profile?['full_name'] ??
        'Captain';

    return TeamInvitation(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      teamName: (team['team_name'] ?? team['name'] ?? 'Unknown Team').toString(),
      captain: captainName.toString(),
      sport: (sportObj['name'] ?? 'Unknown Sport').toString(),
      logoUrl: team['team_logo_url'] ?? team['logo_url'],
      createdAt: (json['created_at'] ?? '').toString(),
      rawJson: json,
    );
  }
}
