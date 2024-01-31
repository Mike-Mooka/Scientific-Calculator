//calculator_buttons.dart --- this contains the UI elements especially the buttons and the display
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calculator_logic.dart';

class CalculatorButtons {
  final Function(String) updateOutput;
  final String output;
  final String input;
  final Function getCurrentMode;
  final Function getBracketRepresentation;

  CalculatorButtons({
    required this.updateOutput,
    required this.output,
    required this.input,
    required this.getCurrentMode,
    required this.getBracketRepresentation,
  });

  List<Widget> buildButtons(BuildContext context, double buttonSize) {
    // Pass BuildContext here
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return [
      Row(
        children: [
          _displayMode(),
          Expanded(child: _displayInput(input)),
        ],
      ),
      _displayOutput(output),
      Container(
        color: Colors.black, // Set the background color to black
        child: Column(
          children: [
            _buildButtonRow(context, ["C", "PAREN", "±", "DEL"]),
            _buildButtonRow(context, ["tan", "sin", "cos", "×"]),
            _buildButtonRow(context, ["π", "e", "^", "-"]),
            _buildButtonRow(context, ["inv", "log", "ln", "+"]),
            _buildButtonRow(context, ["7", "8", "9", "%"]),
            _buildButtonRow(context, ["4", "5", "6", "√"]),
            _buildButtonRow(context, ["1", "2", "3", "/"]),
            _buildButtonRow(context, ["DEG/RAD", "0", ".", "!", "="]),
          ],
        ),
      ),
    ];
  }

  Widget _displayMode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        getCurrentMode(),
        style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
      ),
    );
  }

  Widget _displayInput(String input) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerRight,
      child: Text(
        input,
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _displayOutput(String output) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.centerRight,
      child: Text(
        output,
        style: const TextStyle(fontSize: 30, color: Colors.grey),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) => _buildButton(context, text)).toList(),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    // Use MediaQuery to get the screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color buttonColor;
    Color textColor;

    // Adjust the button text for the "PAREN" button
    String displayText = text == "PAREN" ? getBracketRepresentation() : text;

    // Determining the button and text colors based on button type
    if (['C', 'DEL', '±', '%', '%', '×', '+', '-', '/', 'PAREN', '√']
        .contains(text)) {
      buttonColor = Colors.blue[50]!;
      textColor = Colors.black;
    } else if (text == '=') {
      buttonColor = Colors.orange[700]!;
      textColor = Colors.white;
    } else {
      buttonColor = Colors.grey[850]!;
      textColor = Colors.white;
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(0), // Remove default padding
        child: MaterialButton(
          color: buttonColor,
          textColor: textColor,
          onPressed: () => updateOutput(text),
          splashColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Remove border radius
            side: const BorderSide(
              color: Colors.blueGrey, width: 0, // Remove border
            ),
          ),
          height: 70.0, // Set a fixed button height
          child: displayText == "DEL"
              ? const Icon(CupertinoIcons.delete_left, color: Colors.black)
              : Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 30.0, // Set a fixed button font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
