import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../helper/local_storage.dart';
import 'get_bookings_state.dart';

class GetBookingsCubit extends Cubit<GetBookingsState> {
  final BookingRepository bookingRepository;

  GetBookingsCubit(this.bookingRepository) : super(GetBookingsInitial());

  Future<void> fetchAllBookings(String status) async {
    emit(GetBookingsLoading());

    try {
      final response = await bookingRepository.getAllBookings(status);

      final currentUserId = LocalStorage.getUserId();

      final sessions = response.bookings.map((booking) {
        final dateTime = DateTime(
          booking.date.year,
          booking.date.month,
          booking.date.day,
          int.parse(booking.time.split(":")[0]),
          int.parse(booking.time.split(":")[1]),
        );

        final bool isMeSender = booking.userId.id == currentUserId;
        final bool isIncoming = booking.requestedUser.id == currentUserId;

        final otherUser = isMeSender ? booking.requestedUser : booking.userId;

        final String displayStatus = isIncoming && booking.status == "pending"
            ? "requested"
            : booking.status;

        return SessionModel(
          sessionId: booking.id,
          userId: otherUser.id,
          name: otherUser.name,
          role: "Student",
          image: "assets/images/people_images/Ahmed Ibrahim.png",
          dateTime: dateTime,
          price: booking.price.toString(),
          status: mapStatusToLabel(displayStatus),
          rawStatus: displayStatus,
          timeAgo: _calculateTimeAgo(dateTime),
        );
      }).toList();

      emit(GetBookingsLoaded(bookings: sessions));
    } catch (e) {
      emit(GetBookingsError(message: e.toString()));
    }
  }

  String mapStatusToLabel(String status) {
    switch (status) {
      case "pending":
        return "Pending Approval";
      case "accepted":
        return "Accepted";
      case "rejected":
        return "Rejected";
      case "cancelled":
        return "Cancelled";
      case "completed":
        return "Completed";
      case "requested":
        return "Requested";
      default:
        return status;
    }
  }

  String _calculateTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }
}
