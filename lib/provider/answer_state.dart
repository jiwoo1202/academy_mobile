import 'package:get/get.dart';
import '../model/answer.dart';

class AnswerState extends GetxController{
  final group = ''.obs;
  final answer = [].obs; //firebase
  final password = ''.obs;
  final pdfCategory = ''.obs;
  final pdfName = ''.obs;
  final pdfUploadName = [].obs;
  final state = ''.obs;
  final teacher = ''.obs;
  final temp1 = ''.obs;
  final temp2 = ''.obs;
  final docId = ''.obs;
  final path = ''.obs;
  final path2 = ''.obs; // 듣기 패스
  final answerList = <Answer>[].obs; //provider용
  final stateList = [].obs; // 대기인 상태만 있는 리스트(추가)
  final createDate = ''.obs; // 만든날짜 (추가)
  final teacherList = [].obs; // 선생 리스트(추가)
  final createList = [].obs; // 날짜 리스트(추가)
  final answerlength = [].obs; // 정답길이(추가)
  final getDocid = [].obs; // 닥아이디 리스트(추가)
  final testAnswerList = [].obs; // 닥아이디 리스트(추가)

  final getTeacherName = ''.obs; //선생이름 가져오기
  final getDate = ''.obs; //


// individual
  final hasFile = false.obs;
  final indEditList = [].obs;
  final essayList = [].obs;
  final choiceList = [].obs;
  final individualTitle = [].obs;
  final individualBody = [].obs;
  final individualFile = [].obs;
  final individualFilePath = [].obs;
  final editIndividual = [].obs;
  final editIndividualImage = [].obs;
  final tmpidx = [].obs;

  final individualFile2 = [].obs;
  final individualFilePath2 = [].obs;
  final editIndividualAudio = [].obs;
  final indEditList2 = [].obs;
  final pdfUploadName2 = [].obs;

  //total
 final essayList1 = [].obs;
 final choiceList1 = [].obs;




}