import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

/// Controller for the calculator module.
///
/// Handles input, arithmetic operations, and scientific calculations.
class CalculatorController extends GetxController {
  final RxString _input = ''.obs;
  final RxString _output = '0'.obs;

  /// The current input expression.
  String get input => _input.value;

  /// The calculated result.
  String get output => _output.value;

  /// Appends a value to the input string.
  ///
  /// [value] The string to append (number or operator).
  void addInput(String value) {
    _input.value += value;
  }

  /// Appends an operator to the input, handling duplicates.
  ///
  /// [operator] The operator to append.
  void addOperator(String operator) {
    if (_input.isNotEmpty) {
      final lastChar = _input.value.substring(_input.value.length - 1);
      if (['+', '-', 'x', '/', '%'].contains(lastChar)) {
        _input.value =
            _input.value.substring(0, _input.value.length - 1) + operator;
      } else {
        _input.value += operator;
      }
    }
  }

  /// Clears the input and output.
  void clear() {
    _input.value = '';
    _output.value = '0';
  }

  /// Deletes the last character from the input.
  void deleteLast() {
    if (_input.isNotEmpty) {
      _input.value = _input.value.substring(0, _input.value.length - 1);
    }
  }

  /// Toggles the sign of the current number (positive/negative).
  void toggleSign() {
    if (_input.isNotEmpty && _input.value != '0') {
      if (_input.value.startsWith('-')) {
        _input.value = _input.value.substring(1);
      } else {
        _input.value = '-${_input.value}';
      }
    }
  }

  /// Evaluates the mathematical expression and updates the output.
  ///
  /// Uses [Parser] from `math_expressions` library.
  void calculate() {
    try {
      String expression = _input.value.replaceAll('x', '*');
      expression = expression.replaceAll('%', '/100');

      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval % 1 == 0) {
        _output.value = eval.toInt().toString();
      } else {
        _output.value = eval.toString();
      }

      _input.value = _output.value;
    } catch (e) {
      _output.value = 'خطأ';
    }
  }
}
