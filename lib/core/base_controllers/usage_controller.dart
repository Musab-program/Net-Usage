import 'package:get/get.dart';
import '../../data/models/usage_model.dart';
import '../../data/repositories/usage_repository.dart';

class UsageController extends GetxController {
  final UsageRepository _usageRepo = Get.find<UsageRepository>();

  var usageRecords = <UsageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllUsageRecords();
  }

  Future<void> addUsageRecord(UsageModel record) async {
    await _usageRepo.insertUsage(record);
    await getAllUsageRecords();
    Get.snackbar('نجاح', 'تمت إضافة سجل الاستخدام بنجاح.');
  }

  Future<void> updateUsageRecord(UsageModel record) async {
    await _usageRepo.updateUsage(record);
    await getAllUsageRecords();
    Get.snackbar('نجاح', 'تم تحديث سجل الاستخدام بنجاح.');
  }

  Future<List<UsageModel>> getUserUsageRecords(int userId) async {
    final usageList = await _usageRepo.getUserUsage(userId);
    return usageList;
  }

  Future<void> getAllUsageRecords() async {
    final usageList = await _usageRepo.getAllUsageRecords();
    usageRecords.assignAll(usageList);
  }

  Future<void> clearAllUsageRecords() async {
    await _usageRepo.clearAllUsageRecords();
    await getAllUsageRecords();
  }

  Future<void> addWeeklyUsage({
    required int userId,
    required double weeklyUsage,
    required String recordDate,
  }) async {
    final existingRecord = usageRecords
        .firstWhereOrNull((record) =>
    record.userId == userId && record.recordDate == recordDate);

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
    Get.snackbar('نجاح', 'تمت إضافة الاستهلاك الأسبوعي بنجاح.');
  }

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
    Get.snackbar('نجاح', 'تمت إضافة الدفعة بنجاح.');
  }
}