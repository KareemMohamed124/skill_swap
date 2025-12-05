import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../presentation/skill_verification/result_screen.dart';

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
  static const apiKey = "AIzaSyDz01eafVGuj78DhTt1V7YWSMFiIbkpRC8";
  final gemini = Gemini.instance;

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
Generate exactly 10 multiple-choice questions about $skill.
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
      final response = await gemini.prompt(parts: [Part.text(prompt)]);
      String text = response?.output ?? "";
      print("🔵 RAW GEMINI RESPONSE:");
      print(text);

      String jsonString = "";
      int startIndex = text.indexOf('[');

      if (startIndex == -1) {
        print("❌ No JSON array found (no opening bracket)");
        questions.clear();
        loading.value = false;
        return;
      }

      int bracketCount = 0;
      int endIndex = startIndex;

      for (int i = startIndex; i < text.length; i++) {
        if (text[i] == '[') {
          bracketCount++;
        } else if (text[i] == ']') {
          bracketCount--;
          if (bracketCount == 0) {
            endIndex = i + 1;
            break;
          }
        }
      }

      if (bracketCount != 0) {
        print("❌ Incomplete JSON array (brackets don't match)");
        questions.clear();
        loading.value = false;
        return;
      }

      jsonString = text.substring(startIndex, endIndex).trim();
      print("🟢 Extracted JSON:");
      print(jsonString);

      final List data = jsonDecode(jsonString);

      questions.value = data.map((e) => QuizQuestion.fromJson(e)).toList();

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
      Get.to(
        () => ResultScreen(),
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