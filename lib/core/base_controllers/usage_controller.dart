import 'package:get/get.dart';
import '../../data/models/usage_model.dart';
import '../../data/repositories/usage_repository.dart';

class UsageController extends GetxController {
  final UsageRepository _usageRepo = Get.find<UsageRepository>();

  var usageRecords = <UsageModel>[].obs;

  Future<void> addUsageRecord(UsageModel record) async {
    await _usageRepo.insertUsage(record);
    getUserUsageRecords(record.userId);
  }

  Future<void> updateUsageRecord(UsageModel record) async {
    await _usageRepo.updateUsage(record);
    getUserUsageRecords(record.userId);
  }

  Future<void> getUserUsageRecords(int userId) async {
    final usageList = await _usageRepo.getUserUsage(userId);
    usageRecords.value = usageList;
  }
}