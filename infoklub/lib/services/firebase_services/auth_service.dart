import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static String? getCurrentUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  static String getCurrentUserKey() {
    final email = getCurrentUserEmail();
    if (email == null) return 'guest';

    // Create a safe key from email (replace special characters)
    return email.replaceAll('@', '_').replaceAll('.', '_');
  }
}
