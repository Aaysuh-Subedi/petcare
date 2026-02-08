import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUserId = 'userId';
  static const String _keyFirstName = 'firstName';
  static const String _keyEmail = 'email';
  static const String _keyToken = 'token'; // JWT token
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyRole = 'role';

  final SharedPreferences _prefs;

  SessionService(this._prefs);

  // Save session (including token)
  Future<void> saveSession({
    required String userId,
    required String firstName,
    required String email,
    String? token,
    String? role,
  }) async {
    print('💾 SESSION SERVICE: Saving session for user: $email (ID: $userId)');

    try {
      await _prefs.setString(_keyUserId, userId);
      await _prefs.setString(_keyFirstName, firstName);
      await _prefs.setString(_keyEmail, email);
      if (token != null) {
        await _prefs.setString(_keyToken, token);
        print('✅ SESSION SERVICE: Token saved (${token.length} chars)');
      }
      if (role != null) {
        await _prefs.setString(_keyRole, role);
        print('✅ SESSION SERVICE: Role saved: $role');
      }
      await _prefs.setBool(_keyIsLoggedIn, true);

      print('✅ SESSION SERVICE: Session saved successfully');
      print(
        '📊 SESSION SERVICE: User ID: $userId, Name: $firstName, Email: $email',
      );
    } catch (e) {
      print('❌ SESSION SERVICE: Failed to save session: ${e.toString()}');
      rethrow;
    }
  }

  // Get token - SYNCHRONOUS (SharedPreferences is already loaded)
  String? getToken() {
    final token = _prefs.getString(_keyToken);
    print(
      '🔍 SESSION SERVICE: Retrieved token: ${token != null ? 'Present (${token.length} chars)' : 'Null'}',
    );
    return token;
  }

  // Get user ID
  String? getUserId() {
    final userId = _prefs.getString(_keyUserId);
    print('🔍 SESSION SERVICE: Retrieved user ID: $userId');
    return userId;
  }

  // Get first name
  String? getFirstName() {
    final firstName = _prefs.getString(_keyFirstName);
    print('🔍 SESSION SERVICE: Retrieved first name: $firstName');
    return firstName;
  }

  // Get email
  String? getEmail() {
    final email = _prefs.getString(_keyEmail);
    print('🔍 SESSION SERVICE: Retrieved email: $email');
    return email;
  }

  // Get role
  String? getRole() {
    final role = _prefs.getString(_keyRole);
    print('🔍 SESSION SERVICE: Retrieved role: $role');
    return role;
  }

  // Check if logged in
  bool isLoggedIn() {
    final loggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;
    print('🔍 SESSION SERVICE: Login status: $loggedIn');
    return loggedIn;
  }

  // Clear session (logout)
  Future<void> clearSession() async {
    print('🗑️ SESSION SERVICE: Clearing session');

    try {
      await _prefs.remove(_keyUserId);
      await _prefs.remove(_keyFirstName);
      await _prefs.remove(_keyEmail);
      await _prefs.remove(_keyToken);
      await _prefs.remove(_keyRole);
      await _prefs.setBool(_keyIsLoggedIn, false);

      print('✅ SESSION SERVICE: Session cleared successfully');
    } catch (e) {
      print('❌ SESSION SERVICE: Failed to clear session: ${e.toString()}');
      rethrow;
    }
  }
}
