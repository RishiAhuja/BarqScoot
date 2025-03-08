class PromoCode {
  final int id;
  final String code;
  final String type;
  final double discountPercent;
  final double maxDiscount;
  final int usageLimit;
  final int currentUses;
  final DateTime expiryDate;
  final bool isActive;
  final String createdBy;
  final String lastUpdatedBy;

  const PromoCode({
    required this.id,
    required this.code,
    required this.type,
    required this.discountPercent,
    required this.maxDiscount,
    required this.usageLimit,
    required this.currentUses,
    required this.expiryDate,
    required this.isActive,
    required this.createdBy,
    required this.lastUpdatedBy,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      id: json['ID'] as int,
      code: json['code'] as String,
      type: json['type'] as String,
      discountPercent: (json['discount_percent'] as num).toDouble(),
      maxDiscount: (json['max_discount'] as num).toDouble(),
      usageLimit: json['usage_limit'] as int,
      currentUses: json['current_uses'] as int,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      isActive: json['is_active'] as bool,
      createdBy: json['created_by'] as String,
      lastUpdatedBy: json['last_updated_by'] as String,
    );
  }
}
