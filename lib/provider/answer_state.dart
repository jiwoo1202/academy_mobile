import 'package:get/get.dart';
import '../model/answer.dart';

class AnswerState extends GetxController{
  final group = ''.obs;
  final answer = [].obs; //firebase
  final password = ''.obs;
  final pdfCategory = ''.obs;
  final pdfName = ''.obs;
  final pdfUploadName = ''.obs;
  final state = ''.obs;
  final teacher = ''.obs;
  final temp1 = ''.obs;
  final temp2 = ''.obs;
  final docId = ''.obs;
  final path = ''.obs;
  final answerList = <Answer>[].obs; //provider용
// final name = ''.obs;


}