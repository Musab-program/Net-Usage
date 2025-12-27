import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/data/models/user_model.dart';
import 'package:net_uasge/modules/home/controllers/home_controller.dart';
import 'package:net_uasge/modules/home/views/usage_dialog.dart';
import 'package:net_uasge/modules/home/views/payment_dialog.dart';
import 'package:net_uasge/core/constants/app_color.dart';
import 'package:net_uasge/core/widgets/custom_text.dart';
import 'package:net_uasge/core/base_controllers/app_controller.dart';

/// View widget for the Home screen.
///
/// Displays a list of users with their usage and balance details.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            controller.resetFabTimer();
          }
          return false;
        },
        child: Obx(() {
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
      ),
      floatingActionButton: Obx(
        () => AnimatedScale(
          scale: controller.isFabVisible.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: FloatingActionButton.extended(
            onPressed: () => controller.reconcileData(),
            label: const CustomText(text: 'ترحيل البيانات'),
            icon: const Icon(Icons.sync),
          ),
        ),
      ),
    );
  }
}

/// Widget suitable for displaying a single user's summary card.
class UserCard extends StatelessWidget {
  final UserModel user;
  final HomeController controller;

  const UserCard({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: CustomText(text: user.name),
            subtitle: Obx(
              () => CustomText(
                text:
                    'المبلغ المتبقي: ${user.remainingBalance.value.toStringAsFixed(2)}',
              ),
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
                    icon: Icon(
                      user.isExpanded.value
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      user.isExpanded.value = !user.isExpanded.value;
                    },
                  ),
                ),
              ],
            ),
          ),

          // Expanded Content (Table)
          Obx(() {
            if (!user.isExpanded.value) return const SizedBox.shrink();

            final totalUsage =
                user.usageRecords
                    ?.map((e) => e.weeklyUsage)
                    .fold(0.0, (sum, usage) => sum + usage) ??
                0.0;
            final totalAmountDue = totalUsage * controller.gigabytePrice.value;
            final totalAmountPaid =
                user.usageRecords
                    ?.map((e) => e.amountPaid)
                    .fold(0.0, (sum, amount) => sum + amount) ??
                0.0;
            final finalBalance =
                (user.remainingBalance.value + totalAmountDue) -
                totalAmountPaid;
            final appController = Get.find<AppController>();
            final isDark = appController.isDarkMode.value;

            return Column(
              children: [
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Table Implementation
                      _buildUsageTable(user, controller, isDark),
                      const SizedBox(height: 16),
                      // Summary Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow(
                              'المبلغ المدفوع',
                              totalAmountPaid,
                              Colors.green.shade700,
                              isBold: true,
                            ),
                            const Divider(height: 16, color: Colors.green),
                            _buildSummaryRow(
                              'المبلغ النهائي',
                              finalBalance,
                              _getBalanceColor(finalBalance),
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    double value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          textFontSize: 15,
          textFontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        Text(
          '${value.toStringAsFixed(2)} ريال',
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildUsageTable(
    UserModel user,
    HomeController controller,
    bool isDark,
  ) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.4),
        3: FlexColumnWidth(0.8),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade400, // Darker for light mode
                width: 1.0,
              ),
            ),
          ),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                text: 'الأسبوع',
                textFontSize: 13,
                textAlignment: TextAlign.center,
                textFontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                text: 'الاستخدام',
                textFontSize: 13,
                textAlignment: TextAlign.center,
                textFontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                text: 'المبلغ',
                textFontSize: 13,
                textAlignment: TextAlign.center,
                textFontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CustomText(
                text: 'إضافة',
                textFontSize: 13,
                textAlignment: TextAlign.center,
                textFontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ...List.generate(4, (index) {
          final weekNumber = index + 1;
          final usage =
              user.usageRecords
                  ?.firstWhereOrNull(
                    (r) => r.recordDate.contains('الأسبوع $weekNumber'),
                  )
                  ?.weeklyUsage ??
              0.0;
          final amountDue = usage * controller.gigabytePrice.value;
          return TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade400, // Darker for light mode
                  width: 0.5,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomText(
                  text: 'أسبوع $weekNumber',
                  textFontSize: 13,
                  textAlignment: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomText(
                  text: usage.toStringAsFixed(2),
                  textFontSize: 13,
                  textAlignment: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CustomText(
                  text: amountDue.toStringAsFixed(2),
                  textFontSize: 13,
                  textAlignment: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 22,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => Get.dialog(
                      UsageDialog(userId: user.id!, week: weekNumber),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Color _getBalanceColor(double balance) {
    if (balance <= 500) return Colors.green;
    if (balance <= 1500) return Colors.orange;
    return Colors.red;
  }
}
