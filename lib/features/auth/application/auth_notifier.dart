import 'dart:developer';

import '../../../bookly_lite.dart';
import '../../../providers/app_providers.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    final user = await _authRepository.getCurrentUser();
    return AuthState(user: user);
  }

  Future<void> signIn(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final user = await _authRepository.signIn(email, password);
      log(user.toString());
      state = AsyncValue.data(AuthState(user: user as UserModel));
    } catch (e) {
      log(e.toString());
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = AsyncValue.loading();
    try {
      final user = await _authRepository.signUp(email, password);
      state = AsyncValue.data(AuthState(user: user as UserModel));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = AsyncValue.data(AuthState(user: null));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getCurrentUser() async {
    final user = await _authRepository.getCurrentUser();
    state = AsyncValue.data(AuthState(user: user as UserModel));
  }
}
