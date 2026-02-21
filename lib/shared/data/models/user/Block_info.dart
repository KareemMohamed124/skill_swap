class BlockInfo {
  final bool isBlocked;
  final String? blockReason;

  BlockInfo({required this.isBlocked, this.blockReason});

  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    return BlockInfo(
      isBlocked: json['isBlocked'] ?? false,
      blockReason: json['blockReason'] ?? '',
    );
  }
}
