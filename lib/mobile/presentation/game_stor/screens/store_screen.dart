import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../widgets/fantasy_store_header.dart';
import '../widgets/store_item_card.dart';
import '../widgets/timer_widget.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String? selectedId;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              return Column(
                children: [
                  FantasyStoreHeader(),
                  const SizedBox(height: 8),

                  /// 🔥 Store
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (_, i) {
                        final item = state.items[i];

                        return StoreItemCard(
                          item: item,
                          isSelected: selectedId == item.id,
                          onTap: () {
                            setState(() {
                              selectedId = item.id;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const TimerWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
