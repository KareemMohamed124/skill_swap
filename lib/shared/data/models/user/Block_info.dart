class BlockInfo {
  final bool isBlocked;
  final String? blockReason;

  BlockInfo({required this.isBlocked, this.blockReason});

  Map<String, dynamic> toJson() {
    return {"isBlocked": isBlocked, "blockReason": blockReason};
  }

<<<<<<< HEAD
  factory BlockInfo.empty() {
    return BlockInfo(isBlocked: false, blockReason: "");
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  factory BlockInfo.fromJson(Map<String, dynamic> json) {
    return BlockInfo(
      isBlocked: json['isBlocked'] ?? false,
      blockReason: json['blockReason'] ?? '',
    );
  }
}
