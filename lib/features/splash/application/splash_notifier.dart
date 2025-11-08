import 'package:bookly_lite/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bookly_lite.dart';

class SplashNotifier extends Notifier<SplashState> {
  @override
  SplashState build() {
    checkAuth();
    return SplashState(
      isLoggedIn: ref.watch(authNotifierProvider).value?.user != null,
    );
  }

  Future<void> checkAuth() async {
    // check if the user is logged in
    final session = await SharedPreferences.getInstance();
    final token = session.getString('token');
    if (token == null || token.isEmpty) {
      state = SplashState(isLoggedIn: false);
    } else {
      state = SplashState(isLoggedIn: true);
    }
  }
}
