import 'dart:async';
import 'dart:convert';
<<<<<<< HEAD
import 'package:permission_handler/permission_handler.dart';
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
import 'package:skill_swap/mobile/presentation/sessions/widgets/voucher_sheet.dart';

import '../../../../shared/bloc/cancel_book_bloc/cancel_book_bloc.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_bloc.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_event.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_state.dart';
import '../../../../shared/bloc/pay_booking_bloc/pay_booking_bloc.dart';
import '../../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_state.dart';
import '../../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../../shared/common_ui/video_call/call_screen.dart';
import '../../../../shared/common_ui/video_call/rateSession.dart';
import '../../../../shared/core/services/session_services.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/status_booking/status_booking_request.dart';
import '../../../../shared/data/models/store/purchases.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/local_storage.dart';
import '../../payment/payment_webview_screen.dart';
=======

import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/pay_booking_bloc/pay_booking_bloc.dart';
import '../../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../../shared/data/models/status_booking/status_booking_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/book_session.dart';
import '../../payment/payment_webview_screen.dart';
import '../../video_call/callID.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
import '../models/session.dart';

class SessionCard extends StatefulWidget {
  final SessionModel session;
  final String currentStatus;

  const SessionCard(
      {super.key, required this.session, required this.currentStatus});

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
<<<<<<< HEAD
  Duration _timeRemaining = Duration.zero;
  Timer? _timer;
  bool _isJoining = false;

  String? currentUserId;
  bool isStudent = false;
  List<Purchases> vouchers = [];
  Purchases? selectedVoucher;
  double finalPrice = 0;
=======
  late Duration _timeRemaining;
  Timer? _timer;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  bool get isPending => widget.session.rawStatus == "pending";

  bool get isAccepted => widget.session.rawStatus == "accepted";

  bool get isRequested => widget.session.rawStatus == "requested";

  bool get isCompleted => widget.session.rawStatus == "completed";

  bool get isCancelled => widget.session.rawStatus == "cancelled";

  bool get isRejected => widget.session.rawStatus == "rejected";

<<<<<<< HEAD
  bool get isPaid => widget.session.paymentStatus == "paid";

  bool get isUnpaid => widget.session.paymentStatus == "unpaid";

  bool get canShowCancel {
    return isAccepted &&
        !widget.session.isStudent &&
        isUnpaid &&
        _timeRemaining.inSeconds > 0;
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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

<<<<<<< HEAD
  int getRemainingCallMinutesForCall() {
    final now = DateTime.now();
    final start = widget.session.dateTime;
    final end = start.add(Duration(minutes: widget.session.duration.toInt()));

    if (now.isBefore(start)) {
      return widget.session.duration.toInt();
    }

    final remaining = end
        .difference(now)
        .inMinutes;
    return remaining < 0 ? 0 : remaining;
  }

  Future<void> _loadUser() async {
    final userId = await LocalStorage.getUserId();

    if (userId != null) {
      setState(() {
        currentUserId = userId;
        isStudent = userId == widget.session.userId;
      });
    }
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
    _loadUser();
    _updateTime();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateTime(),
    );

    finalPrice = widget.session.price.toDouble();
=======
    if (isAccepted && widget.session.price == 0) {
      _updateTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    }
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _timeRemaining = widget.session.dateTime.difference(now);
    });
  }

<<<<<<< HEAD
  double calculatePrice(double price, String value) {
    final percent = double.parse(value.replaceAll("%", ""));
    return price - (price * percent / 100);
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
<<<<<<< HEAD
    final image = widget.session.userImage;
=======
    final image = widget.session.image;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

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
<<<<<<< HEAD
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
=======
    final screenWidth = MediaQuery.of(context).size.width;
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    final cardWidth = screenWidth * 0.35;

    final bloc = context.read<StatusBookBloc>();

    final isLoading =
        bloc.loadingSessions[widget.session.sessionId.toString()] ?? false;

    return BlocListener<StatusBookBloc, StatusBookState>(
      listener: (context, state) {
        if (state is StatusBookSuccess &&
            state.sessionId == widget.session.sessionId.toString()) {
          Get.snackbar("Success", state.success.data.message);

<<<<<<< HEAD
          final cubit = context.read<GetBookingsCubit>();

          cubit.removeBooking(state.sessionId);

          cubit.fetchAllBookings(widget.currentStatus);
=======
          context
              .read<GetBookingsCubit>()
              .fetchAllBookings(widget.currentStatus);
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        } else if (state is StatusBookFailure &&
            state.sessionId == widget.session.sessionId.toString()) {
          Get.snackbar("Error", state.error.message);
        }
      },
      child: InkWell(
        onTap: () {
<<<<<<< HEAD

=======
          final bookingId = widget.session.sessionId.toString();

          Get.to(
            BlocProvider(
              create: (_) =>
                  sl<ActiveBookingBloc>()..add(LoadBookingDetails(bookingId)),
              child: BookSessionScreen(
                userId: widget.session.instructorId,
                bookingId: bookingId,
                userName: widget.session.name,
                price: widget.session.price,
              ),
            ),
          );
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        },
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
<<<<<<< HEAD
            color: Theme
                .of(context)
                .cardColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            border: Border.all(color: Theme
                .of(context)
                .dividerColor),
=======
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            border: Border.all(color: Theme.of(context).dividerColor),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              /// HEADER
              Row(
                children: [
                  ClipOval(child: _buildUserImage(cardWidth)),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        Text(widget.session.userName ?? "User",
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium),
                        Text(widget.session.userRole ?? "Normal",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall),
=======
                        Text(widget.session.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(widget.session.role,
                            style: Theme.of(context).textTheme.bodySmall),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      ],
                    ),
                  ),
                  if (isRequested)
                    Text(
                      timeAgoFromServer(widget.session.timeAgo),
<<<<<<< HEAD
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
=======
                      style: Theme.of(context).textTheme.bodySmall,
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(
                        badgeText(isLoading: isLoading),
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: screenWidth * 0.04),

              iconText(
                context: context,
                icon: Icons.access_time,
                data: formatTime12h(widget.session.dateTime),
<<<<<<< HEAD
                extra: "${widget.session.duration} min",
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenWidth * 0.02),
              iconText(
                context: context,
                icon: Icons.calendar_today_outlined,
                data:
<<<<<<< HEAD
                "${widget.session.dateTime.day}/${widget.session.dateTime
                    .month}/${widget.session.dateTime.year}",
=======
                    "${widget.session.dateTime.day}/${widget.session.dateTime.month}/${widget.session.dateTime.year}",
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                screenWidth: screenWidth,
              ),

              SizedBox(height: screenWidth * 0.02),

<<<<<<< HEAD
              Row(
                children: [
                  Icon(Icons.attach_money, size: screenWidth * 0.045),
                  SizedBox(width: screenWidth * 0.015),
                  if (isPaid)
                    Row(
                      children: [
                        Text(
                          '${widget.session.price}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Paid",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      widget.session.price == 0
                          ? "Free"
                          : '${widget.session.price}',
                    ),
                  SizedBox(width: 8),
                  if (isUnpaid &&
                      widget.session.price > 0 &&
                      widget.session.isStudent &&
                      !isRejected &&
                      !isCancelled &&
                      !isCompleted)
                    Text(
                      "Payment Required",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),

              SizedBox(height: screenWidth * 0.02),

              BlocBuilder<PurchaseCubit, PurchaseState>(
                builder: (context, state) {
                  final vouchers =
                  context.read<PurchaseCubit>().getAvailableVouchers();

                  if (isPaid ||
                      !widget.session.isStudent ||
                      !isAccepted ||
                      vouchers.isEmpty ||
                      widget.session.price <= 0) {
                    return SizedBox();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedVoucher == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Apply Discount",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final selected =
                                await showModalBottomSheet<Purchases>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) =>
                                      VoucherSheet(
                                        vouchers: vouchers,
                                        selected: selectedVoucher,
                                      ),
                                );

                                if (selected != null) {
                                  setState(() {
                                    selectedVoucher = selected;
                                    finalPrice = calculatePrice(
                                      widget.session.price.toDouble(),
                                      selected.itemId!.value!,
                                    );
                                  });
                                }
                              },
                              child: const Text(
                                "Apply",
                                style: TextStyle(color: AppPalette.primary),
                              ),
                            ),
                          ],
                        ),
                      if (selectedVoucher != null)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: const ValueKey("voucher"),
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.green.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    selectedVoucher!.itemId?.img?.secureUrl ??
                                        "",
                                    width: 100,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                          width: 100,
                                          height: 60,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.local_offer),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedVoucher!.itemId?.title ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        selectedVoucher!.itemId?.value ?? "",
                                        style:
                                        const TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "After discount: $finalPrice",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedVoucher = null;
                                      finalPrice =
                                          widget.session.price.toDouble();
                                    });
                                  },
                                  child: const Icon(Icons.close,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
=======
              iconText(
                context: context,
                icon: Icons.attach_money,
                data: widget.session.price == 0
                    ? "Free"
                    : '${widget.session.price}',
                screenWidth: screenWidth,
              ),

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              SizedBox(height: screenWidth * 0.04),

              /// REQUESTED
              if (isRequested)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
<<<<<<< HEAD
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          context.read<StatusBookBloc>().add(
                            StatusBookSession(
                                id: widget.session.sessionId,
                                request: StatusBookingRequest(
                                  status: "accepted",
                                ),
                                studentId: widget.session.studentId),
                          );
                        },
                        child: const Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ),
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: OutlinedButton(
<<<<<<< HEAD
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                          context.read<StatusBookBloc>().add(
                            StatusBookSession(
                                id: widget.session.sessionId,
                                request: StatusBookingRequest(
                                    status: "rejected"),
                                studentId: widget.session.userId),
                          );
                        },
                        child: const Text(
                          "Decline",
                          style: TextStyle(color: Colors.white),
                        ),
=======
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
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                      ),
                    ),
                  ],
                )

              /// FREE SESSION
<<<<<<< HEAD
              else
                if (isAccepted && widget.session.price == 0)
                  BlocProvider(
                    create: (_) => sl<JoinSessionBloc>(),
                    child: BlocConsumer<JoinSessionBloc, JoinSessionState>(
                      listener: (context, state) async {
                        if (state is JoinSessionSuccess) {
                          await [
                            Permission.camera,
                            Permission.microphone,
                          ].request();
                          final session = await SessionService.createSession(
                              bookingCode: widget.session.bookingCode,
                              minutes: 2);
                          Get.to(() =>
                              CallScreen(
                                session: widget.session,
                                durationMinutes: getRemainingCallMinutesForCall(),
                              ));
                        } else if (state is JoinSessionFailure) {
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
                                widget.session.sessionId,
                              ),
                            );
                          }
                              : null,
                          child: Container(
                            height: screenWidth * 0.11,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _timeRemaining.inSeconds > 0
                                  ? AppPalette.primary
                                  : Colors.green,
                              borderRadius:
                              BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: isJoining
                                ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Joining...",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                                : Text(
                              _timeRemaining.inSeconds > 0
                                  ? "Session starts in ${_formatDuration(
                                  _timeRemaining)}"
                                  : "Live now",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  )

                /// PAID SESSION
                else
                  if (isAccepted && widget.session.price > 0)
                    widget.session.isStudent
                        ? (isPaid
                        ? BlocProvider(
                      create: (_) => sl<JoinSessionBloc>(),
                      child:
                      BlocConsumer<JoinSessionBloc, JoinSessionState>(
                        listener: (context, state) async {
                          if (state is JoinSessionSuccess) {
                            await [
                              Permission.camera,
                              Permission.microphone,
                            ].request();
                            final session =
                            await SessionService.createSession(
                              bookingCode: widget.session.bookingCode,
                              minutes: 2,
                            );

                            Get.to(() =>
                                CallScreen(
                                  session: widget.session,
                                  durationMinutes:
                                  getRemainingCallMinutesForCall(),
                                ));
                          } else if (state is JoinSessionFailure) {
                            Get.snackbar("Error", state.error);
                          }
                        },
                        builder: (context, state) {
                          final isJoining = state is JoinSessionLoading;

                          final canJoin = _timeRemaining.inSeconds <= 0;

                          return GestureDetector(
                            onTap: (canJoin && !isJoining)
                                ? () {
                              context.read<JoinSessionBloc>().add(
                                JoinSessionRequested(
                                  widget.session.sessionId,
                                ),
                              );
                            }
                                : null,
                            child: Container(
                              height: screenWidth * 0.11,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: canJoin
                                    ? Colors.green
                                    : AppPalette.primary,
                                borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03),
                              ),
                              child: isJoining
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                canJoin
                                    ? "Live now"
                                    : "Session starts in ${_formatDuration(
                                    _timeRemaining)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : BlocProvider(
                      create: (_) => sl<PayBookingBloc>(),
                      child:
                      BlocConsumer<PayBookingBloc, PayBookingState>(
                        listener: (context, state) {
                          if (state is PayBookingSuccessState) {
                            Get.to(
                                  () =>
                                  PaymentWebViewScreen(
                                    checkoutUrl: state.checkoutUrl,
                                    successUrl: state.successUrl,
                                    cancelUrl: state.cancelUrl,
                                    bookingId: widget.session.sessionId,
                                  ),
                            )?.then((_) {
                              context
                                  .read<GetBookingsCubit>()
                                  .fetchAllBookings(widget.currentStatus);
                            });
                          } else if (state is PayBookingFailureState) {
                            Get.snackbar(
                              "Payment Error",
                              state.error,
                            );
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
                                  bookingId:
                                  widget.session.sessionId,
                                  voucherId:
                                  selectedVoucher?.id,
                                ),
                              );
                            },
                            child: Container(
                              height: screenWidth * 0.11,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppPalette.primary,
                                borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03),
                              ),
                              child: isPayLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text(
                                "Pay Now",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ))
                        : (isPaid)
                        ? Container(
                      height: screenWidth * 0.11,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _timeRemaining.inSeconds > 0
                            ? AppPalette.primary
                            : Colors.green,
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Text(
                        _timeRemaining.inSeconds > 0
                            ? "Session starts in ${_formatDuration(
                            _timeRemaining)}"
                            : "Ready to start",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )

                    // ⭐ هنا بقى أهم جزء
                        : (canShowCancel)
                        ? BlocProvider(
                      create: (_) => sl<CancelBookBloc>(),
                      child: BlocConsumer<CancelBookBloc,
                          CancelBookState>(
                        listener: (context, state) {
                          if (state is CancelBookSuccess) {
                            Get.snackbar(
                                "Success", "Session cancelled");
                            context
                                .read<GetBookingsCubit>()
                                .fetchAllBookings(
                                widget.currentStatus);
                          }

                          if (state is CancelBookFailure) {
                            Get.snackbar(
                                "Error", state.error.error.message);
                          }
                        },
                        builder: (context, state) {
                          final isLoading =
                          state is CancelBookLoading;

                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: screenWidth * 0.11,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                    _timeRemaining.inSeconds > 0
                                        ? AppPalette.primary
                                        : Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                  child: Text(
                                    _timeRemaining.inSeconds > 0
                                        ? "Session starts in ${_formatDuration(
                                        _timeRemaining)}"
                                        : "Ready to start",
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () {
                                  context
                                      .read<CancelBookBloc>()
                                      .add(
                                    CancelBookSession(
                                      id: widget.session
                                          .sessionId,
                                      recipientId: widget
                                          .session
                                          .studentId,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                      : const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )

                    // fallback
                        : Container(
                      height: screenWidth * 0.11,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _timeRemaining.inSeconds > 0
                            ? AppPalette.primary
                            : Colors.green,
                        borderRadius:
                        BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Text(
                        _timeRemaining.inSeconds > 0
                            ? "Session starts in ${_formatDuration(
                            _timeRemaining)}"
                            : "Ready to start",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    if (isRejected)
                      Container(
                        height: screenWidth * 0.11,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                              screenWidth * 0.03),
                        ),
                        child: const Text(
                          "Session Rejected",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    else
                      Container(
                        height: screenWidth * 0.11,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(
                              screenWidth * 0.03),
                        ),
                        child: const Text(
                          "Pending approval",
                          style: TextStyle(color: AppPalette.primary),
                        ),
                      ),
=======
              else if (isAccepted && widget.session.price == 0)
                GestureDetector(
                  onTap: _timeRemaining.inSeconds <= 0
                      ? () {
                          Get.to(() => CallPage(
                                // callID: widget.session.bookingCode,
                                // userID: widget.session.instructorId,
                                // userName: widget.session.name,
                                // userAvatarUrl: widget.session.image,
                                // isStudent: widget.session.isStudent,
                                session: widget.session,
                              ));
                        }
                      : null,
                  child: Container(
                    height: screenWidth * 0.11,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _timeRemaining.inSeconds > 0
                          ? Theme.of(context).primaryColor
                          : Colors.green,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: Text(
                      _timeRemaining.inSeconds > 0
                          ? "Session starts in ${_formatDuration(_timeRemaining)}"
                          : "Live now",
                      style: const TextStyle(color: Colors.white),
                    ),
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
                          height: screenWidth * 0.11,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                          ),
                          child: isPayLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
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
                  height: screenWidth * 0.11,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: const Text("Pending approval"),
                ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            ],
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
  required double screenWidth,
<<<<<<< HEAD
  String? extra,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}) {
  return Row(
    children: [
      Icon(icon, size: screenWidth * 0.045),
      SizedBox(width: screenWidth * 0.015),
<<<<<<< HEAD
      Flexible(
        child: Text(
          extra != null ? "$data • $extra" : data,
          style: TextStyle(
            color: data == "Free" ? Colors.green : null,
          ),
        ),
      ),
=======
      Flexible(child: Text(data)),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
