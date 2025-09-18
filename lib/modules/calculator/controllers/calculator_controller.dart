import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController extends GetxController {

  // الخصائص التفاعلية
  final RxString _input = ''.obs;
  final RxString _output = '0'.obs;

  // Getter للوصول إلى الخصائص من الواجهة
  String get input => _input.value;
  String get output => _output.value;

  // إضافة رقم أو فاصلة عشرية
  void addInput(String value) {
    _input.value += value;
  }

  // إضافة عملية حسابية
  void addOperator(String operator) {
    if (_input.isNotEmpty) {
      final lastChar = _input.value.substring(_input.value.length - 1);
      if (['+', '-', '*', '/'].contains(lastChar)) {
        // استبدال العملية إذا كانت موجودة
        _input.value = _input.value.substring(0, _input.value.length - 1) + operator;
      } else {
        _input.value += operator;
      }
    }
  }

  // مسح الشاشة
  void clear() {
    _input.value = '';
    _output.value = '0';
  }

  // حذف آخر حرف
  void deleteLast() {
    if (_input.isNotEmpty) {
      _input.value = _input.value.substring(0, _input.value.length - 1);
    }
  }

  // تغيير إشارة الرقم
  void toggleSign() {
    if (_input.isNotEmpty && _input.value != '0') {
      if (_input.value.startsWith('-')) {
        _input.value = _input.value.substring(1);
      } else {
        _input.value = '-${_input.value}';
      }
    }
  }

  // حساب الناتج
  void calculate() {
    try {
      String expression = _input.value.replaceAll('x', '*');
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      _output.value = exp.evaluate(EvaluationType.REAL, cm).toString();
      _input.value = _output.value;
    } catch (e) {
      _output.value = 'خطأ';
    }
  }
}