import 'package:flutter/material.dart';
import 'dart:math';

class AdvancedCalculator extends StatefulWidget {
  const AdvancedCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdvancedCalculatorState createState() => _AdvancedCalculatorState();
}

class _AdvancedCalculatorState extends State<AdvancedCalculator> {
  TextEditingController aController = TextEditingController();
  TextEditingController bController = TextEditingController();
  TextEditingController cController = TextEditingController();

  String result = "";
  String _tempInput = "";

  void calculateRoots() {
    double a = double.tryParse(aController.text) ?? 0;
    double b = double.tryParse(bController.text) ?? 0;
    double c = double.tryParse(cController.text) ?? 0;

    if (a == 0) {
      setState(() {
        result = "Please enter a valid value for 'a'. It cannot be zero.";
      });
      return;
    }

    double discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      double root1 = (-b + sqrt(discriminant)) / (2 * a);
      double root2 = (-b - sqrt(discriminant)) / (2 * a);
      setState(() {
        result = "X1: $root1, X2: $root2";
      });
    } else if (discriminant == 0) {
      double root = -b / (2 * a);
      setState(() {
        result = "Single Root: $root";
      });
    } else {
      double realPart = -b / (2 * a);
      double imaginaryPart = sqrt(-discriminant) / (2 * a);
      setState(() {
        result =
            "X1: $realPart + $imaginaryPart i, X2: $realPart - $imaginaryPart i";
      });
    }
  }

  void _updateDisplay(String text) {
    setState(() {
      _tempInput += text;
    });
  }

  Widget _buildButton(String text, void Function()? onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: MaterialButton(
          color: Colors.grey[850],
          textColor: Colors.white,
          onPressed: onPressed,
          splashColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Colors.blueGrey, width: 1.5),
          ),
          elevation: 5.0,
          height: 50.0,
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  _tempInput.isEmpty ? result : _tempInput,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600),
                ),
              ),
              TextField(
                controller: aController,
                decoration:
                    const InputDecoration(labelText: "a (Coefficient of x^2)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bController,
                decoration:
                    const InputDecoration(labelText: "b (Coefficient of x)"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cController,
                decoration: const InputDecoration(labelText: "c (Constant)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(14, (index) {
              if (index < 9) {
                return _buildButton(
                    '${index + 1}', () => _updateDisplay('${index + 1}'));
              } else {
                switch (index) {
                  case 9:
                    return _buildButton('0', () => _updateDisplay('0'));
                  case 10:
                    return _buildButton('.', () => _updateDisplay('.'));
                  case 11:
                    return _buildButton('=', calculateRoots);
                  case 12:
                    return _buildButton(
                        'C',
                        () => setState(() {
                              _tempInput = '';
                              result = '';
                              aController.clear();
                              bController.clear();
                              cController.clear();
                            }));
                  case 13:
                    return _buildButton('DEL', () {
                      if (_tempInput.isNotEmpty) {
                        setState(() {
                          _tempInput =
                              _tempInput.substring(0, _tempInput.length - 1);
                        });
                      }
                    });
                  default:
                    return _buildButton('-', () => _updateDisplay('-'));
                }
              }
            }),
          ),
        ),
      ],
    );
  }
}
