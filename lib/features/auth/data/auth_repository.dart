import '../../../bookly_lite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseService _firebaseService;

  AuthRepository(this._firebaseService);

  Stream<User?> get authStateChanges => _firebaseService.authStateChanges();

  Future<UserModel?> signIn(String email, String password) async {
    final credential = await _firebaseService.signInWithEmailAndPassword(
      email,
      password,
    );
    final firebaseUser = credential?.user;
    if (firebaseUser == null) return null;
    await saveSession(firebaseUser);
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  Future<void> saveSession(User firebaseUser) async {
    final session = await SharedPreferences.getInstance();
    await session.setString('token', firebaseUser.uid.toString());
  }

  Future<UserModel?> signUp(String email, String password) async {
    final credential = await _firebaseService.signUpWithEmailAndPassword(
      email,
      password,
    );
    final firebaseUser = credential?.user;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = await _firebaseService.getCurrentUser();
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  Future<void> signOut() async => await _firebaseService.signOut();
}
