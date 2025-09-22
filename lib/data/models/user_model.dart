import 'package:get/get.dart';
import 'package:net_uasge/data/models/usage_model.dart';

class UserModel {
  final int? id;
  final String name;
  // اجعل remainingBalance متغيراً مراقباً باستخدام .obs
  final remainingBalance = 0.0.obs;
  List<UsageModel>? usageRecords;

  // إضافة متغير مراقب لحالة التوسع
  final isExpanded = false.obs;

  UserModel({
    this.id,
    required this.name,
    required double remainingBalance, // غيرنا هذا ليكون required
    this.usageRecords,
  }) {
    // تعيين القيمة الأولية للمتغير المراقب
    this.remainingBalance.value = remainingBalance;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // استخدم .value للحصول على القيمة
      'remainingBalance': remainingBalance.value,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      remainingBalance: map['remainingBalance'] as double,
    );
  }
}