import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuizQuestion {
  String question;
  List<String> options;
  String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json["question"] ?? "",
      options: List<String>.from(json["options"] ?? []),
      correctAnswer: json["answer"] ?? "",
    );
  }
}

class QuizController extends GetxController {
  static const apiKey = "AIzaSyDQO5UkDKiBKMdXXub5c19xIiWvzbu3p3E";
  final model = GenerativeModel(model: "gemini-1.5-flash", apiKey: apiKey);

  var questions = <QuizQuestion>[].obs;
  var index = 0.obs;
  var correct = 0.obs;
  var selectedOption = RxnInt();
  var loading = false.obs;
  var currentSkill = ''.obs;

  Future<void> generateQuiz(String skill) async {
    loading.value = true;
    currentSkill.value = skill;

    final prompt = """
Generate exactly 3 multiple-choice questions about $skill.
Return ONLY a valid JSON array like:

[
  {
    "question": "text",
    "options": ["a","b","c","d"],
    "answer": "a"
  }
]

No explanation, no text outside the JSON.
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      String text = response.text ?? "";

      print("🔵 RAW GEMINI RESPONSE:");
      print(text);

      // استخراج JSON Array من النص باستخدام Regex
      final regex = RegExp(r'\[(.|\s)*?\]');
      final match = regex.firstMatch(text);

      if (match == null) {
        print("❌ No JSON array found");
        questions.clear();
        loading.value = false;
        return;
      }

      final jsonString = match.group(0)!;
      print("🟢 Extracted JSON:");
      print(jsonString);

      final List data = jsonDecode(jsonString);

      questions.value = data.map((e) => QuizQuestion.fromJson(e)).toList();

      // لو Gemini عمل options أقل من 4 نكملها
      for (var q in questions) {
        while (q.options.length < 4) {
          q.options.add("Option ${q.options.length + 1}");
        }
        if (q.options.length > 4) {
          q.options = q.options.sublist(0, 4);
        }
      }

      print("🟢 Final parsed questions = ${questions.length}");
    } catch (e) {
      print("❌ ERROR: $e");
      questions.clear();
    } finally {
      loading.value = false;
    }
  }

  void nextQuestion() {
    if (selectedOption.value != null) {
      if (questions[index.value].options[selectedOption.value!]
              .trim()
              .toLowerCase() ==
          questions[index.value].correctAnswer.trim().toLowerCase()) {
        correct.value++;
      }
    }

    if (index.value < questions.length - 1) {
      index.value++;
      selectedOption.value = null;
    } else {
      Get.offAllNamed(
        '/result',
        arguments: {'score': correct.value, 'total': questions.length},
      );
    }
  }

  void previousQuestion() {
    if (index.value > 0) {
      index.value--;
      selectedOption.value = null;
    }
  }

  void resetQuiz() {
    index.value = 0;
    correct.value = 0;
    selectedOption.value = null;
    questions.clear();
    currentSkill.value = '';
  }
}
