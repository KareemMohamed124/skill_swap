import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/chat_repository.dart';
import '../../profile/pages/reviews_page.dart';
import '../../prv_chat/private_chat_screen.dart';
import '../../sign/widgets/custom_button.dart';
import 'book_session.dart';

class ProfileMentorDesktop extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String track;
  final double rate;
  final String bio;
  final int hoursAvailable;
  final int peopleHelped;
  final int hourlyRate;
  final List<Skill> skills;

  const ProfileMentorDesktop({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
    required this.bio,
    required this.hoursAvailable,
    required this.peopleHelped,
    required this.hourlyRate,
    required this.skills,
  });

  @override
  State<ProfileMentorDesktop> createState() => _ProfileMentorDesktopState();
}

class _ProfileMentorDesktopState extends State<ProfileMentorDesktop> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Report Bloc
            BlocProvider(
              create: (_) => sl<ReportBloc>(),
              child: Stack(
                children: [
                  /// Header Row: Back button + Avatar + Name/Track/Rate
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          final didGoBack = desktopKey.currentState?.goBack();
                          if (didGoBack == false) {
                            desktopKey.currentState?.openPage(index: 0);
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      ClipOval(
                        child: Image.asset(
                          widget.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.name,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("${widget.track} Developer • ",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white70)),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 14, color: Color(0xFFFFCE31)),
                                    const SizedBox(width: 4),
                                    Text("${widget.rate}",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Report Button BlocListener
                  BlocListener<ReportBloc, ReportState>(
                    listener: (context, state) {
                      if (state is ReportSuccessState) {
                        Get.snackbar('Success', state.success.message);
                      } else if (state is ReportFailureState) {
                        Get.snackbar('Error', state.error.message);
                      }
                    },
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            final TextEditingController controller =
                                TextEditingController();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(dialogContext)
                                            .size
                                            .width *
                                        0.4,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(dialogContext)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Why are you reporting ${widget.name}?",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: controller,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Write your reason here...",
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (controller.text
                                                      .trim()
                                                      .isEmpty) return;

                                                  final request = ReportRequest(
                                                    reason:
                                                        controller.text.trim(),
                                                    reportedUser: widget.id,
                                                  );

                                                  context
                                                      .read<ReportBloc>()
                                                      .add(
                                                        ConfirmSubmit(request),
                                                      );

                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text("Send"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.report_outlined,
                              size: 24,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Mentor Info Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  mentorInfo(
                      context: context,
                      rate: "${widget.hoursAvailable}",
                      info: "hours_available".tr),
                  mentorInfo(
                      context: context,
                      rate: "${widget.peopleHelped}",
                      info: "people_helped".tr),
                  mentorInfo(
                      context: context,
                      rate: "${widget.hourlyRate}\$",
                      info: "hourly_rate".tr),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text("about".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              widget.bio.isEmpty ? "Tell others about yourself..." : widget.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.75,
                color: isDark
                    ? AppPalette.darkTextSecondary
                    : AppPalette.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 16),
            Text("skills".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skills
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6D6D6).withAlpha(64),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(skill.skillName,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text("reviews".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            ReviewsPage(),
            const SizedBox(height: 16),

            /// Action Buttons: Chat & Session Details
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppPalette.primary),
                  ),
                  child: IconButton(
                    icon: Icon(Iconsax.message, color: AppPalette.primary),
                    onPressed: () async {
                      try {
                        final chatRepo = sl<ChatRepository>();
                        final chatId =
                            await chatRepo.createOrGetPrivateChat(widget.id);
                        desktopKey.currentState?.openSidePage(
                          body: widget,
                          rightPanel: BlocProvider(
                            create: (_) => sl<PublicChatMessagesCubit>()
                              ..init(chatId,
                                  partnerId: widget.id, isPrivate: true),
                            child: PrivateChatScreen(
                              chatId: chatId,
                              partnerName: widget.name,
                              partnerId: widget.id,
                              partnerImage: widget.image,
                            ),
                          ),
                        );
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to open chat: $e');
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: "session_details".tr,
                    onPressed: () {
                      desktopKey.currentState?.openSidePage(
                        body: widget,
                        rightPanel: BookSessionDesktop(
                          userId: widget.id,
                          bookingId: null,
                          userName: widget.name,
                          price: widget.hourlyRate,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget mentorInfo({
  required BuildContext context,
  required String rate,
  required String info,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    children: [
      Text(
        rate,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppPalette.primary),
      ),
      const SizedBox(height: 4),
      Text(
        info,
        style: TextStyle(
            fontSize: 12, color: isDark ? Colors.white : AppPalette.primary),
      ),
    ],
  );
}
