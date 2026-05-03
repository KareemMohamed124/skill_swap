import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../models/store_item_model.dart';

class StoreItemCard extends StatefulWidget {
  final StoreItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const StoreItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<StoreItemCard> createState() => _StoreItemCardState();
}

class _StoreItemCardState extends State<StoreItemCard>
    with TickerProviderStateMixin {
  late int selectedHours;

  final int minHours = 1;
  final int maxHours = 8;
  final int pricePerHour = 10;

  late AnimationController rotateController;
  late AnimationController buyEffectController;
  late AnimationController floatingController;
  late AnimationController coinFlyController;
  late Animation<double> coinFlyAnimation;

  @override
  void initState() {
    super.initState();

    selectedHours = minHours;

    rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    buyEffectController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: -5,
      upperBound: 5,
    )..repeat(reverse: true);

    coinFlyController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    coinFlyAnimation = Tween<double>(begin: 0, end: -80).animate(
      CurvedAnimation(parent: coinFlyController, curve: Curves.easeOut),
    );
  }

  Color getRarityColor() {
    switch (widget.item.rarity) {
      case "rare":
        return Colors.blue;
      case "epic":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  void didUpdateWidget(covariant StoreItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected) {
      rotateController.repeat();
    } else {
      rotateController.stop();
      rotateController.reset();
    }
  }

  @override
  void dispose() {
    rotateController.dispose();
    buyEffectController.dispose();
    floatingController.dispose();
    coinFlyController.dispose();
    super.dispose();
  }

  void onBuyPressed() async {
    if (widget.item.isPurchased) return;

    await buyEffectController.forward(from: 0);
    coinFlyController.forward(from: 0);

    context.read<StoreCubit>().buyItem(widget.item.id);

    buyEffectController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = getRarityColor();
    final isDisabled = item.isLocked || item.isPurchased;

    return AnimatedBuilder(
      animation: Listenable.merge(
          [buyEffectController, floatingController, coinFlyController]),
      builder: (context, child) {
        final glow = buyEffectController.value;

        return Container(
          // ✅ غيرنا AnimatedContainer لـ Container عادي
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
            border: Border.all(color: color.withOpacity(0.8)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15 + glow),
                blurRadius: 25,
                spreadRadius: glow * 10,
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// 💰 Coin Animation
              AnimatedBuilder(
                animation: coinFlyController,
                builder: (context, child) {
                  if (coinFlyController.value == 0) {
                    return const SizedBox();
                  }

                  return Positioned(
                    bottom: 60 + coinFlyAnimation.value,
                    child: Opacity(
                      opacity: 1 - coinFlyController.value,
                      child: Transform.scale(
                        scale: 1 + (coinFlyController.value * 0.5),
                        child: Image.asset(
                          "assets/images/store_images/coin.png",
                          height: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// ✨ Glow
              if (buyEffectController.value > 0)
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15 * (1 - glow)),
                  ),
                ),

              /// 🔥 MAIN LAYOUT (50 / 50)
              LayoutBuilder(
                builder: (context, constraints) {
                  final half = constraints.maxWidth / 2;

                  return Row(
                    children: [
                      /// 🔹 LEFT IMAGE
                      SizedBox(
                        width: half,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: Listenable.merge(
                                [rotateController, floatingController]),
                            builder: (_, __) {
                              return Transform.translate(
                                offset: Offset(0, floatingController.value),
                                child: Transform.rotate(
                                  angle: widget.isSelected
                                      ? rotateController.value * 6.28
                                      : 0,
                                  child: item.image.startsWith("http")
                                      ? Image.network(item.image, height: 80)
                                      : Image.asset(item.image, height: 80),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        width: half,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 💰 السعر
                                Text(
                                  item.price.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isDisabled ? Colors.grey : color,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // 🛒 زرار الشراء
                                GestureDetector(
                                  onTap: isDisabled ? null : onBuyPressed,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: isDisabled
                                          ? const LinearGradient(
                                              colors: [
                                                Colors.grey,
                                                Colors.black
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                color,
                                                color.withOpacity(0.7),
                                              ],
                                            ),
                                    ),
                                    child: Text(
                                      item.isPurchased ? "Owned" : "Buy",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
