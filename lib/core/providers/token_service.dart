import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petcare/core/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(prefs: ref.read(sharedPrefsProvider));
});

class TokenService {
  static const String _tokenKey = 'auth_token';
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  TokenService({
    required SharedPreferences prefs,
    FlutterSecureStorage? secureStorage,
  }) : _prefs = prefs,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    print('💾 TOKEN SERVICE: Saving token (${token.length} characters)');

    try {
      await Future.wait([
        _prefs.setString(_tokenKey, token),
        _secureStorage.write(key: _tokenKey, value: token),
      ]);
      print(
        '✅ TOKEN SERVICE: Token saved successfully to both SharedPreferences and SecureStorage',
      );
    } catch (e) {
      print('❌ TOKEN SERVICE: Failed to save token: ${e.toString()}');
      rethrow;
    }
  }

  // Get token
  Future<String?> getToken() async {
    print('🔍 TOKEN SERVICE: Retrieving token');

    final inMemoryToken = _prefs.getString(_tokenKey);
    if (inMemoryToken != null && inMemoryToken.isNotEmpty) {
      print(
        '✅ TOKEN SERVICE: Found token in SharedPreferences (${inMemoryToken.length} chars)',
      );
      return inMemoryToken;
    }

    try {
      final secureToken = await _secureStorage.read(key: _tokenKey);
      if (secureToken != null && secureToken.isNotEmpty) {
        print(
          '✅ TOKEN SERVICE: Found token in SecureStorage (${secureToken.length} chars)',
        );
        // Cache it in memory for future use
        await _prefs.setString(_tokenKey, secureToken);
        return secureToken;
      }
    } catch (e) {
      print(
        '⚠️ TOKEN SERVICE: Error reading from SecureStorage: ${e.toString()}',
      );
    }

    print('❌ TOKEN SERVICE: No token found');
    return null;
  }

  // Remove token (for logout)
  Future<void> removeToken() async {
    print('🗑️ TOKEN SERVICE: Removing token');

    try {
      await Future.wait([
        _prefs.remove(_tokenKey),
        _secureStorage.delete(key: _tokenKey),
      ]);
      print('✅ TOKEN SERVICE: Token removed successfully from both storages');
    } catch (e) {
      print('❌ TOKEN SERVICE: Failed to remove token: ${e.toString()}');
      rethrow;
    }
  }
}
