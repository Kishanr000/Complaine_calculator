import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    subtitle: const Text('Always use light theme'),
                    secondary: const FaIcon(FontAwesomeIcons.sun),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Always use dark theme'),
                    secondary: const FaIcon(FontAwesomeIcons.moon),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    subtitle: const Text('Follow system theme'),
                    secondary: const FaIcon(FontAwesomeIcons.circleHalfStroke),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.circleInfo),
            title: const Text('Version'),
            subtitle: const Text('2.0.0'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.code),
            title: const Text('Built with'),
            subtitle: const Text('Flutter & Material Design 3'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.calculator),
            title: const Text('Compliance Formula'),
            subtitle: const Text('Required = CEILING(Working Days × 0.60)'),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Help'),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.questionCircle),
            title: const Text('How it works'),
            subtitle: const Text('Learn about the 60% compliance rule'),
            onTap: () => _showHowItWorksDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showHowItWorksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('How It Works'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'The 60% Compliance Rule',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'To meet office attendance compliance, you must attend at least 60% of working days in a month.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Working Days',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Only Monday through Friday count as working days\n'
                '• Saturday and Sunday are excluded\n'
                '• The calculator automatically counts weekdays in your selected month',
              ),
              const SizedBox(height: 16),
              const Text(
                'Calculation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Required Days = CEILING(Working Days × 0.60)\n\n'
                'Example: If a month has 22 working days:\n'
                '22 × 0.60 = 13.2\n'
                'CEILING(13.2) = 14 days required',
              ),
              const SizedBox(height: 16),
              const Text(
                'The CEILING function rounds up to ensure you always meet the minimum requirement.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
