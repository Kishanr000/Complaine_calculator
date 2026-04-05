import 'dart:math';

class ComplianceCalculator {
  /// Calculate working days in a month (Monday to Friday)
  /// Excludes Saturdays and Sundays
  static int calculateWorkingDays(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    int workingDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      // 1 = Monday, 7 = Sunday
      if (date.weekday >= 1 && date.weekday <= 5) {
        workingDays++;
      }
    }

    return workingDays;
  }

  /// Calculate required days for 60% compliance
  /// Uses ceiling to round up
  static int calculateRequiredDays(int workingDays) {
    final required = (workingDays * 0.6);
    return required.ceil();
  }

  /// Calculate how many more days needed to meet compliance
  static int calculateRemainingDays(int requiredDays, int attendedDays) {
    final remaining = requiredDays - attendedDays;
    return remaining > 0 ? remaining : 0;
  }

  /// Calculate current compliance percentage
  static double calculateCompliancePercentage(int attendedDays, int workingDays) {
    if (workingDays == 0) return 0.0;
    return (attendedDays / workingDays) * 100;
  }

  /// Check if compliance is met
  static bool isCompliant(int attendedDays, int requiredDays) {
    return attendedDays >= requiredDays;
  }

  /// Get list of weekdays for a given month
  static List<DateTime> getWorkingDaysInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    List<DateTime> workingDays = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      if (date.weekday >= 1 && date.weekday <= 5) {
        workingDays.add(date);
      }
    }

    return workingDays;
  }

  /// Calculate compliance for multiple months
  static Map<String, dynamic> calculateMonthlyCompliance({
    required int year,
    required int month,
    required int attendedDays,
    List<DateTime>? holidays,
  }) {
    int workingDays = calculateWorkingDays(year, month);
    
    // Subtract holidays if provided
    if (holidays != null) {
      for (var holiday in holidays) {
        if (holiday.year == year && 
            holiday.month == month && 
            holiday.weekday >= 1 && 
            holiday.weekday <= 5) {
          workingDays--;
        }
      }
    }

    final requiredDays = calculateRequiredDays(workingDays);
    final remainingDays = calculateRemainingDays(requiredDays, attendedDays);
    final percentage = calculateCompliancePercentage(attendedDays, workingDays);
    final isCompliant = ComplianceCalculator.isCompliant(attendedDays, requiredDays);

    return {
      'workingDays': workingDays,
      'requiredDays': requiredDays,
      'attendedDays': attendedDays,
      'remainingDays': remainingDays,
      'percentage': percentage,
      'isCompliant': isCompliant,
      'year': year,
      'month': month,
    };
  }
}
