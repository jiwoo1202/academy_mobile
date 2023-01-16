import 'package:academy/model/user.dart';
import 'package:get/get.dart';

class UserState extends GetxController{
  final count = 0.obs;
  final name = ''.obs;
  final number = ''.obs;
  final userList = <User>[].obs;


  void increase(){
    count.value ++;
    update();
  }

  void decrease(){
    count.value --;
    update();
  }
}