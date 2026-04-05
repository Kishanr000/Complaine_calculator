import 'package:hive/hive.dart';

part 'calculation_record.g.dart';

@HiveType(typeId: 0)
class CalculationRecord extends HiveObject {
  @HiveField(0)
  final int year;

  @HiveField(1)
  final int month;

  @HiveField(2)
  final int workingDays;

  @HiveField(3)
  final int requiredDays;

  @HiveField(4)
  final int attendedDays;

  @HiveField(5)
  final DateTime calculatedAt;

  @HiveField(6)
  final double percentage;

  @HiveField(7)
  final bool isCompliant;

  CalculationRecord({
    required this.year,
    required this.month,
    required this.workingDays,
    required this.requiredDays,
    required this.attendedDays,
    required this.calculatedAt,
    required this.percentage,
    required this.isCompliant,
  });

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String get displayDate => '$monthName $year';
}
