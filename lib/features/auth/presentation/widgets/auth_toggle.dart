import 'package:escooter/features/auth/presentation/providers/auth_providers.dart';
import 'package:escooter/features/auth/presentation/widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthToggle extends ConsumerWidget {
  const AuthToggle({super.key, required this.onModeChanged});
  final VoidCallback onModeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authMode = ref.watch(authModeProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: ToggleButton(
                text: 'Login',
                isSelected: authMode == AuthMode.login,
                onTap: () {
                  ref.read(authModeProvider.notifier).state = AuthMode.login;
                  onModeChanged();
                }),
          ),
          Expanded(
            child: ToggleButton(
              text: 'Register',
              isSelected: authMode == AuthMode.register,
              onTap: () {
                ref.read(authModeProvider.notifier).state = AuthMode.register;
                onModeChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}
