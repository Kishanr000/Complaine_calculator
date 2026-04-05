import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculation_provider.dart';
import '../utils/compliance_calculator.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculationProvider>();
    final now = DateTime.now();
    final currentMonthWorkingDays = ComplianceCalculator.calculateWorkingDays(now.year, now.month);
    final requiredDays = ComplianceCalculator.calculateRequiredDays(currentMonthWorkingDays);
    final monthName = DateFormat.MMMM().format(now);

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Month Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Month',
              monthName,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Working Days (Mon-Fri)',
              currentMonthWorkingDays.toString(),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Required for 60%',
              '$requiredDays days',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Total Calculations',
              provider.allRecords.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
