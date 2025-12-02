import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          reviewCard(
            name: "Mike Chen",
            review: "Amazing help with React! Very patient and knowledgeable.",
            skill: "React",
            time: "2 days ago",
            rating: 5,
            image: "https://i.pravatar.cc/150?img=3",
          ),
          const SizedBox(height: 20),
          reviewCard(
            name: "Sarah Johnson",
            review:
            "Great session on JavaScript fundamentals. Highly recommend!",
            skill: "JavaScript",
            time: "1 week ago",
            rating: 5,
            image: "https://i.pravatar.cc/150?img=5",
          ),
        ],
      ),
    );
  }

  Widget reviewCard({
    required String name,
    required String review,
    required String skill,
    required String time,
    required int rating,
    required String image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Color(0XFF0D035F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Name + Stars
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundImage: NetworkImage(image)),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        rating,
                            (i) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(review),

          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(skill),
              ),
              const Spacer(),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}