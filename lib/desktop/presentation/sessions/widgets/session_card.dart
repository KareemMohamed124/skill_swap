import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../mobile/presentation/payment/payment_webview_screen.dart';
import '../../../../mobile/presentation/sessions/models/session.dart';
import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_bloc.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_event.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_state.dart';
import '../../../../shared/bloc/pay_booking_bloc/pay_booking_bloc.dart';
import '../../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../../shared/data/models/status_booking/status_booking_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/book_session.dart';
import '../../book_session/screens/profile_mentor.dart';

class SessionCard extends StatefulWidget {
  final SessionModel session;
  final String currentStatus;

  const SessionCard(
      {super.key, required this.session, required this.currentStatus});

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  late Duration _timeRemaining;
  Timer? _timer;
  bool _isJoining = false;

  bool get isPending => widget.session.rawStatus == "pending";

  bool get isAccepted => widget.session.rawStatus == "accepted";

  bool get isRequested => widget.session.rawStatus == "requested";

  bool get isCompleted => widget.session.rawStatus == "completed";

  bool get isCancelled => widget.session.rawStatus == "cancelled";

  bool get isRejected => widget.session.rawStatus == "rejected";

  Color get badgeColor {
    if (isPending) return Colors.orange;
    if (isAccepted) return Colors.blue;
    if (isCompleted) return Colors.green;
    if (isCancelled || isRejected) return Colors.red;
    return Colors.grey;
  }

  String badgeText({bool isLoading = false}) {
    if (isRequested && isLoading) return "Accepting...";
    if (isPending) return "Pending";
    if (isAccepted) return "Accepted";
    if (isCompleted) return "Completed";
    if (isCancelled) return "Cancelled";
    if (isRejected) return "Rejected";
    return "";
  }

  @override
  void initState() {
    super.initState();

    if (isAccepted && widget.session.price == 0) {
      _updateTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _timeRemaining = widget.session.dateTime.difference(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String timeAgoFromServer(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      final s = difference.inSeconds;
      return '$s second${s == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes < 60) {
      final m = difference.inMinutes;
      return '$m minute${m == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final h = difference.inHours;
      return '$h hour${h == 1 ? '' : 's'} ago';
    } else {
      final d = difference.inDays;
      return '$d day${d == 1 ? '' : 's'} ago';
    }
  }

  String formatTime12h(DateTime dt) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dt);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Widget _buildUserImage(double cardWidth) {
    final image = widget.session.userImage;

    if (image == null || image.isEmpty) {
      return _buildPlaceholder(cardWidth);
    }

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: cardWidth * 0.25,
        height: cardWidth * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
      );
    }

    if (image.startsWith("data:image")) {
      try {
        final base64Str = image.split(',')[1];
        final bytes = base64Decode(base64Str);

        return Image.memory(
          bytes,
          width: cardWidth * 0.25,
          height: cardWidth * 0.25,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
        );
      } catch (e) {
        return _buildPlaceholder(cardWidth);
      }
    }

    return _buildPlaceholder(cardWidth);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /// Responsive width
    final double cardWidth = screenWidth > 1200
        ? double.infinity
        : screenWidth > 800
            ? double.infinity
            : screenWidth * 0.9;

    final bloc = context.read<StatusBookBloc>();

    final isLoading =
        bloc.loadingSessions[widget.session.sessionId.toString()] ?? false;

    return BlocListener<StatusBookBloc, StatusBookState>(
      listener: (context, state) {
        if (state is StatusBookSuccess &&
            state.sessionId == widget.session.sessionId.toString()) {
          Get.snackbar("Success", state.success.data.message);

          final cubit = context.read<GetBookingsCubit>();

          cubit.removeBooking(state.sessionId);
          cubit.fetchAllBookings(widget.currentStatus);
        } else if (state is StatusBookFailure &&
            state.sessionId == widget.session.sessionId.toString()) {
          Get.snackbar("Error", state.error.message);
        }
      },
      child: Center(
        /// ✅ يخلي الكارت ثابت في النص
        child: SizedBox(
          width: cardWidth,
          child: InkWell(
            child: Container(
              padding: const EdgeInsets.all(16), // ✅ ثابت بدل scale
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16), // ✅ ثابت
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: _buildUserImage(cardWidth),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.session.userName,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(widget.session.userRole,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (isRequested)
                        Text(
                          timeAgoFromServer(widget.session.timeAgo),
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: badgeColor),
                          ),
                          child: Text(
                            badgeText(isLoading: isLoading),
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  iconText(
                    context: context,
                    icon: Icons.access_time,
                    data: formatTime12h(widget.session.dateTime),
                    extra: "${widget.session.duration} min",
                  ),
                  const SizedBox(height: 8),

                  iconText(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    data:
                        "${widget.session.dateTime.day}/${widget.session.dateTime.month}/${widget.session.dateTime.year}",
                  ),
                  const SizedBox(height: 8),

                  iconText(
                    context: context,
                    icon: Icons.attach_money,
                    data: widget.session.price == 0
                        ? "Free"
                        : '${widget.session.price}',
                  ),

                  const SizedBox(height: 16),

                  /// REQUESTED
                  if (isRequested)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size.fromHeight(45),
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<StatusBookBloc>().add(
                                          StatusBookSession(
                                            id: widget.session.sessionId,
                                            request: StatusBookingRequest(
                                                status: "accepted"),
                                          ),
                                        );
                                  },
                            child: const Text("Accept"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              minimumSize: const Size.fromHeight(45),
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<StatusBookBloc>().add(
                                          StatusBookSession(
                                            id: widget.session.sessionId,
                                            request: StatusBookingRequest(
                                                status: "rejected"),
                                          ),
                                        );
                                  },
                            child: const Text("Decline"),
                          ),
                        ),
                      ],
                    )

                  /// FREE SESSION
                  else if (isAccepted && widget.session.price == 0)
                    BlocProvider(
                      create: (_) => sl<JoinSessionBloc>(),
                      child: BlocConsumer<JoinSessionBloc, JoinSessionState>(
                        listener: (context, state) {
                          if (state is JoinSessionFailure) {
                            Get.snackbar("Error", state.error);
                          }
                        },
                        builder: (context, state) {
                          final isJoining = state is JoinSessionLoading;

                          return GestureDetector(
                            onTap: (_timeRemaining.inSeconds <= 0 && !isJoining)
                                ? () {
                                    context.read<JoinSessionBloc>().add(
                                          JoinSessionRequested(
                                              widget.session.sessionId),
                                        );
                                  }
                                : null,
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _timeRemaining.inSeconds > 0
                                    ? Theme.of(context).primaryColor
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isJoining
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      _timeRemaining.inSeconds > 0
                                          ? "Session starts in ${_formatDuration(_timeRemaining)}"
                                          : "Live now",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    )

                  /// PAID SESSION
                  else if (isAccepted && widget.session.price > 0)
                    BlocProvider(
                      create: (_) => sl<PayBookingBloc>(),
                      child: BlocConsumer<PayBookingBloc, PayBookingState>(
                        listener: (context, state) {
                          if (state is PayBookingSuccessState) {
                            Get.to(() => PaymentWebViewScreen(
                                  checkoutUrl: state.checkoutUrl,
                                  successUrl: state.successUrl,
                                  cancelUrl: state.cancelUrl,
                                ));
                          } else if (state is PayBookingFailureState) {
                            Get.snackbar("Payment Error", state.error);
                          }
                        },
                        builder: (context, state) {
                          final isPayLoading = state is PayBookingLoading;

                          return GestureDetector(
                            onTap: isPayLoading
                                ? null
                                : () {
                                    context.read<PayBookingBloc>().add(
                                          PayBookingRequested(
                                            bookingId: widget.session.sessionId,
                                          ),
                                        );
                                  },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isPayLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Pay Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text("Pending approval"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget iconText({
  required BuildContext context,
  required IconData icon,
  required String data,
  String? extra,
}) {
  return Row(
    children: [
      Icon(icon, size: 18),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          extra != null ? "$data • $extra" : data,
          style: TextStyle(
            color: data == "Free" ? Colors.green : null,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPlaceholder(double cardWidth) {
  return Container(
    width: cardWidth * 0.25,
    height: cardWidth * 0.25,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
    child: const Icon(Icons.person, color: Colors.white),
  );
}
