import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this);
  }

  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
