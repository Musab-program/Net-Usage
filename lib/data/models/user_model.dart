import 'package:get/get.dart';
import 'package:net_uasge/data/models/usage_model.dart';

/// Model representing a user of the application.
class UserModel {
  /// Unique ID of the user.
  final int? id;

  /// Name of the user.
  final String name;

  /// Observable remaining balance.
  /// Used for reactive state management.
  final remainingBalance = 0.0.obs;

  /// List of usage records associated with the user.
  List<UsageModel>? usageRecords;

  /// Observable for UI expansion state in lists.
  final isExpanded = false.obs;

  UserModel({
    this.id,
    required this.name,
    required double remainingBalance,
    this.usageRecords,
  }) {
    // Initialize the observable value
    this.remainingBalance.value = remainingBalance;
  }

  /// Converts the model to a map for database storage.
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'remainingBalance': remainingBalance.value};
  }

  /// Creates a [UserModel] from a map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      remainingBalance: map['remainingBalance'] as double,
    );
  }
}
