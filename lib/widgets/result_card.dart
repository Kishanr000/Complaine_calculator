import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/calculation_provider.dart';
import '../utils/pdf_generator.dart';

class ResultCard extends StatefulWidget {
  const ResultCard({super.key});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalculationProvider>();
    final calc = provider.currentCalculation!;
    final isCompliant = calc['isCompliant'] as bool;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          color: isCompliant 
            ? Colors.green.shade50
            : Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCompliant ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        isCompliant 
                          ? FontAwesomeIcons.circleCheck 
                          : FontAwesomeIcons.circleExclamation,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCompliant ? 'Compliant!' : 'Not Compliant',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCompliant ? Colors.green.shade900 : Colors.orange.shade900,
                            ),
                          ),
                          Text(
                            isCompliant 
                              ? 'You meet the 60% requirement'
                              : 'More days needed',
                            style: TextStyle(
                              color: isCompliant ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),

                // Stats Grid
                _buildStatRow(
                  context,
                  'Total Working Days',
                  calc['workingDays'].toString(),
                  FontAwesomeIcons.calendarDays,
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  'Required (60%)',
                  calc['requiredDays'].toString(),
                  FontAwesomeIcons.bullseye,
                  Colors.purple,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  'Days Attended',
                  calc['attendedDays'].toString(),
                  FontAwesomeIcons.userCheck,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  isCompliant ? 'Extra Days' : 'Days Remaining',
                  calc['remainingDays'].toString(),
                  isCompliant ? FontAwesomeIcons.star : FontAwesomeIcons.hourglassHalf,
                  isCompliant ? Colors.amber : Colors.red,
                ),
                const SizedBox(height: 12),
                _buildStatRow(
                  context,
                  'Compliance %',
                  '${calc['percentage'].toStringAsFixed(1)}%',
                  FontAwesomeIcons.chartLine,
                  Colors.indigo,
                ),
                
                const Divider(height: 32),

                // Export Button
                FilledButton.tonalIcon(
                  onPressed: () async {
                    try {
                      await PDFGenerator.generateAndSharePDF(calc);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.picture_as_pdf, color: Colors.white),
                                SizedBox(width: 12),
                                Text('PDF generated successfully!'),
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
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.filePdf, size: 18),
                  label: const Text('Export as PDF'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
