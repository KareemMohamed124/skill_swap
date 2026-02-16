import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_event.dart';
import '../../../../shared/bloc/delete_account_bloc/delete_account_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../sign/screens/sign_in_screen.dart';
import 'info_field.dart';

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.02;

    return BlocProvider(
      create: (_) => sl<DeleteAccountBloc>(),
      child: BlocListener<DeleteAccountBloc, DeleteAccountState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccessState) {
            Get.offAll(() => const SignInScreen());
          } else if (state is DeleteAccountFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
          builder: (context, state) {
            return Container(
              decoration: boxDecoration(),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle("Account Actions"),
                  SizedBox(height: screenHeight * 0.01),
                  state is DeleteAccountLoading
                      ? const Center(child: CircularProgressIndicator())
                      : OutlinedButton.icon(
                          onPressed: () => _showDeleteConfirmation(context),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            "Delete Account",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<DeleteAccountBloc>().add(DeleteAccountSubmit());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
