import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

<<<<<<< HEAD
import '../../../../desktop/presentation/profile/widgets/review_card.dart';
import '../../../../main.dart';
import '../../../../mobile/presentation/prv_chat/private_chat_screen.dart';
import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/my_profile/review_model.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/chat_repository.dart';
import '../../common/desktop_screen_manager.dart';
=======
import '../../../../main.dart';
import '../../../../shared/bloc/private_chat/private_chat_messages_cubit.dart';
import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/chat_repository.dart';
import '../../profile/pages/reviews_page.dart';
import '../../prv_chat/private_chat_screen.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../../sign/widgets/custom_button.dart';
import 'book_session.dart';

class ProfileMentorDesktop extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String track;
<<<<<<< HEAD
  final num rate;
  final String role;
  final String bio;
  final num hoursAvailable;
  final num peopleHelped;
  final num hourlyRate;
  final List<Skill> skills;
  final List<ReviewModel> reviews;
=======
  final int rate;
  final String bio;
  final int hoursAvailable;
  final int peopleHelped;
  final int hourlyRate;
  final List<Skill> skills;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  const ProfileMentorDesktop({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
<<<<<<< HEAD
    required this.role,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    required this.bio,
    required this.hoursAvailable,
    required this.peopleHelped,
    required this.hourlyRate,
    required this.skills,
<<<<<<< HEAD
    required this.reviews,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  });

  @override
  State<ProfileMentorDesktop> createState() => _ProfileMentorDesktopState();
}

class _ProfileMentorDesktopState extends State<ProfileMentorDesktop> {
<<<<<<< HEAD
  int calculateHourlyRate(int hours, String role) {
    if (role.toLowerCase() != 'mentor') {
      return 0;
    }

    if (hours < 100) return 0;

    if (hours < 120) return 30;

    if (hours < 140) return 35;

    if (hours < 160) return 40;

    if (hours < 180) return 45;

    return 50;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget _buildAvatar(String? imagePath) {
      if (imagePath == null || imagePath.isEmpty) {
        return const Icon(Icons.person, size: 48, color: Colors.white);
      }

      if (imagePath.startsWith("http")) {
        return Image.network(
          imagePath,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 48, color: Colors.white),
        );
      }

      return const Icon(Icons.person, size: 48, color: Colors.white);
    }
=======
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            /// Header + Report
=======
            /// Report Bloc
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            BlocProvider(
              create: (_) => sl<ReportBloc>(),
              child: Stack(
                children: [
<<<<<<< HEAD
                  Row(
=======
                  /// Header Row: Back button + Avatar + Name/Track/Rate
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: ClipOval(
                          child: _buildAvatar(widget.image),
=======
                      ClipOval(
                        child: Image.asset(
                          widget.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
<<<<<<< HEAD
                          children: [
                            Text(widget.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                )),
=======
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.name,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("${widget.track} Developer • ",
<<<<<<< HEAD
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    )),
=======
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white70)),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 14, color: Color(0xFFFFCE31)),
                                    const SizedBox(width: 4),
                                    Text("${widget.rate}",
<<<<<<< HEAD
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        )),
=======
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white)),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

<<<<<<< HEAD
                  /// Report Button
=======
                  /// Report Button BlocListener
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                      child: IconButton(
                        icon: const Icon(Icons.report, color: Colors.red),
                        onPressed: () {
                          final controller = TextEditingController();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Report ${widget.name}"),
                              content: TextField(
                                controller: controller,
                                maxLines: 4,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (controller.text.trim().isEmpty) return;

                                    context.read<ReportBloc>().add(
                                          ConfirmSubmit(
                                            ReportRequest(
                                              reason: controller.text.trim(),
                                              reportedUser: widget.id,
                                            ),
                                          ),
                                        );

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Send"),
                                ),
                              ],
                            ),
                          );
                        },
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

<<<<<<< HEAD
            /// Stats
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  )),
=======
            /// Mentor Info Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(32),
              ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
                      rate: widget.role == "Mentor"
                          ? "${widget.hourlyRate}\$"
                          : "Free",
=======
                      rate: "${widget.hourlyRate}\$",
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      info: "hourly_rate".tr),
                ],
              ),
            ),

            const SizedBox(height: 16),
<<<<<<< HEAD

            /// About
            Text("about".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              widget.bio == ""
                  ? "I'm ${widget.track ?? 'Mobile Development'}."
                  : widget.bio,
=======
            Text("about".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              widget.bio.isEmpty ? "Tell others about yourself..." : widget.bio,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD

            /// Skills
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            Text("skills".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
<<<<<<< HEAD
              children: widget.skills.map((skill) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6D6D6).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skill.skillName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// Reviews
            Text("reviews".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),

            if (widget.reviews.isEmpty)
              const Text("No reviews yet")
            else
              Column(
                children: widget.reviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReviewCard(
                      name: review.reviewer.name,
                      review: review.review,
                      rating: review.rating,
                      image: review.reviewer.userImage.secureUrl ?? '',
                      role: review.reviewer.role,
                      time: review.createdAt,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            /// Actions
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
<<<<<<< HEAD
                    borderRadius: BorderRadius.circular(8),
=======
                    borderRadius: BorderRadius.circular(16),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    border: Border.all(color: AppPalette.primary),
                  ),
                  child: IconButton(
                    icon: Icon(Iconsax.message, color: AppPalette.primary),
                    onPressed: () async {
                      try {
                        final chatRepo = sl<ChatRepository>();
                        final chatId =
                            await chatRepo.createOrGetPrivateChat(widget.id);
<<<<<<< HEAD

                        desktopKey.currentState?.openSidePage(
                          body: context
                              .findAncestorStateOfType<
                                  DesktopScreenManagerState>()!
                              .currentBody!,
                          rightPanel: BlocProvider(
                            key: ValueKey(chatId),
                            create: (_) => sl<PublicChatMessagesCubit>()
                              ..init(chatId,
                                  partnerId: widget.id, isPrivate: true),
                            child: PrivateChatScreen(
                              chatId: chatId,
                              partnerName: widget.name,
                              partnerId: widget.id,
                              partnerImage: widget.image,
=======
                        desktopKey.currentState?.openSidePage(
                          body: widget,
                          rightPanel: BlocProvider(
                            create: (_) =>
                                sl<PrivateChatMessagesCubit>()..init(chatId),
                            child: PrivateChatScreen(
                              chatId: chatId,
                              partnerName: widget.name,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                            ),
                          ),
                        );
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to open chat: $e');
                      }
                    },
                  ),
                ),
<<<<<<< HEAD
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomButton(
                      text: "session_details".tr,
                      onPressed: () async {
                        final bloc = sl<GetAvailableDatesBloc>();

                        bloc.add(FetchAvailableDates(widget.id));

                        final state = await bloc.stream.firstWhere(
                          (state) =>
                              state is GetAvailableDatesSuccess ||
                              state is GetAvailableDatesError,
                        );

                        if (state is GetAvailableDatesSuccess) {
                          if (state.data.availableDates.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Oops"),
                                content: Text(
                                    "${widget.name} hasn't set any available days for this week yet"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            desktopKey.currentState?.openSidePage(
                              body: widget,
                              rightPanel: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (_) => sl<ActiveBookingBloc>()
                                      ..add(LoadMyBookingWithMentor(widget.id)),
                                  ),
                                  BlocProvider(
                                    create: (_) => sl<AcceptedBookingsCubit>(),
                                  ),
                                ],
                                child: BookSessionDesktop(
                                  userId: widget.id,
                                  bookingId: null,
                                  userName: widget.name,
                                  price: widget.hourlyRate,
                                  availableDates: state.data.availableDates,
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        } else if (state is GetAvailableDatesError) {
                          Get.snackbar("Error", state.message);
                        }
                      }),
                )
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
