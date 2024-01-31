import 'package:flutter/material.dart';
import 'advanced_calculator.dart';
import 'basic_calculator.dart';
import 'history_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize FFI for sqflite
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final List<String> _calculatorModes = ['Basic', 'Advanced'];
  String _currentMode = 'Basic'; // Clarify the purpose of _currentMode

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 28), // Increased size
            onSelected: (String newValue) {
              handleMenuItemSelected(newValue);
            },
            itemBuilder: (BuildContext context) {
              double textSize =
                  MediaQuery.of(context).size.width > 600 ? 24 : 16;
              var menuItems = buildPopupMenuItems(textSize);
              return menuItems;
            },
          ),
          title: Text('$_currentMode Mode'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return _currentMode == 'Basic'
                ? const BasicCalculator()
                : const AdvancedCalculator();
          },
        ),
      ),
    );
  }

  void handleMenuItemSelected(String newValue) {
    if (newValue == 'History') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryScreen()),
      );
    } else {
      setState(() {
        _currentMode = newValue;
      });
    }
  }

  List<PopupMenuItem<String>> buildPopupMenuItems(double textSize) {
    var menuItems = _calculatorModes.map((String value) {
      return PopupMenuItem<String>(
        value: value,
        child: Text(value, style: TextStyle(fontSize: textSize)),
      );
    }).toList();

    menuItems.add(const PopupMenuItem<String>(
      value: 'History',
      child: Text('History'),
    ));

    return menuItems;
  }
}
