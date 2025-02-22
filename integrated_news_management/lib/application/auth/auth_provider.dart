import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integrated_new_management/application/auth/auth_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authService: AuthService());
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository: authRepository);
});
