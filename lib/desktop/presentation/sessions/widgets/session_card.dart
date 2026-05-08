import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../../mobile/presentation/payment/payment_webview_screen.dart';
import '../../../../mobile/presentation/sessions/models/session.dart';
import '../../../../mobile/presentation/sessions/widgets/voucher_sheet.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_bloc.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_event.dart';
import '../../../../shared/bloc/join_session_bloc/join_session_state.dart';
import '../../../../shared/bloc/pay_booking_bloc/pay_booking_bloc.dart';
import '../../../../shared/bloc/status_book_bloc/status_book_bloc.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_state.dart';
import '../../../../shared/common_ui/video_call/call_screen.dart';
import '../../../../shared/data/models/status_booking/status_booking_request.dart';
import '../../../../shared/data/models/store/purchases.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/local_storage.dart';

import 'dart:convert';

double _cardMaxWidth(BuildContext context) =>
    MediaQuery.of(context).size.width.clamp(0, 480);

double _r(double cardWidth, double factor,
        {double min = 4, double max = double.infinity}) =>
    (cardWidth * factor).clamp(min, max);

class SessionCard extends StatefulWidget {
  final SessionModel session;
  final String currentStatus;

  const SessionCard(
      {super.key, required this.session, required this.currentStatus});

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  Duration _timeRemaining = Duration.zero;
  Timer? _timer;

  String? currentUserId;
  bool isStudent = false;
  Purchases? selectedVoucher;
  double finalPrice = 0;

  bool get isPending => widget.session.rawStatus == "pending";

  bool get isAccepted => widget.session.rawStatus == "accepted";

  bool get isRequested => widget.session.rawStatus == "requested";

  bool get isCompleted => widget.session.rawStatus == "completed";

  bool get isCancelled => widget.session.rawStatus == "cancelled";

  bool get isRejected => widget.session.rawStatus == "rejected";

  bool get isPaid => widget.session.paymentStatus == "paid";

  bool get isUnpaid => widget.session.paymentStatus == "unpaid";

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

  int getRemainingCallMinutesForCall() {
    final now = DateTime.now();
    final start = widget.session.dateTime;
    final end = start.add(Duration(minutes: widget.session.duration.toInt()));
    if (now.isBefore(start)) return widget.session.duration.toInt();
    final remaining = end.difference(now).inMinutes;
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

  @override
  void initState() {
    super.initState();
    _loadUser();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    finalPrice = widget.session.price.toDouble();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _timeRemaining = widget.session.dateTime.difference(now);
    });
  }

  double calculatePrice(double price, String value) {
    final percent = double.parse(value.replaceAll("%", ""));
    return price - (price * percent / 100);
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

  String formatTime12h(DateTime dt) => DateFormat('hh:mm a').format(dt);

  String _formatDuration(Duration duration) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(duration.inHours)}:${two(duration.inMinutes.remainder(60))}:${two(duration.inSeconds.remainder(60))}";
  }

  Widget _buildUserImage(double avatarSize) {
    final image = widget.session.userImage;

    Widget placeholder = Container(
      width: avatarSize,
      height: avatarSize,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      child: const Icon(Icons.person, color: Colors.white),
    );

    if (image == null || image.isEmpty) return placeholder;

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    if (image.startsWith("data:image")) {
      try {
        final bytes = base64Decode(image.split(',')[1]);
        return Image.memory(
          bytes,
          width: avatarSize,
          height: avatarSize,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        );
      } catch (_) {
        return placeholder;
      }
    }

    return placeholder;
  }

  Widget _joinButton({
    required double cardWidth,
    required bool isJoining,
    required VoidCallback? onTap,
  }) {
    final canJoin = _timeRemaining.inSeconds <= 0;
    return GestureDetector(
      onTap: (canJoin && !isJoining) ? onTap : null,
      child: _actionContainer(
        cardWidth: cardWidth,
        color: canJoin ? Colors.green : AppPalette.primary,
        child: isJoining
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(
                canJoin
                    ? "Live now"
                    : "Session starts in ${_formatDuration(_timeRemaining)}",
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  Widget _actionContainer({
    required double cardWidth,
    required Color color,
    required Widget child,
  }) {
    return Container(
      height: _r(cardWidth, 0.11, min: 44, max: 52),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(_r(cardWidth, 0.03, min: 8, max: 12)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = _cardMaxWidth(context);

    final avatarSize = _r(cardWidth, 0.12, min: 40, max: 56);
    final padding = _r(cardWidth, 0.04, min: 12, max: 20);
    final gapSm = _r(cardWidth, 0.02, min: 6, max: 10);
    final gapMd = _r(cardWidth, 0.04, min: 12, max: 20);
    final iconSize = _r(cardWidth, 0.045, min: 16, max: 22);
    final badgeFontSize = _r(cardWidth, 0.03, min: 11, max: 13);

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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(_r(cardWidth, 0.04, min: 10, max: 16)),
            onTap: () {
              Get.to(() => CallScreen(
                    session: widget.session,
                    remainingMinutes: getRemainingCallMinutesForCall(),
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                    _r(cardWidth, 0.04, min: 10, max: 16)),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(child: _buildUserImage(avatarSize)),
                      SizedBox(width: gapSm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.session.userName ?? "User",
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(widget.session.userRole ?? "Normal",
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
                          padding: EdgeInsets.symmetric(
                            horizontal: gapSm,
                            vertical: gapSm * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                                _r(cardWidth, 0.03, min: 8, max: 12)),
                            border: Border.all(color: badgeColor),
                          ),
                          child: Text(
                            badgeText(isLoading: isLoading),
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: badgeFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: gapMd),

                  _iconText(
                    context: context,
                    icon: Icons.access_time,
                    data: formatTime12h(widget.session.dateTime),
                    extra: "${widget.session.duration} min",
                    iconSize: iconSize,
                    gap: gapSm,
                  ),
                  SizedBox(height: gapSm),
                  _iconText(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    data:
                        "${widget.session.dateTime.day}/${widget.session.dateTime.month}/${widget.session.dateTime.year}",
                    iconSize: iconSize,
                    gap: gapSm,
                  ),
                  SizedBox(height: gapSm),

                  Row(
                    children: [
                      Icon(Icons.attach_money, size: iconSize),
                      SizedBox(width: gapSm),
                      if (isPaid) ...[
                        Text(
                          '${widget.session.price}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Paid",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ] else
                        Text(widget.session.price == 0
                            ? "Free"
                            : '${widget.session.price}'),
                      const SizedBox(width: 8),
                      if (isUnpaid &&
                          widget.session.price > 0 &&
                          widget.session.isStudent &&
                          !isRejected &&
                          !isCancelled &&
                          !isCompleted)
                        const Text(
                          "Payment Required",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),

                  SizedBox(height: gapSm),

                  BlocBuilder<PurchaseCubit, PurchaseState>(
                    builder: (context, state) {
                      final vouchers =
                          context.read<PurchaseCubit>().getAvailableVouchers();

                      if (isPaid ||
                          !widget.session.isStudent ||
                          !isAccepted ||
                          vouchers.isEmpty ||
                          widget.session.price <= 0) {
                        return const SizedBox();
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
                                      builder: (_) => VoucherSheet(
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
                                        selectedVoucher!
                                                .itemId?.img?.secureUrl ??
                                            "",
                                        width: 100,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
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
                                            selectedVoucher!.itemId?.title ??
                                                "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            selectedVoucher!.itemId?.value ??
                                                "",
                                            style: const TextStyle(
                                                color: Colors.grey),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: gapMd),

                  // ── ACTION AREA ──────────────────────────────────────────
                  _buildActionArea(cardWidth: cardWidth, isLoading: isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionArea(
      {required double cardWidth, required bool isLoading}) {
    // REQUESTED → Accept / Decline
    if (isRequested) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<StatusBookBloc>().add(
                            StatusBookSession(
                              id: widget.session.sessionId,
                              request: StatusBookingRequest(status: "accepted"),
                              studentId: widget.session.studentId,
                            ),
                          );
                    },
              child:
                  const Text("Accept", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(width: _r(cardWidth, 0.03, min: 8, max: 16)),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<StatusBookBloc>().add(
                            StatusBookSession(
                              id: widget.session.sessionId,
                              request: StatusBookingRequest(status: "rejected"),
                              studentId: widget.session.userId,
                            ),
                          );
                    },
              child:
                  const Text("Decline", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    // FREE SESSION
    if (isAccepted && widget.session.price == 0) {
      return BlocProvider(
        create: (_) => sl<JoinSessionBloc>(),
        child: BlocConsumer<JoinSessionBloc, JoinSessionState>(
          listener: (context, state) {
            if (state is JoinSessionSuccess) {
              Get.to(() => CallScreen(
                  session: widget.session,
                  remainingMinutes: getRemainingCallMinutesForCall()));
            } else if (state is JoinSessionFailure) {
              Get.snackbar("Error", state.error);
            }
          },
          builder: (context, state) {
            final isJoining = state is JoinSessionLoading;
            return _joinButton(
              cardWidth: cardWidth,
              isJoining: isJoining,
              onTap: () => context
                  .read<JoinSessionBloc>()
                  .add(JoinSessionRequested(widget.session.sessionId)),
            );
          },
        ),
      );
    }

    // PAID SESSION
    if (isAccepted && widget.session.price > 0) {
      if (!widget.session.isStudent) {
        // Teacher view
        return _actionContainer(
          cardWidth: cardWidth,
          color:
              _timeRemaining.inSeconds > 0 ? AppPalette.primary : Colors.green,
          child: Text(
            _timeRemaining.inSeconds > 0
                ? "Session starts in ${_formatDuration(_timeRemaining)}"
                : "Ready to start",
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      // Student — paid → join
      if (isPaid) {
        return BlocProvider(
          create: (_) => sl<JoinSessionBloc>(),
          child: BlocConsumer<JoinSessionBloc, JoinSessionState>(
            listener: (context, state) {
              if (state is JoinSessionSuccess) {
                Get.to(() => CallScreen(
                    session: widget.session,
                    remainingMinutes: getRemainingCallMinutesForCall()));
              } else if (state is JoinSessionFailure) {
                Get.snackbar("Error", state.error);
              }
            },
            builder: (context, state) {
              final isJoining = state is JoinSessionLoading;
              return _joinButton(
                cardWidth: cardWidth,
                isJoining: isJoining,
                onTap: () => context
                    .read<JoinSessionBloc>()
                    .add(JoinSessionRequested(widget.session.sessionId)),
              );
            },
          ),
        );
      }

      // Student — unpaid → pay
      return BlocProvider(
        create: (_) => sl<PayBookingBloc>(),
        child: BlocConsumer<PayBookingBloc, PayBookingState>(
          listener: (context, state) {
            if (state is PayBookingSuccessState) {
              Get.to(() => PaymentWebViewScreen(
                    checkoutUrl: state.checkoutUrl,
                    successUrl: state.successUrl,
                    cancelUrl: state.cancelUrl,
                    bookingId: widget.session.sessionId,
                  ))?.then((_) {
                context
                    .read<GetBookingsCubit>()
                    .fetchAllBookings(widget.currentStatus);
              });
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
                              voucherId: selectedVoucher?.id,
                            ),
                          );
                    },
              child: _actionContainer(
                cardWidth: cardWidth,
                color: AppPalette.primary,
                child: isPayLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Pay Now",
                        style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      );
    }

    // REJECTED
    if (isRejected) {
      return _actionContainer(
        cardWidth: cardWidth,
        color: Colors.red,
        child: const Text("Session Rejected",
            style: TextStyle(color: Colors.white)),
      );
    }

    return _actionContainer(
      cardWidth: cardWidth,
      color: Colors.grey.shade300,
      child: const Text("Pending approval",
          style: TextStyle(color: AppPalette.primary)),
    );
  }
}

Widget _iconText({
  required BuildContext context,
  required IconData icon,
  required String data,
  required double iconSize,
  required double gap,
  String? extra,
}) {
  return Row(
    children: [
      Icon(icon, size: iconSize),
      SizedBox(width: gap),
      Flexible(
        child: Text(
          extra != null ? "$data • $extra" : data,
          style: TextStyle(color: data == "Free" ? Colors.green : null),
        ),
      ),
    ],
  );
}
