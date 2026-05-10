import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionProvider>().transactions;
    final now = DateTime.now();

    double maxAmount = 0;
    final List<BarChartGroupData> barGroups = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));

      final daySum = transactions
          .where((t) => !t.isIncome)
          .where(
              (t) => t.date.year == day.year && t.date.month == day.month && t.date.day == day.day)
          .fold(0.0, (sum, t) => sum + t.amount);

      maxAmount = daySum > maxAmount ? daySum : maxAmount;

      barGroups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: daySum,
              color: Theme.of(context).colorScheme.error,
              width: 16,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    final maxY = maxAmount == 0 ? 100.0 : maxAmount * 1.2;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Spending',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 20),
      AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  maxY: maxY,
                  minY: 0,
                  barGroups: barGroups,
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index > 6) return const SizedBox.shrink();
                          
                          final day = DateTime(now.year, now.month, now.day)
                              .subtract(Duration(days: 6 - index));
                          
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text(
                              DateFormat('E').format(day)[0],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final x = group.x.toInt();
                        final day = DateTime(now.year, now.month, now.day)
                            .subtract(Duration(days: 6 - x));
                        final label = DateFormat('EEEE').format(day);
                        return BarTooltipItem(
                          '$label\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: '${rod.toY.toStringAsFixed(0)} Rs',
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}