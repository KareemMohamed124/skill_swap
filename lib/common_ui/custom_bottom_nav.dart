import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <NavItem>[
      NavItem(icon: Icons.home_outlined, label: 'Home'),
      NavItem(icon: Icons.chat_bubble_outline, label: 'Chat'),
      NavItem(icon: Icons.search, label: 'Search'),
      NavItem(icon: Icons.calendar_today_outlined, label: 'Session'),
      NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;

            if (isSelected) {
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(-0.4, -0.3),
                          radius: 1.0,
                          colors: [
                            Color(0xFF2D8CFF),
                            Color(0xFF0D035F),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D035F).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: Colors.indigo[900]!.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.indigo[900]!.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  NavItem({required this.icon, required this.label});
}