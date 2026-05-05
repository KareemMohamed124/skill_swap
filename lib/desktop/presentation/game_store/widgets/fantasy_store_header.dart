import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../screens/purchases_page.dart';
import 'show_store_daiolg.dart';

class FantasyStoreHeader extends StatelessWidget {
  const FantasyStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final coins = context.select<MyProfileCubit, num>(
      (cubit) => cubit.coins,
    );

    return BlocBuilder<StoreCubit, StoreState>(
      builder: (_, state) {
        final d = state.remaining;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
            border: Border.all(
              color: AppPalette.primary,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withOpacity(0.25),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top row — title | coins | help | bag
              Row(
                children: [
                  Text(
                    "Store",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppPalette.primary,
                      letterSpacing: 0.8,
                    ),
                  ),

                  Expanded(
                    child: Text(
                      "$coins",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppPalette.primary,
                      ),
                    ),
                  ),

                  /// Help button
                  Tooltip(
                    message: "Store Info",
                    child: InkWell(
                      onTap: () => showStoreDialog(
                        context,
                        isFirstTime: false,
                        title: "Skill Swap Store",
                        subtitle: "store",
                      ),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: AppPalette.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// My Purchases button (desktop-only)
                  Tooltip(
                    message: "My Purchases",
                    child: InkWell(
                      onTap: () {
                        desktopKey.currentState?.openSidePage(
                          body: BlocProvider(
                            create: (_) =>
                                sl<PurchaseCubit>()..getPurchases(),
                            child: const MyPurchasesPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppPalette.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// Timer — right-aligned (same as mobile)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppPalette.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hourglass_bottom,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        "${d.inDays}d "
                        "${(d.inHours % 24).toString().padLeft(2, '0')}:"
                        "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
                        "${(d.inSeconds % 60).toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
