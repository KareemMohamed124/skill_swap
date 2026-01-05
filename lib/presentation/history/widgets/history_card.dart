import 'package:flutter/material.dart';

import '../models/history_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel data;

  const HistoryCard({super.key, required this.data});

  Color getStatusColor() {
    switch (data.status) {
      case "Finished":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Cancelled":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool get isIssue => data.errorMessage != null;
  bool get isCancelled => data.status == "Cancelled";
  bool get isFinishedRated => data.status == "Finished" && data.rating > 0;
  bool get isFinishedNotRated =>
      data.status == "Finished" && data.rating == 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFD6D6D6).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD6D6D6), width: 1.2),
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    data.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(data.role, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.calendar_month, size: 20),
                const SizedBox(width: 8),
                Text(data.date),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text("${data.time} – ${data.duration}"),
              ],
            ),

            const SizedBox(height: 16),

            buildBottomSection(context),
          ],
        ),
    );
  }




  Widget buildBottomSection(BuildContext context) {
    if (isIssue) {
      return Container(
//padding: const EdgeInsets.all(8),
      height: 44,
        decoration: BoxDecoration(
          color: Color(0xFFF9DADA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16,),
            const Text("Error: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(data.errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      );
    }

    if (isCancelled) {
      return Container(
        width: double.infinity,
        height: 44,
      //  padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color:  Color(0xFFD6D6D6)
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child:Center(child: const Text(
            "View Details",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        )),
      );
    }

    if (isFinishedRated) {
      return Container(
        height: 44,
        //padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFE7BA2A).withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16,),
            const Text("Your rating: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  i < data.rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
      );
    }

    if (isFinishedNotRated) {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: (){},
              child: Container(
                // width: double.infinity,
                  height: 44,
                  //  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:  Color(0xFFD6D6D6)
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border_outlined),
                      SizedBox(width: 4,),
                      Text("Rate Session")
                    ],
                  )
              ),
            ),
          ),
          SizedBox(width: 8,),
          Expanded(
              child: InkWell(
                onTap: (){},
                child: Container(
                 // width: double.infinity,
                  height: 44,
                  //  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:  Color(0xFFD6D6D6)
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined),
                      SizedBox(width: 4,),
                      Text("View Details")
                    ],
                  )
                          ),
              ),
          )
        ],
      );

      //   Container(
      //   height: 44,
      //  // padding: const EdgeInsets.all(12),
      //   decoration: BoxDecoration(
      //    // color: Colors.blue.shade50,
      //     borderRadius: BorderRadius.circular(14),
      //   ),
      //   child: Row(
      //     children: [
      //       Expanded(
      //
      //         child: ElevatedButton(
      //           onPressed: () {
      //             // Rate Session Page
      //           },
      //           style: ElevatedButton.styleFrom(
      //             padding: const EdgeInsets.all(12),
      //            // backgroundColor: Colors.blue,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(16),
      //
      //             ),
      //             side: const BorderSide(color:Color(0xFFD6D6D6)),
      //
      //           ),
      //           child: const Text("Rate Session"),
      //         ),
      //       ),
      //       const SizedBox(width: 8),
      //       Expanded(
      //         child: OutlinedButton(
      //           onPressed: () {
      //             // View Details Page
      //           },
      //           style: OutlinedButton.styleFrom(
      //             padding: const EdgeInsets.all(12),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(16)
      //             ),
      //             side: const BorderSide(color:Color(0xFFD6D6D6)),
      //           ),
      //           child: const Text("View Details"),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }

    return const SizedBox();
  }

  Widget secondaryActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 4),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

}

