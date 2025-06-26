import 'package:get/get.dart';
import 'dart:async';

class FlashSaleController extends GetxController {
  Rx<Duration> remainingTime =
      const Duration(hours: 8, minutes: 34, seconds: 52).obs;
  Timer? _timer;
  var currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  String formatTimeUnit(int unit) => unit.toString().padLeft(2, '0');

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
