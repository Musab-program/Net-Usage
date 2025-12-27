import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/constants/app_color.dart';
import 'package:net_uasge/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:net_uasge/core/widgets/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';

/// View widget for the Dashboard screen.
///
/// Displays charts (Bar and Pie) and summary cards for usage statistics.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Scaffold(
      body: Obx(() {
        if (controller.totalMonthlyUsage.value == 0 &&
            controller.totalPayments.value == 0 &&
            controller.totalRemainingBalance.value == 0) {
          return Center(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 20),
                const CustomText(
                  text: 'لا توجد بيانات لعرض المخططات',
                  textAlignment: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDataCard(
                        title: 'الاستهلاك',
                        value: '0.0 GB',
                        icon: Icons.stacked_line_chart,
                        color: Colors.lightBlue.shade300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDataCard(
                        title: 'الدفعات',
                        value: '0.0 ريال',
                        icon: Icons.payments,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildDataCard(
                  title: 'الرصيد المتبقي',
                  value: '0.0 ريال',
                  icon: Icons.account_balance_wallet,
                  color: Colors.orange.shade300,
                ),
              ],
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Chart Section (Moved to Top)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: 'استهلاك المستخدمين',
                          textFontSize: 18,
                          textFontWeight: FontWeight.bold,
                        ),
                        Icon(
                          Icons.bar_chart_rounded,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250, // Increased height slightly
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: controller.usersUsageData.isEmpty
                              ? 10
                              : controller.usersUsageData
                                        .map((e) => e['usage'])
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: false), // Hide grid lines
                          borderData: FlBorderData(show: false), // Hide border
                          barGroups: controller.usersUsageData
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final data = entry.value;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data['usage'],
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          AppColors.lightPrimaryColor,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      width: 18,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >=
                                      controller.usersUsageData.length) {
                                    return const SizedBox();
                                  }
                                  final name = controller
                                      .usersUsageData[value.toInt()]['name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CustomText(
                                      text: name,
                                      textFontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Summary Cards Row (3 Cards)
            Row(
              children: [
                Expanded(
                  child: _buildDataCard(
                    title: 'الاستهلاك',
                    value:
                        '${controller.totalMonthlyUsage.value.toStringAsFixed(1)} GB',
                    icon: Icons.wifi_rounded,
                    color: Colors.blueAccent,
                    onTap: () => _showDetailsDialog(
                      context,
                      'تفاصيل الاستهلاك',
                      controller.usersUsageData,
                      'usage',
                      'GB',
                      headerColor: Colors.blueAccent,
                      headerIcon: Icons.wifi_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDataCard(
                    title: 'المدفوعات',
                    value:
                        '${controller.totalPayments.value.toStringAsFixed(0)}',
                    icon: Icons.attach_money_rounded,
                    color: Colors.green,
                    onTap: () => _showDetailsDialog(
                      context,
                      'تفاصيل المدفوعات',
                      controller.usersPaymentsData,
                      'payment',
                      'ريال',
                      headerColor: Colors.green,
                      headerIcon: Icons.attach_money_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDataCard(
                    title: 'المتبقي',
                    value:
                        '${controller.totalRemainingBalance.value.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_rounded,
                    color: Colors.orange,
                    onTap: () => _showDetailsDialog(
                      context,
                      'تفاصيل الأرصدة',
                      controller.usersBalanceData,
                      'balance',
                      'ريال',
                      headerColor: Colors.orange,
                      headerIcon: Icons.account_balance_wallet_rounded,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Pie Chart Section (New)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CustomText(
                      text: 'توزيع الاستهلاك',
                      textFontSize: 16,
                      textFontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30, // Reduced from 40
                          sections: controller.usersUsageData
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final data = entry.value;
                                final isLarge =
                                    index == 0; // Highlight first/max user
                                final value = (data['usage'] as double);
                                final total =
                                    controller.totalMonthlyUsage.value > 0
                                    ? controller.totalMonthlyUsage.value
                                    : 1.0;
                                final percentage = (value / total) * 100;

                                // Simple color generation
                                final List<Color> colors = [
                                  AppColors.primaryColor,
                                  Colors.blueAccent,
                                  Colors.orangeAccent,
                                  Colors.greenAccent,
                                  Colors.purpleAccent,
                                  Colors.redAccent,
                                ];
                                return PieChartSectionData(
                                  color: colors[index % colors.length],
                                  value: value,
                                  title: '${percentage.toStringAsFixed(1)}%',
                                  radius: isLarge
                                      ? 55
                                      : 45, // Reduced from 60/50
                                  titleStyle: const TextStyle(
                                    fontSize: 10, // Slightly smaller text
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Legend
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: controller.usersUsageData.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final data = entry.value;
                        final List<Color> colors = [
                          AppColors.primaryColor,
                          Colors.blueAccent,
                          Colors.orangeAccent,
                          Colors.greenAccent,
                          Colors.purpleAccent,
                          Colors.redAccent,
                        ];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors[index % colors.length],
                              ),
                            ),
                            const SizedBox(width: 4),
                            CustomText(text: data['name'], textFontSize: 12),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 5. Top Users List
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'أكثر المستخدمين استهلاكًا',
                      textFontSize: 16,
                      textFontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    ...controller.topUsers.map(
                      (user) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        title: CustomText(text: user.name, textFontSize: 14),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CustomText(
                            text:
                                '${user.usageRecords?.map((e) => e.weeklyUsage).fold(0.0, (sum, usage) => sum + usage).toStringAsFixed(1) ?? 0.0} GB',
                            textFontSize: 12,
                            textFontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDataCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              FittedBox(
                child: CustomText(
                  text: value,
                  textFontSize: 18,
                  textFontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              CustomText(text: title, textFontSize: 12, textColor: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> data,
    String valueKey,
    String unit, {
    Color headerColor = AppColors.primaryColor,
    IconData? headerIcon,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 500),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stylish Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: headerColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(headerIcon ?? Icons.list_alt, color: headerColor),
                    const SizedBox(width: 8),
                    CustomText(
                      text: title,
                      textFontSize: 18,
                      textFontWeight: FontWeight.bold,
                      textColor: headerColor,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                      color:
                          Theme.of(
                            context,
                          ).iconTheme.color?.withValues(alpha: 0.5) ??
                          Colors.grey,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // List Content
              Expanded(
                child: data.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty_rounded,
                            size: 48,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const CustomText(
                            text: 'لا توجد بيانات متاحة حالياً',
                            textColor: Colors.grey,
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final value = item[valueKey] as double;

                          // Custom styling for rows
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: headerColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: headerColor.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: headerColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: Text(
                                    item['name'][0].toUpperCase(),
                                    style: TextStyle(
                                      color: headerColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomText(
                                    text: item['name'],
                                    textFontSize: 14,
                                    textFontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: headerColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText(
                                    text: '${value.toStringAsFixed(1)} $unit',
                                    textFontWeight: FontWeight.bold,
                                    textColor: headerColor,
                                    textFontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeOutCubic,
    );
  }
}
