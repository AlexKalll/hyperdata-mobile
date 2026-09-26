class WalletTransaction {
  final String id;
  final double amount;
  final String type;
  final String status;
  final DateTime? createdDate;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.createdDate,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    final rawDate = json['created_date']?.toString();

    return WalletTransaction(
      id: json['id']?.toString() ?? '',
      amount: rawAmount is num
          ? rawAmount.toDouble()
          : double.tryParse(rawAmount?.toString() ?? '') ?? 0,
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdDate: rawDate == null ? null : DateTime.tryParse(rawDate),
    );
  }
}
