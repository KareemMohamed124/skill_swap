import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skill_swap/desktop/presentation/game_store/widgets/fantasy_store_header.dart';
import 'package:skill_swap/desktop/presentation/game_store/widgets/store_item_card.dart';
import 'package:skill_swap/desktop/presentation/game_store/widgets/timer_widget.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/data/repositories/store_repository_impl.dart';
import '../../../../shared/data/web_services/store/store_api_service.dart';
import '../../../../shared/dependency_injection/injection.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String? selectedId;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreCubit>()..getStoreItems(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }

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
              return Column(
                children: [
                  const FantasyStoreHeader(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.items.isEmpty) {
                          return const Center(
                            child: Text(
                              "No items available",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }

                        return GridView.builder(
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
