import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';
import 'package:net_uasge/modules/home/views/usage_dialog.dart';
import 'package:net_uasge/modules/home/views/payment_dialog.dart';
import 'package:net_uasge/core/constants/app_color.dart';
import 'package:net_uasge/core/widgets/custom_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(
            child: CustomText(text: 'لا يوجد مستخدمون لعرضهم.'),
          );
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return UserCard(user: user, controller: controller);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.reconcileData(),
        label: const CustomText(text: 'ترحيل البيانات'),
        icon: const Icon(Icons.sync),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserModel user;
  final HomeController controller;

  const UserCard({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    final totalUsage = user.usageRecords?.map((e) => e.weeklyUsage).fold(0.0, (sum, usage) => sum + usage) ?? 0.0;
    final totalAmountDue = totalUsage * controller.gigabytePrice.value;
    final totalAmountPaid = user.usageRecords?.map((e) => e.amountPaid).fold(0.0, (sum, amount) => sum + amount) ?? 0.0;
    final finalBalance = (user.remainingBalance.value + totalAmountDue) - totalAmountPaid;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: CustomText(text: user.name),
            subtitle: Obx(
                  () => CustomText(text: 'المبلغ المتبقي: ${user.remainingBalance.value.toStringAsFixed(2)}'),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.payment, color: AppColors.accentColor),
                  onPressed: () {
                    Get.dialog(PaymentDialog(userId: user.id!));
                  },
                ),
                Obx(
                      () => IconButton(
                    icon: Icon(user.isExpanded.value ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      user.isExpanded.value = !user.isExpanded.value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Obx(
                () => user.isExpanded.value
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: CustomText(text: 'الأسبوع', textFontSize: 14)),
                    DataColumn(label: CustomText(text: 'الاستخدام (GB)', textFontSize: 14)),
                    DataColumn(label: CustomText(text: 'المبلغ المستحق', textFontSize: 14)),
                    DataColumn(label: CustomText(text: '    أضف', textFontSize: 14)),
                  ],
                  rows: [
                    ...List.generate(4, (index) {
                      final weekNumber = index + 1;
                      final usage = user.usageRecords
                          ?.firstWhereOrNull((r) => r.recordDate.contains('الأسبوع $weekNumber'))
                          ?.weeklyUsage ??
                          0.0;
                      final amountDue = usage * controller.gigabytePrice.value;
                      return DataRow(cells: [
                        DataCell(CustomText(text: 'الأسبوع $weekNumber', textFontSize: 14)),
                        DataCell(CustomText(text: '   ${usage.toStringAsFixed(2)}', textFontSize: 14)),
                        DataCell(CustomText(text: '   ${amountDue.toStringAsFixed(2)}', textFontSize: 14)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              Get.dialog(UsageDialog(userId: user.id!, week: weekNumber));
                            },
                          ),
                        ),
                      ]);
                    }),
                    DataRow(cells: [
                      const DataCell(CustomText(text: 'الإجمالي', textFontWeight: FontWeight.bold, textFontSize: 12)),
                      DataCell(CustomText(text: '   ${totalUsage.toStringAsFixed(2)}', textFontWeight: FontWeight.bold, textFontSize: 12)),
                      DataCell(CustomText(text: '   ${totalAmountDue.toStringAsFixed(2)}', textFontWeight: FontWeight.bold, textFontSize: 12)),
                      const DataCell(SizedBox()),
                    ]),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
          Obx(
                () => user.isExpanded.value
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'المبلغ المدفوع: ${totalAmountPaid.toStringAsFixed(2)} ريال',
                    textFontSize: 16,
                  ),
                  CustomText(
                    text: 'المبلغ النهائي:  ${finalBalance.toStringAsFixed(2)} ريال',
                    textFontSize: 16,
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}