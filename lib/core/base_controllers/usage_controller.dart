import 'package:get/get.dart';
import '../../data/models/usage_model.dart';
import '../../data/repositories/usage_repository.dart';

/// Controller for managing internet usage records.
///
/// Handles CRUD operations for [UsageModel] entities.
class UsageController extends GetxController {
  final UsageRepository _usageRepo = Get.find<UsageRepository>();

  /// List of all usage records.
  var usageRecords = <UsageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllUsageRecords();
  }

  /// Adds a new usage record to the database.
  ///
  /// [record] is the [UsageModel] object to be added.
  Future<void> addUsageRecord(UsageModel record) async {
    await _usageRepo.insertUsage(record);
    await getAllUsageRecords();
  }

  /// Updates an existing usage record in the database.
  ///
  /// [record] is the [UsageModel] object with updated values.
  Future<void> updateUsageRecord(UsageModel record) async {
    await _usageRepo.updateUsage(record);
    await getAllUsageRecords();
  }

  /// Retrieves usage records for a specific user.
  ///
  /// [userId] is the unique identifier of the user.
  /// Returns a list of [UsageModel] filtered by the user ID.
  Future<List<UsageModel>> getUserUsageRecords(int userId) async {
    final usageList = await _usageRepo.getUserUsage(userId);
    return usageList;
  }

  /// Retrieves all usage records from the database and updates [usageRecords].
  Future<void> getAllUsageRecords() async {
    final usageList = await _usageRepo.getAllUsageRecords();
    usageRecords.assignAll(usageList);
  }

  /// Deletes all usage records from the database.
  Future<void> clearAllUsageRecords() async {
    await _usageRepo.clearAllUsageRecords();
    await getAllUsageRecords();
  }

  /// Adds or updates a weekly usage record for a user.
  ///
  /// If a record exists for the given [userId] and [recordDate], it increments the usage.
  /// Otherwise, it creates a new record.
  ///
  /// [userId] The user's ID.
  /// [weeklyUsage] The amount of data used.
  /// [recordDate] The date of the record.
  Future<void> addWeeklyUsage({
    required int userId,
    required double weeklyUsage,
    required String recordDate,
  }) async {
    final existingRecord = usageRecords.firstWhereOrNull(
      (record) => record.userId == userId && record.recordDate == recordDate,
    );

    if (existingRecord != null) {
      final updatedRecord = UsageModel(
        id: existingRecord.id,
        userId: userId,
        weeklyUsage: existingRecord.weeklyUsage + weeklyUsage,
        amountPaid: existingRecord.amountPaid,
        recordDate: recordDate,
      );
      await _usageRepo.updateUsage(updatedRecord);
    } else {
      final newRecord = UsageModel(
        userId: userId,
        weeklyUsage: weeklyUsage,
        amountPaid: 0.0,
        recordDate: recordDate,
      );
      await _usageRepo.insertUsage(newRecord);
    }
    await getAllUsageRecords();
  }

  /// Adds a payment record for a user.
  ///
  /// Creates a new usage record with 0 usage and the specified payment amount.
  ///
  /// [userId] The user's ID.
  /// [amountPaid] The amount paid by the user.
  Future<void> addPayment({
    required int userId,
    required double amountPaid,
  }) async {
    final newRecord = UsageModel(
      userId: userId,
      weeklyUsage: 0.0,
      amountPaid: amountPaid,
      recordDate: 'Payment ${DateTime.now().toIso8601String()}',
    );
    await _usageRepo.insertUsage(newRecord);
    await getAllUsageRecords();
  }
}
