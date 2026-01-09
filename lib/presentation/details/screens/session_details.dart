import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/presentation/book_session/screens/profile_mentor.dart';
import '../../book_session/screens/book_session.dart';
import '../models/details_model.dart';

class SessionDetailsPage extends StatelessWidget {
  final SessionModel session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Session Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Mentor Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    session.mentorImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.mentorName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.mentorTrack,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.to(ProfileMentor(
                              id: session.mentorId,
                              image: session.mentorImage,
                              name: session.mentorName,
                              track: session.mentorTrack,
                              rate: session.rating
                          ));
                        },
                        icon: const Icon(Icons.person_outline),
                        label: const Text('View Profile'),
                      ),
                    ],
                  ),
                ),

                /// Status + Reason (ثابت)
                Text(
                  'Finished',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),


            /// Session Summary
            const Text(
              'Session Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            _infoRow(
              Icons.calendar_today,
              'Date',
              '${session.date.day}-${session.date.month}-${session.date.year}',
            ),
            _infoRow(Icons.access_time, 'Time', session.time),
            _infoRow(
              Icons.timer_outlined,
              'Duration',
              '${session.duration} min',
            ),

            const Divider(height: 32),

            /// Session Notes
            const Text(
              'Session Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              session.notes,
              style: const TextStyle(color: Colors.grey),
            ),


            const Divider(height: 32),

            /// Session Notes
            const Text(
              'Session Conclusion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'The session ended earlier than expected!',
              style: const TextStyle(color: Colors.grey),
            ),


            const Divider(height: 32),

            /// Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Rating',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Rating'),
                ),
              ],
            ),

            Row(
              children: [
                ...List.generate(
                  5,
                      (index) => Icon(
                    index < session.rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                // Text(
                //   session.review,
                //   style: const TextStyle(color: Colors.grey),
                // ),
              ],
            ),

            const Divider(height: 32),

            /// Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            _actionTile(Icons.calendar_today, 'Rebook Session'),
            //_actionTile(Icons.attach_file, 'View Attachments'),
            //_actionTile(Icons.history, 'Session History'),



          ],
        ),
      ),
    );
  }

  /// Helpers
  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xffEEEEEE)),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {Get.to(BookSession());},
      ),
    );
  }
}