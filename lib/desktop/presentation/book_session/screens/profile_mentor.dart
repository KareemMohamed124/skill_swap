import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/profile/widgets/review_card.dart';
import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/my_profile/review_model.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
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
  final List<ReviewModel> reviews;

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
    required this.reviews,
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
            /// Header + Report
            BlocProvider(
              create: (_) => sl<ReportBloc>(),
              child: Stack(
                children: [
                  Row(
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
                          children: [
                            Text(widget.name,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("${widget.track} Developer • ",
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 14, color: Color(0xFFFFCE31)),
                                    const SizedBox(width: 4),
                                    Text("${widget.rate}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Report Button
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
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Stats
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

            /// About
            Text("about".tr),
            const SizedBox(height: 8),
            Text(widget.bio),

            const SizedBox(height: 16),

            /// Skills
            Text("skills".tr),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.skills
                  .map((s) => Chip(label: Text(s.skillName)))
                  .toList(),
            ),

            const SizedBox(height: 16),

            /// 🔥 Reviews (FIXED)
            Text("reviews".tr),
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
            Row(
              children: [
                IconButton(
                  icon: Icon(Iconsax.message, color: AppPalette.primary),
                  onPressed: () {},
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
                            Get.snackbar(
                              "Oops",
                              "${widget.name} hasn't set any available days yet",
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
                                ),
                              ),
                            );
                          }
                        } else if (state is GetAvailableDatesError) {
                          Get.snackbar("Error", state.message);
                        }
                      }),
                )
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
