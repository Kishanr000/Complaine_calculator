import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculation_provider.dart';

class CalculationCard extends StatefulWidget {
  const CalculationCard({super.key});

  @override
  State<CalculationCard> createState() => _CalculationCardState();
}

class _CalculationCardState extends State<CalculationCard> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _attendedController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _attendedController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculationProvider>();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Calculate Compliance',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Month Selector
              DropdownButtonFormField<int>(
                value: provider.selectedMonth,
                decoration: InputDecoration(
                  labelText: 'Month',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: List.generate(12, (index) {
                  final month = index + 1;
                  final monthName = DateFormat.MMMM().format(DateTime(2024, month));
                  return DropdownMenuItem(
                    value: month,
                    child: Text(monthName),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    provider.setMonth(value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Year Selector
              DropdownButtonFormField<int>(
                value: provider.selectedYear,
                decoration: InputDecoration(
                  labelText: 'Year',
                  prefixIcon: const Icon(Icons.event),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: List.generate(5, (index) {
                  final year = DateTime.now().year - 1 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    provider.setYear(value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Attended Days Input
              TextFormField(
                controller: _attendedController,
                decoration: InputDecoration(
                  labelText: 'Days Attended',
                  hintText: 'Enter number of days attended',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter attended days';
                  }
                  final days = int.tryParse(value);
                  if (days == null) {
                    return 'Please enter a valid number';
                  }
                  if (days < 0) {
                    return 'Days cannot be negative';
                  }
                  if (days > 31) {
                    return 'Days cannot exceed 31';
                  }
                  return null;
                },
                onChanged: (value) {
                  final days = int.tryParse(value);
                  if (days != null) {
                    provider.setAttendedDays(days);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Calculate Button
              ScaleTransition(
                scale: _scaleAnimation,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      provider.calculate();
                      
                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Calculation complete!'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Calculate',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Reset Button
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  _attendedController.clear();
                  provider.reset();
                  provider.setMonth(DateTime.now().month);
                  provider.setYear(DateTime.now().year);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
