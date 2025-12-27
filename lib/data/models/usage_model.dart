/// Model representing a single internet usage record.
class UsageModel {
  /// Unique ID of the record.
  final int? id;

  /// ID of the user associated with this record.
  final int userId;

  /// The amount of data used (in GB).
  final double weeklyUsage;

  /// The amount paid by the user.
  final double amountPaid;

  /// The date of the record.
  final String recordDate;

  UsageModel({
    this.id,
    required this.userId,
    required this.weeklyUsage,
    required this.amountPaid,
    required this.recordDate,
  });

  /// Converts the model to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weeklyUsage': weeklyUsage,
      'amountPaid': amountPaid,
      'recordDate': recordDate,
    };
  }

  /// Creates a [UsageModel] from a map.
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
