import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/bloc/store_cubit/purchase_state.dart';

class ChatThemePage extends StatefulWidget {
  const ChatThemePage({super.key}); // ✅ مش محتاج userId بعد كده

  @override
  State<ChatThemePage> createState() => _ChatThemePageState();
}

class _ChatThemePageState extends State<ChatThemePage> {
  // ❌ امسح GetStorage خالص
  // final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Theme")),
      body: BlocBuilder<PurchaseCubit, PurchaseState>(
        builder: (context, purchaseState) {
          if (purchaseState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final themes =
              purchaseState.purchases.where((p) => p.type == "theme").toList();

          return BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, profileState) {
              final activeThemeValue = profileState is MyProfileLoaded
                  ? profileState.profile.activeTheme?.value ?? "default"
                  : "default";
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  // Default option
                  RadioListTile<String>(
                    title: const Text("Default Theme"),
                    value: "default",
                    groupValue: activeThemeValue,
                    onChanged: (val) {
                      // ✅ لو default → clear الـ active theme
                      context.read<MyProfileCubit>().setActiveTheme("default");
                    },
                  ),

                  const Divider(),

                  ...themes.map((theme) {
                    final value = theme.itemId?.value ?? "";
                    final themeId = theme.itemId?.id ?? "";
                    final image = theme.itemId?.img?.secureUrl ?? "";

                    return RadioListTile<String>(
                      value: value,
                      groupValue: activeThemeValue,
                      onChanged: (val) {
                        if (val != null) {
                          // ✅ API call
                          context
                              .read<MyProfileCubit>()
                              .setActiveTheme(themeId);
                        }
                      },
                      title: Text(theme.itemId?.title ?? ""),
                      subtitle: Text(value),
                      secondary: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: image.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: image.isEmpty
                            ? const Icon(Icons.image, size: 20)
                            : null,
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
