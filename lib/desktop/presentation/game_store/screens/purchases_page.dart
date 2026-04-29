import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/game_stor/widgets/purchases_item_card.dart';
import '../../../../mobile/presentation/game_stor/widgets/show_store_daiolg.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_state.dart';
import '../../../../shared/data/models/store/purchase_mapper.dart';

class MyPurchasesPage extends StatelessWidget {
  const MyPurchasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// 🔝 Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              children: [
                /// Back
                IconButton(
                  onPressed: () => desktopKey.currentState?.goBack(),
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(width: 12),

                /// Title
                const Text(
                  "Leaderboard",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),

          /// ➖ Divider
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 20),

          /// 📋 List
          BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.purchases.isEmpty) {
                return const Center(child: Text("No Purchases Yet"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.purchases.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (_, i) {
                  final purchase = state.purchases[i];

                  return PurchasesItemCard(
                    item: purchase.toStoreItem(),
                    isSelected: false,
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
