# 🚀 Compliance Calculator 2.0

A modern, feature-rich Flutter application for calculating office attendance compliance with a 60% working days requirement.

## ✨ Features

### Core Functionality
- **Smart Calculation**: Automatically calculates working days (Mon-Fri) excluding weekends
- **60% Compliance Rule**: Uses CEILING function to determine exact required days
- **Real-time Feedback**: Instant compliance status with visual indicators

### Modern UI/UX
- ✅ **Material Design 3**: Latest Material You design language
- ✅ **Dark Mode**: Full dark/light theme support with system preference detection
- ✅ **Smooth Animations**: Polished transitions and micro-interactions
- ✅ **Responsive Design**: Works beautifully on all screen sizes

### Data Management
- ✅ **Local Persistence**: Hive database for storing calculation history
- ✅ **Calculation History**: Track compliance across multiple months
- ✅ **Visual Charts**: Interactive line chart showing compliance trends (fl_chart)

### Export & Sharing
- ✅ **PDF Export**: Professional PDF reports with formatted data
- ✅ **Share Functionality**: Easy sharing via system share sheet

### State Management
- ✅ **Provider Pattern**: Clean, scalable state management
- ✅ **Reactive UI**: Automatic updates across all screens

## 📋 How It Works

### The 60% Rule
To meet office attendance compliance, employees must attend at least **60% of working days** in a month.

### Working Days
- Only **Monday through Friday** count as working days
- **Saturday and Sunday** are automatically excluded
- The app calculates exact weekdays for any month/year

### Formula
```
Required Days = CEILING(Working Days × 0.60)
```

**Example:**
- Month has 22 working days
- 22 × 0.60 = 13.2
- CEILING(13.2) = **14 days required**

The CEILING function ensures you always round up to meet the minimum requirement.

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.x |
| **State Management** | Provider |
| **Local Database** | Hive |
| **UI Design** | Material Design 3 |
| **Charts** | FL Chart |
| **PDF Generation** | pdf package |
| **Fonts** | Google Fonts |
| **Icons** | Font Awesome Flutter |

## 📱 Installation & Setup

### Prerequisites
- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code with Flutter plugin

### Steps

1. **Clone or extract the project**
```bash
cd compliance_calculator_upgraded
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters** (if needed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# For development
flutter run

# For release build
flutter run --release
```

### Platform-Specific Builds

**Windows:**
```bash
flutter build windows --release
```

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── calculation_record.dart    # Data model
│   └── calculation_record.g.dart  # Generated Hive adapter
├── providers/
│   ├── theme_provider.dart        # Theme state management
│   └── calculation_provider.dart  # Calculation state
├── screens/
│   ├── home_screen.dart           # Main calculator screen
│   ├── history_screen.dart        # Calculation history
│   └── settings_screen.dart       # App settings
├── widgets/
│   ├── calculation_card.dart      # Input form widget
│   ├── result_card.dart           # Results display
│   ├── stats_card.dart            # Current month info
│   └── chart_widget.dart          # Compliance chart
└── utils/
    ├── compliance_calculator.dart # Core calculation logic
    └── pdf_generator.dart         # PDF export utility
```

## 🎨 Customization

### Changing Theme Colors
Edit the `seedColor` in `main.dart`:
```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFF6366F1), // Change this hex color
  brightness: Brightness.light,
)
```

### Modifying Compliance Percentage
Change the 60% requirement in `compliance_calculator.dart`:
```dart
static int calculateRequiredDays(int workingDays) {
  final required = (workingDays * 0.6); // Change 0.6 to desired percentage
  return required.ceil();
}
```

## 🔧 Troubleshooting

### Build Runner Issues
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts
```bash
flutter pub upgrade --major-versions
flutter clean
flutter pub get
```

### Platform-Specific Issues
- **Windows**: Ensure Visual Studio 2022 with C++ tools is installed
- **Android**: Check minimum SDK version in `android/app/build.gradle`
- **iOS**: Run `pod install` in the `ios` folder

## 📈 Future Enhancements

Potential features to add:
- [ ] Holiday calendar integration
- [ ] Multi-user support
- [ ] Cloud sync
- [ ] Custom compliance percentages
- [ ] Email reports
- [ ] CSV import/export
- [ ] Push notifications for compliance alerts
- [ ] Calendar view with attendance marking

## 🤝 Contributing

This is an upgraded version of your original compliance calculator. Feel free to:
- Add new features
- Improve the UI/UX
- Fix bugs
- Optimize performance

## 📄 License

This project is open source and available for personal and commercial use.

## 🎯 Upgrade Checklist

From your original v1.0 to this v2.0:
- ✅ Material Design 3 implementation
- ✅ Dark mode support
- ✅ State management (Provider)
- ✅ Data persistence (Hive)
- ✅ Calculation history
- ✅ Interactive charts
- ✅ PDF export
- ✅ Modern animations
- ✅ Responsive design
- ✅ Settings screen
- ✅ Improved error handling
- ✅ Clean architecture

---

**Version**: 2.0.0  
**Last Updated**: February 2026  
**Built with**: ❤️ and Flutter
