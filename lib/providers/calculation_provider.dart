import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/calculation_record.dart';
import '../utils/compliance_calculator.dart';

class CalculationProvider extends ChangeNotifier {
  late Box<CalculationRecord> _calculationsBox;
  
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  int _attendedDays = 0;
  
  Map<String, dynamic>? _currentCalculation;

  CalculationProvider() {
    _calculationsBox = Hive.box<CalculationRecord>('calculations');
  }

  // Getters
  int get selectedYear => _selectedYear;
  int get selectedMonth => _selectedMonth;
  int get attendedDays => _attendedDays;
  Map<String, dynamic>? get currentCalculation => _currentCalculation;
  List<CalculationRecord> get allRecords => _calculationsBox.values.toList()
    ..sort((a, b) {
      final dateA = DateTime(a.year, a.month);
      final dateB = DateTime(b.year, b.month);
      return dateB.compareTo(dateA); // Most recent first
    });

  // Setters
  void setYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void setAttendedDays(int days) {
    _attendedDays = days;
    notifyListeners();
  }

  // Calculate compliance
  void calculate() {
    _currentCalculation = ComplianceCalculator.calculateMonthlyCompliance(
      year: _selectedYear,
      month: _selectedMonth,
      attendedDays: _attendedDays,
    );
    
    // Save to history
    _saveToHistory();
    notifyListeners();
  }

  void _saveToHistory() {
    if (_currentCalculation == null) return;

    final record = CalculationRecord(
      year: _currentCalculation!['year'],
      month: _currentCalculation!['month'],
      workingDays: _currentCalculation!['workingDays'],
      requiredDays: _currentCalculation!['requiredDays'],
      attendedDays: _currentCalculation!['attendedDays'],
      calculatedAt: DateTime.now(),
      percentage: _currentCalculation!['percentage'],
      isCompliant: _currentCalculation!['isCompliant'],
    );

    // Remove old record for same month/year if exists
    final existingKey = _calculationsBox.keys.firstWhere(
      (key) {
        final existing = _calculationsBox.get(key);
        return existing?.year == record.year && existing?.month == record.month;
      },
      orElse: () => null,
    );

    if (existingKey != null) {
      _calculationsBox.delete(existingKey);
    }

    _calculationsBox.add(record);
  }

  void deleteRecord(int index) {
    final key = _calculationsBox.keys.elementAt(index);
    _calculationsBox.delete(key);
    notifyListeners();
  }

  void clearHistory() {
    _calculationsBox.clear();
    notifyListeners();
  }

  void reset() {
    _currentCalculation = null;
    _attendedDays = 0;
    notifyListeners();
  }
}
