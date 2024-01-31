import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

import 'database_helper.dart';
import 'history_model.dart';

mixin CalculatorLogic<T extends StatefulWidget> on State<T> {
  String output = "";
  String input = "";
  String operation = "";
  bool isRadian = false;
  bool isError = false;
  int parenBalance = 0; // Keeps track of open and close parenthesis

  String getBracketRepresentation() {
    return (parenBalance <= 0 || input.endsWith("(")) ? "(" : ")";
  }

  String _convertToRadian(String expression, String trigFunc) {
    String pattern = "$trigFunc\\((-?[\\d\\.]+)\\)";
    RegExp regExp = RegExp(pattern);

    return expression.replaceAllMapped(regExp, (match) {
      double valueInDegrees = double.parse(match[1]!);
      double valueInRadians = valueInDegrees * (pi / 180);
      return "$trigFunc($valueInRadians)";
    });
  }

  void toggleMode() {
    setState(() {
      isRadian = !isRadian;
    });
  }

  String getCurrentMode() {
    return isRadian ? "R" : "D";
  }

  void clearCalculator() {
    operation = "";
    input = "";
    output = "";
    isError = false;
    parenBalance = 0;
  }

  int _factorial(int num) {
    int result = 1;
    for (int i = 2; i <= num; i++) {
      result *= i;
    }
    return result;
  }

  double evaluate(String expression) {
    try {
      expression = expression.replaceAll('^', '**');
      expression = expression.replaceAllMapped(
          '√(', (match) => 'sqrt('); // replace every occurrence of √ with sqrt(

      // Handle degree to radian conversion for trigonometric functions
      if (!isRadian) {
        expression = _convertToRadian(expression, 'sin');
        expression = _convertToRadian(expression, 'cos');
        expression = _convertToRadian(expression, 'tan');
      }

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception("Error evaluating expression: $e");
    }
  }

  String formatNumber(double n) {
    if (n == n.floor()) {
      return n.toInt().toString();
    }
    return n.toString();
  }

  String appendMissingParenthesis(String expr) {
    int openParens = expr.split('(').length - 1;
    int closeParens = expr.split(')').length - 1;
    while (openParens > closeParens) {
      expr += ')';
      closeParens++;
    }
    return expr;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  void updateOutput(String text) {
    setState(() {
      if (isError) {
        clearCalculator();
      }

      if (text == "C") {
        clearCalculator();
      } else if (text == "DEL") {
        if (input.isNotEmpty) {
          // Check if input has at least one character
          if (input.endsWith("sin(") ||
              input.endsWith("cos(") ||
              input.endsWith("tan(")) {
            input = input.substring(
                0, input.length - 4); // Delete the whole trigonometric function
          } else if (input.endsWith("ln(") || input.endsWith("log(")) {
            input = input.substring(
                0, input.length - 3); // Delete the whole ln or log function
          } else if (input.endsWith("√(")) {
            input = input.substring(
                0, input.length - 2); // Delete the entire square root function
          } else if (input.endsWith("^(")) {
            input = input.substring(
                0, input.length - 2); // Delete the entire power function
          } else {
            input = input.substring(
                0, input.length - 1); // Delete the last character
          }
          try {
            output = formatNumber(evaluate(input.replaceAll('×', '*')));
          } catch (e) {
            output = "";
          }
        }
      } else if (text == "±") {
        output = output.startsWith("-")
            ? output.substring(1)
            : (double.parse(output) != 0.0)
                ? "-$output"
                : output;
      } else if (text == "√") {
        if (input.isNotEmpty && isNumeric(input.substring(input.length - 1))) {
          input += "×√(";
        } else {
          input += "√(";
        }
      } else if (text == "=") {
        // First, handle the missing parentheses
        input = appendMissingParenthesis(input);
        String evalExpression = input.replaceAll('×', '*');
        try {
          String result = formatNumber(evaluate(evalExpression));
          output = result; // Update output after evaluation

          // Save the calculation in the history database
          HistoryItem newItem = HistoryItem(
              expression: input,
              result: output,
              timestamp: DateTime.now().toString());
          DatabaseHelper.instance.insertHistory(newItem);
        } catch (e) {
          isError = true;
          output = "Error: ${e.toString()}";
        }
      } else if (text == "DEG/RAD") {
        toggleMode();
      } else if (["sin", "cos", "tan", "ln", "log"].contains(text)) {
        if (input.isNotEmpty && isNumeric(input.substring(input.length - 1))) {
          input += "×$text(";
        } else {
          input += "$text(";
        }
      } else if (text == "e") {
        input +=
            (input.isNotEmpty && isNumeric(input.substring(input.length - 1)))
                ? '×${math.e.toString()}'
                : math.e.toString();
        // Don't update output here
      } else if (text == "π") {
        if (input.isNotEmpty && isNumeric(input.substring(input.length - 1))) {
          input += '×π';
        } else {
          input += "π";
        }
        try {
          String evalExpression =
              input.replaceAll("π", math.pi.toString()).replaceAll('×', '*');
          output = formatNumber(evaluate(evalExpression));
        } catch (e) {
          isError = true;
          output = "Error: ${e.toString()}";
        }
      } else if (text == "PAREN") {
        if (parenBalance <= 0 || input.endsWith("(")) {
          input += "(";
          parenBalance++;
        } else {
          input += ")";
          parenBalance--;
        }
      } else {
        input += text;
        // Don't update output here
      }
    });
  }
}
