import 'package:get/get.dart';

class UserState extends GetxController{
  final count = 0.obs;
  final name = ''.obs;


  void increase(){
    count.value ++;
    update();
  }

  void decrease(){
    count.value --;
    update();
  }
}