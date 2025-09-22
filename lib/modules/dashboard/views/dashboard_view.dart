import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_uasge/core/constants/app_color.dart';
import 'package:net_uasge/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:net_uasge/core/widgets/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Scaffold(

      body: Obx(
            () {
          if (controller.totalMonthlyUsage.value == 0 &&
              controller.totalPayments.value == 0 &&
              controller.totalRemainingBalance.value == 0) {
            return Center(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildDataCard(
                    title: 'إجمالي الاستهلاك الشهري',
                    value: '0.0 جيجابايت',
                    icon: Icons.stacked_line_chart,
                    color: Colors.lightBlue.shade300,
                  ),
                  _buildDataCard(
                    title: 'إجمالي الدفعات',
                    value: '0.0 ريال',
                    icon: Icons.payments,
                    color: Colors.green.shade300,
                  ),
                  _buildDataCard(
                    title: 'إجمالي الرصيد المتبقي',
                    value: '0.0 ريال',
                    icon: Icons.account_balance_wallet,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 20),
                  const CustomText(text: 'لا توجد بيانات لعرض المخططات', textAlignment: TextAlign.center),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDataCard(
                title: 'إجمالي الاستهلاك الشهري',
                value: '${controller.totalMonthlyUsage.value.toStringAsFixed(2)} جيجابايت',
                icon: Icons.stacked_line_chart,
                color: Colors.lightBlue.shade300,
              ),
              _buildDataCard(
                title: 'إجمالي الدفعات',
                value: '${controller.totalPayments.value.toStringAsFixed(2)} ريال',
                icon: Icons.payments,
                color: Colors.green.shade300,
              ),
              _buildDataCard(
                title: 'إجمالي الرصيد المتبقي',
                value: '${controller.totalRemainingBalance.value.toStringAsFixed(2)} ريال',
                icon: Icons.account_balance_wallet,
                color: Colors.orange.shade300,
              ),

              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CustomText(text: 'استهلاك المستخدمين', textFontSize: 18, textFontWeight: FontWeight.bold),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: controller.usersUsageData.isEmpty ? 10 : controller.usersUsageData.map((e) => e['usage']).reduce((a, b) => a > b ? a : b) * 1.2,
                            barGroups: controller.usersUsageData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final data = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: data['usage'],
                                    color: AppColors.darkPrimaryColor,
                                    width: 15,

                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(),
                              rightTitles: const AxisTitles(),
                              topTitles: const AxisTitles(),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final name = controller.usersUsageData[value.toInt()]['name'];
                                    return CustomText(text: name, textFontSize: 10);
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

              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(text: 'أكثر المستخدمين استهلاكًا', textFontSize: 18, textFontWeight: FontWeight.bold),
                      const SizedBox(height: 10),
                      ...controller.topUsers.map(
                            (user) => ListTile(
                          leading: Icon(Icons.person, color: AppColors.darkPrimaryColor),
                          title: CustomText(text: user.name),
                          trailing: CustomText(text: '${user.usageRecords?.map((e) => e.weeklyUsage).fold(0.0, (sum, usage) => sum + usage) ?? 0.0} جيجابايت'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: CustomText(text: title, textFontSize: 16),
        trailing: CustomText(text: value, textFontSize: 20, textFontWeight: FontWeight.bold),
      ),
    );
  }
}