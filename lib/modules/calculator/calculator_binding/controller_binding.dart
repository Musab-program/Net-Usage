import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

/// Dependency binding for the Calculator module.
class CalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalculatorController>(() => CalculatorController());
  }
}
