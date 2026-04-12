import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/data/repositories/store_repository_impl.dart';
import '../../../../shared/data/web_services/store/store_api_service.dart';
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

  /// 🔥 GetStorage
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dio = Dio();
        final api = StoreApiService(dio);
        final repo = StoreRepositoryImpl(api: api);

        final cubit = StoreCubit(repo);

        cubit.getStoreItems(); // 🔥 تحميل الداتا

        return cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {
              /// 🔴 Error من الشراء
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              /// 🟢 Success
              if (state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              /// 🟡 Loading
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// 🔴 Empty
              if (state.items.isEmpty) {
                return const Center(
                  child: Text("No items available"),
                );
              }

              return Column(
                children: [
                  const FantasyStoreHeader(),
                  const SizedBox(height: 8),

                  /// 💰 Coins (اختياري)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on),
                        const SizedBox(width: 6),
                        Text(
                          state.coins.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔥 Store Grid
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
