import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthTokenProvider {
  String? get token;
  String? get refreshToken;
  Future<void> setToken(String? token);
  Future<void> setRefreshToken(String? refreshToken);
  Future<void> clearToken();
  Future<bool> hasToken();
}

/// Development-only provider that reads token from .env file
/// Should not be used in production
class LocalAuthTokenProvider implements AuthTokenProvider {
  @override
  String? get token => dotenv.env['ACCESS_TOKEN'];

  @override
  String? get refreshToken => null;

  @override
  Future<void> setToken(String? token) async {
    // Not supported for local provider
    throw UnsupportedError('LocalAuthTokenProvider does not support setToken');
  }

  @override
  Future<void> setRefreshToken(String? refreshToken) async {
    // Not supported for local provider
    throw UnsupportedError(
      'LocalAuthTokenProvider does not support setRefreshToken',
    );
  }

  @override
  Future<void> clearToken() async {
    // Not supported for local provider
    throw UnsupportedError(
      'LocalAuthTokenProvider does not support clearToken',
    );
  }

  @override
  Future<bool> hasToken() async {
    return token != null;
  }
}

/// Production provider that stores tokens securely using FlutterSecureStorage
class SecureAuthTokenProvider implements AuthTokenProvider {
  final FlutterSecureStorage _secureStorage;
  String? _cachedToken; // In-memory cache for performance
  String? _cachedRefreshToken; // In-memory cache for refresh token

  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  SecureAuthTokenProvider(this._secureStorage);

  @override
  String? get token => _cachedToken;

  @override
  String? get refreshToken => _cachedRefreshToken;

  @override
  Future<void> setToken(String? token) async {
    _cachedToken = token;
    if (token != null) {
      await _secureStorage.write(key: _tokenKey, value: token);
    } else {
      await _secureStorage.delete(key: _tokenKey);
    }
  }

  @override
  Future<void> setRefreshToken(String? refreshToken) async {
    _cachedRefreshToken = refreshToken;
    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _secureStorage.delete(key: _refreshTokenKey);
    }
  }

  @override
  Future<void> clearToken() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  @override
  Future<bool> hasToken() async {
    if (_cachedToken != null) return true;
    _cachedToken = await _secureStorage.read(key: _tokenKey);
    return _cachedToken != null;
  }

  /// Initialize the provider by loading cached tokens from secure storage
  Future<void> initialize() async {
    _cachedToken = await _secureStorage.read(key: _tokenKey);
    _cachedRefreshToken = await _secureStorage.read(key: _refreshTokenKey);
  }
}
