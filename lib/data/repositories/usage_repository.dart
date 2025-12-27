import '../local_storage/usage_local_storage.dart';
import '../models/usage_model.dart';

/// Repository for managing internet usage data.
class UsageRepository {
  final UsageLocalStorage _usageStorage;

  UsageRepository(this._usageStorage);

  /// Retrieves usage records for a specific user.
  ///
  /// [userId] The ID of the user.
  Future<List<UsageModel>> getUserUsage(int userId) async {
    return await _usageStorage.getUserUsage(userId);
  }

  /// Inserts a new usage record.
  ///
  /// [usage] The usage model to insert.
  Future<int> insertUsage(UsageModel usage) async {
    return await _usageStorage.insertUsage(usage);
  }

  /// Updates an existing usage record.
  ///
  /// [usage] The usage model to update.
  Future<int> updateUsage(UsageModel usage) async {
    return await _usageStorage.updateUsage(usage);
  }

  /// Deletes all usage records from the database.
  Future<void> clearAllUsageRecords() async {
    return _usageStorage.clearAllUsageRecords();
  }

  /// Retrieves all usage records stored in the database.
  Future<List<UsageModel>> getAllUsageRecords() async {
    return _usageStorage.getAllUsageRecords();
  }
}
