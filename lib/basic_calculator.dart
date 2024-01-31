import 'package:flutter/material.dart';
import 'calculator_buttons.dart';
import 'calculator_logic.dart';

class BasicCalculator extends StatefulWidget {
  const BasicCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BasicCalculatorState createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator>
    with CalculatorLogic<BasicCalculator> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Here you can use constraints.maxWidth and constraints.maxHeight
        // to adapt your UI based on available width and height.

        // For instance:
        double buttonSize = constraints.maxWidth / 4; // Just an example

        return Column(
          children: CalculatorButtons(
            updateOutput: updateOutput,
            output: output,
            input: input,
            getBracketRepresentation: getBracketRepresentation,
            getCurrentMode: getCurrentMode,
          ).buildButtons(context,
              buttonSize), // Pass the button size or any other adaptive parameters
        );
      },
    );
  }
}

void main() => runApp(const MaterialApp(home: BasicCalculator()));
