class UsageModel {
  final int? id;
  final int userId;
  final double weeklyUsage;
  final double amountPaid;
  final String recordDate;

  UsageModel({
    this.id,
    required this.userId,
    required this.weeklyUsage,
    required this.amountPaid,
    required this.recordDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weeklyUsage': weeklyUsage,
      'amountPaid': amountPaid,
      'recordDate': recordDate,
    };
  }

  factory UsageModel.fromMap(Map<String, dynamic> map) {
    return UsageModel(
      id: map['id'] as int?,
      userId: map['userId'] as int,
      weeklyUsage: map['weeklyUsage'] as double,
      amountPaid: map['amountPaid'] as double,
      recordDate: map['recordDate'] as String,
    );
  }
}