import '../../../bookly_lite.dart';

class AuthState {
  final UserModel? user;

  const AuthState({this.user});

  AuthState copyWith({UserModel? user}) {
    return AuthState(user: user ?? this.user);
  }
}
