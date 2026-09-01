/// Static design-time model for a single player row on the "Create New
/// Team" form. No persistence/network layer — purely for UI presentation.
class TeamPlayerInfo {
  const TeamPlayerInfo({this.id, required this.name, required this.phone, this.isCaptain = false});

  final int? id;
  final String name;
  final String phone;
  final bool isCaptain;
}
