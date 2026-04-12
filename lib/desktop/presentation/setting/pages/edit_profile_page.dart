import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/update_profile/update_profile.dart';
import '../../../../shared/data/models/update_profile/update_profile_request.dart';
import '../../../../shared/data/models/update_profile/update_skill.dart';

const Map<String, List<String>> tracksWithSkillsMap = {
  "Mobile Development": [
    "Dart",
    "Flutter",
    "Java",
    "Kotlin",
    "Android",
    "Swift",
    "iOS",
    "Backend Services",
    "Firebase",
    "REST APIs / GraphQL",
    "Bloc",
    "Provider",
    "Riverpod",
    "Unit Testing",
    "Widget Testing",
    "Integration Testing",
    "CI/CD for Mobile",
    "UX/UI Basics for Mobile"
  ],
  "Frontend Development": [
    "HTML",
    "CSS",
    "JavaScript",
    "React",
    "Angular",
    "Vue",
    "TypeScript",
    "Redux",
    "MobX",
    "Pinia",
    "Responsive Design",
    "Tailwind",
    "Bootstrap",
    "Jest",
    "Cypress",
    "Web Performance",
    "SEO"
  ],
  "Backend Development": [
    "JavaScript",
    "NodeJS",
    "Laravel",
    "Django",
    "Database Management",
    "PHP",
    "Python",
    "SQL",
    "REST APIs",
    "GraphQL",
    "gRPC",
    "JWT",
    "OAuth",
    "Caching",
    "Redis",
    "Message Queues",
    "Microservices",
    "Architecture Patterns",
    "Unit Testing",
    "Integration Testing"
  ],
  "UI/UX Design": [
    "Figma",
    "Adobe XD",
    "User Research",
    "UI Design",
    "Prototyping",
    "UX Strategy",
    "User Flows",
    "Wireframes",
    "Interaction Design",
    "Accessibility",
    "WCAG",
    "Design Systems",
    "Style Guides"
  ],
  "Artificial Intelligence": [
    "Python",
    "TensorFlow",
    "PyTorch",
    "NLP",
    "Computer Vision",
    "Reinforcement Learning",
    "ML Ops",
    "Model Deployment",
    "Data Preprocessing",
    "Feature Engineering"
  ],
  "Data Science": [
    "Python",
    "Pandas",
    "NumPy",
    "Data Visualization",
    "R",
    "Statistical Analysis",
    "SQL",
    "Databases for Data",
    "Machine Learning Basics",
    "Statistical Modeling",
    "Hypothesis Testing"
  ],
  "Game Development": [
    "C#",
    "Unity",
    "C++",
    "Unreal Engine",
    "Blender",
    "3D Design",
    "Advanced C++ Techniques",
    "Advanced C# Techniques",
    "Physics Systems",
    "Animation Systems",
    "Shader Programming",
    "Multiplayer",
    "Networking"
  ],
  "CyberSecurity": [
    "Linux",
    "Networking",
    "Python",
    "Security Automation",
    "Penetration Testing",
    "OWASP",
    "Security Protocols",
    "Malware Analysis",
    "Incident Response",
    "Cloud Security"
  ],
  "Cloud Computing": [
    "Docker",
    "Containerization",
    "Kubernetes",
    "Orchestration",
    "AWS",
    "Cloud Services",
    "CI/CD",
    "DevOps",
    "Azure",
    "GCP",
    "Terraform",
    "Infrastructure as Code",
    "Cloud Security",
    "Monitoring"
  ],
  "Software Testing": [
    "Dart",
    "Flutter Testing",
    "Java",
    "Selenium",
    "Automation",
    "Test Frameworks",
    "API Testing",
    "Postman",
    "REST Assured",
    "Performance Testing",
    "Load Testing",
    "JMeter",
    "Manual Testing Techniques"
  ],
};

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;

  File? selectedImage;
  bool controllersFilled = false;

  List<dynamic> selectedSkills = [];
  List<dynamic> originalSkills = [];
  List<dynamic> selectedSkillsNew = [];
  String? userTrack;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    bioController = TextEditingController();
    context.read<MyProfileCubit>().fetchMyProfile();
  }

  void fillControllersFromProfile(profile) {
    nameController.text = profile.userName;
    bioController.text = profile.profile.bio;

    final skillsList = profile.skills ?? [];
    selectedSkills = skillsList.map((e) => e.skillName).toList();
    originalSkills = List.from(selectedSkills);

    userTrack = profile.track.userName;
    selectedImage = null;
    controllersFilled = true;
  }

  Future<void> pickImage(ImageSource source) async {
    if (defaultTargetPlatform == TargetPlatform.windows &&
        source == ImageSource.camera) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera not available on Windows")),
      );
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
      context
          .read<UpdateProfileBloc>()
          .add(SubmitUpdateProfileImage(image.path));
    }
  }

  void showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (defaultTargetPlatform != TargetPlatform.windows)
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Widget skillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("skills".tr),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...selectedSkillsNew.map((skill) => Chip(
                  label: Text(skill),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => selectedSkillsNew.remove(skill));
                  },
                )),
            ActionChip(
              avatar: const Icon(Icons.add),
              label: const Text("Add"),
              onPressed: showSkillsPicker,
            ),
          ],
        ),
      ],
    );
  }

  void showSkillsPicker() {
    final trackSkills = tracksWithSkillsMap[userTrack] ?? [];
    List<String> tempSelectedSkills = List.from(selectedSkillsNew);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Skills"),
        content: SizedBox(
          width: 500,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: trackSkills.map((skill) {
              final isAlreadyMine = selectedSkills.contains(skill);
              final isSelectedNew = tempSelectedSkills.contains(skill);

              return FilterChip(
                label: Text(skill),
                selected: isAlreadyMine || isSelectedNew,
                onSelected: isAlreadyMine
                    ? null
                    : (selected) {
                        if (selected) {
                          tempSelectedSkills.add(skill);
                        } else {
                          tempSelectedSkills.remove(skill);
                        }
                        setState(() {});
                      },
                selectedColor: isAlreadyMine ? Colors.grey : null,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedSkillsNew = tempSelectedSkills);
              Navigator.pop(context);
            },
            child: const Text("Save Skills"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileBloc, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccessState) {
          Get.snackbar('Success', state.success);
          setState(() {
            selectedSkillsNew.clear();
            selectedSkills = state.user.skills.map((s) => s.skillName).toList();
          });
          context.read<MyProfileCubit>().fetchMyProfile();
          controllersFilled = false;
        }
      },
      child: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {
          final isLoading = state is MyProfileLoading;
          final profile = state is MyProfileLoaded ? state.profile : null;

          if (!controllersFilled && profile != null) {
            fillControllersFromProfile(profile);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                containerWrapper(
                  context: context,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            AppPalette.primary.withValues(alpha: 0.25),
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!) as ImageProvider
                            : (profile?.userImage.secureUrl.isNotEmpty ?? false)
                                ? NetworkImage(profile!.userImage.secureUrl)
                                    as ImageProvider
                                : null,
                        child: (selectedImage == null &&
                                (profile?.userImage.secureUrl.isEmpty ?? true))
                            ? (isLoading
                                ? SizedBox(
                                    width: 30 * 1.2,
                                    height: 30 * 1.2,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(Icons.person,
                                    size: 30, color: Colors.white))
                            : null,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: showImageSourceSheet,
                        icon: const Icon(Icons.camera_alt),
                        label: Text("change_photo".tr),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                containerWrapper(
                  context: context,
                  child: Column(
                    children: [
                      inputField(
                          "full_name".tr, "ex: Nada Sayed", nameController,
                          isLoading: isLoading),
                      inputField("bio".tr, "Tell others about yourself...",
                          bioController,
                          maxLines: 3, isLoading: isLoading),
                      skillsSection(),
                      const SizedBox(height: 8),
                      CustomButton(
                        text: "save_changes".tr,
                        onPressed: () {
                          final skillsList = selectedSkillsNew.isNotEmpty
                              ? selectedSkillsNew
                                  .map((e) => UpdateSkill(skillName: e))
                                  .toList()
                              : null;

                          final request = UpdateProfileRequest(
                            name: nameController.text.trim().isEmpty
                                ? null
                                : nameController.text.trim(),
                            profile: UpdateProfile(
                              bio: bioController.text.trim().isEmpty
                                  ? null
                                  : bioController.text.trim(),
                            ),
                            skills: skillsList,
                          );

                          context
                              .read<UpdateProfileBloc>()
                              .add(SubmitUpdateProfile(request));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget containerWrapper(
      {required BuildContext context, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: child,
    );
  }

  Widget inputField(String label, String hint, TextEditingController controller,
      {int maxLines = 1, bool isLoading = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: !isLoading,
        decoration: InputDecoration(
          hintText: isLoading ? '' : hint,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
