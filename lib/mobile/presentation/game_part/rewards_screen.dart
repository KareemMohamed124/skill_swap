import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/game_part/reward_card.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';

class RewardsScreen extends StatelessWidget {
  final int myRank;

  const RewardsScreen({super.key, required this.myRank});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rewards"),
      ),
      body: BlocBuilder<StoreCubit, StoreState>(
        builder: (context, state) {

          /// 🟡 مش وقت الكلايم
          if (!state.isClaimPhase) {
            return _buildPreview(context);
          }

          /// 🟡 برا top 10
          if (myRank > 10) {
            return const Center(
              child: Text(
                "Keep going! Reach top 10 next month 💪",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          /// 🟢 وقت الكلايم
          return _buildClaim(context, state);
        },
      ),
    );
  }

  // ================= PREVIEW =================

  Widget _buildPreview(BuildContext context) {
    final cubit = context.read<StoreCubit>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RewardCard(
          rank: 1,
          preview: true,
          rewards: cubit.getRewardItemsByRank(1),
        ),
        RewardCard(
          rank: 2,
          preview: true,
          rewards: cubit.getRewardItemsByRank(2),
        ),
        RewardCard(
          rank: 3,
          preview: true,
          rewards: cubit.getRewardItemsByRank(3),
        ),
        RewardCard(
          range: "4-10",
          preview: true,
          rewards: cubit.getRewardItemsByRank(4),
        ),
      ],
    );
  }

  // ================= CLAIM =================

  Widget _buildClaim(BuildContext context, StoreState state) {
    final cubit = context.read<StoreCubit>();

    return Center(
      child: RewardCard(
        rank: myRank <= 3 ? myRank : null,
        range: myRank > 3 ? "4-10" : null,
        isClaim: true,
        isClaimed: state.isClaimed,
        isLoading: state.isLoading,
        rewards: cubit.getRewardItemsByRank(myRank),
        onCollect: () {
          cubit.collectRewards(myRank);
        },
      ),
    );
  }
}