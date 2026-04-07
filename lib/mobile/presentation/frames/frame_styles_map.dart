import 'package:flutter/material.dart';

import 'frame_style.dart';
import 'skill_type.dart';

final Map<SkillType, FrameStyle> frameStyles = {
  SkillType.cpp: FrameStyle(
    colors: [Color(0xFF00C6FF), Color(0xFF0072FF), Color(0xFF8E2DE2)],
    borderRadius: BorderRadius.circular(50),
    glowColor: Colors.blue,
    label: "C++",
    shapeType: FrameShapeType.oval,
  ),
  SkillType.php: FrameStyle(
    colors: [Colors.indigo, Colors.blueGrey],
    borderRadius: BorderRadius.circular(30),
    glowColor: Colors.indigo,
    label: "PHP",
    shapeType: FrameShapeType.rounded,
  ),
  SkillType.java: FrameStyle(
    colors: [Colors.orange, Colors.red],
    borderRadius: BorderRadius.zero,
    glowColor: Colors.orange,
    label: "Java",
    shapeType: FrameShapeType.square,
  ),
  SkillType.javascript: FrameStyle(
    colors: [Colors.yellow, Colors.orange],
    borderRadius: BorderRadius.circular(20),
    glowColor: Colors.yellow,
    label: "JS",
    shapeType: FrameShapeType.rounded,
  ),
  SkillType.csharp: FrameStyle(
    colors: [Colors.purple, Colors.deepPurple],
    borderRadius: BorderRadius.circular(40),
    glowColor: Colors.purple,
    label: "C#",
    shapeType: FrameShapeType.oval,
  ),
};
