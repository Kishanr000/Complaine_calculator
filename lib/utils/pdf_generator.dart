import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class PDFGenerator {
  static Future<void> generateAndSharePDF(Map<String, dynamic> calculation) async {
    final pdf = pw.Document();

    final isCompliant = calculation['isCompliant'] as bool;
    final monthName = DateFormat.MMMM().format(DateTime(
      calculation['year'],
      calculation['month'],
    ));

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: isCompliant ? PdfColors.green50 : PdfColors.orange50,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Office Compliance Report',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: isCompliant ? PdfColors.green900 : PdfColors.orange900,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '$monthName ${calculation['year']}',
                      style: const pw.TextStyle(
                        fontSize: 16,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Generated: ${DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.now())}',
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Status
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: isCompliant ? PdfColors.green : PdfColors.orange,
                    width: 2,
                  ),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        'Compliance Status',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Text(
                      isCompliant ? '✓ COMPLIANT' : '⚠ NOT COMPLIANT',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: isCompliant ? PdfColors.green : PdfColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Details Table
              pw.Text(
                'Breakdown',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  _buildTableRow('Total Working Days (Mon-Fri)', calculation['workingDays'].toString()),
                  _buildTableRow('Required Days (60%)', calculation['requiredDays'].toString()),
                  _buildTableRow('Days Attended', calculation['attendedDays'].toString()),
                  _buildTableRow(
                    isCompliant ? 'Extra Days' : 'Days Remaining',
                    calculation['remainingDays'].toString(),
                  ),
                  _buildTableRow('Compliance Percentage', '${calculation['percentage'].toStringAsFixed(1)}%'),
                ],
              ),
              pw.SizedBox(height: 30),

              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Note: This calculation assumes Saturday and Sunday are off days. Only weekdays (Monday-Friday) are counted as working days.',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Formula: Required Days = CEILING(Working Days × 0.60)',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save and share
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/compliance_report_${monthName}_${calculation['year']}.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Office Compliance Report - $monthName ${calculation['year']}',
    );
  }

  static pw.TableRow _buildTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(value),
        ),
      ],
    );
  }
}
