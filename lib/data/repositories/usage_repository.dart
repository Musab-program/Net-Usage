import '../local_storage/usage_local_storage.dart';
import '../models/usage_model.dart';

class UsageRepository {
  final UsageLocalStorage _usageStorage;

  UsageRepository(this._usageStorage);

  Future<List<UsageModel>> getUserUsage(int userId) async {
    return await _usageStorage.getUserUsage(userId);
  }

  Future<int> insertUsage(UsageModel usage) async {
    return await _usageStorage.insertUsage(usage);
  }

  Future<int> updateUsage(UsageModel usage) async {
    return await _usageStorage.updateUsage(usage);
  }
}