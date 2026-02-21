class BlockedMe {
  final DateTime? blockedUntil;
  final String blockReason;
  final bool isBlocked;

  BlockedMe({
    this.blockedUntil,
    required this.blockReason,
    required this.isBlocked,
  });

  factory BlockedMe.fromJson(Map<String, dynamic> json) {
    return BlockedMe(
      blockedUntil: json['blockedUntil'] != null
          ? DateTime.parse(json['blockedUntil'])
          : null,
      blockReason: json['blockReason'] ?? '',
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockedUntil': blockedUntil?.toIso8601String(),
      'blockReason': blockReason,
      'isBlocked': isBlocked,
    };
  }

  factory BlockedMe.empty() {
    return BlockedMe(blockReason: "", isBlocked: false);
  }
}
