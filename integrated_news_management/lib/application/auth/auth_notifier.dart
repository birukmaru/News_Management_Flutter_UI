import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthInitial());

  Future<void> handleCurrentUser(CurrentUser event) async {
    try {
      final user = await authRepository.getCurrentUser();
      state = AuthSuccess(message: user);
    } catch (e) {
      state = const AuthFailure(message: 'Not authenticated');
    }
  }

  Future<void> handleAppStarted(AppStarted event) async {
    try {
      final user = await authRepository.getCurrentUser();
      state = AuthSuccess(message: user);
    } catch (e) {
      state = const AuthFailure(message: 'Not authenticated');
    }
  }

  Future<void> handleUserLoggedIn(UserLoggedIn event) async {
    try {
      final token = await authRepository.login(event.username, event.password);
      if (token != null) {
        state = AuthSuccess(message: token);
      } else {
        state = const AuthFailure(message: 'Not authenticated');
      }
    } catch (e) {
      if (e.toString().contains('IncorrectPassword')) {
        state = const AuthFailure(message: 'Incorrect password');
      } else {
        state =
            const AuthFailure(message: 'User name or password is incorrect');
      }
    }
  }

  Future<void> handleUserLoggedOut(UserLoggedOut event) async {
    try {
      await authRepository.logout(event.message);
      state = AuthFailure(message: 'Logged out successfully');
    } catch (e) {
      state = AuthFailure(message: 'Failed to logout');
    }
  }

  Future<void> handleUserRegistered(UserRegistered event) async {
    try {
      final user =
          await authRepository.register(event.username, event.password);
      if (user != null) {
        state = AuthSuccess(message: user);
      } else {
        state = const AuthFailure(message: 'null returned from register user');
      }
    } catch (e) {
      if (e.toString().contains('userAlreadyExists')) {
        state = const AuthFailure(message: 'User Name is already taken');
      } else {
        state = const AuthFailure(message: 'Failed to register user');
      }
    }
  }

  Future<void> handleUserDeleted(UserDeleted event) async {
    try {
      await authRepository.delete(event.id);
    } catch (e) {
      state = const AuthFailure(message: "Failed to delete user");
    }
  }

  Future<void> handleUserUpdated(UserUpdated event) async {
    try {
      final dynamic data = await authRepository.update(
          event.id, event.username, event.newPassword, event.oldPassword);

      if (data != null) {
        state = AuthSuccess(message: data);
      } else {
        state = const AuthFailure(message: 'update failed');
      }
    } catch (e) {
      state = const AuthFailure(message: 'Failed to update user');
    }
  }
}
