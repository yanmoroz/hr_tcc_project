import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides DaData API credentials from environment variables
abstract class DaDataTokenProvider {
  /// DaData API secret key
  String? get secret;

  /// DaData API token
  String? get token;
}

/// Implementation that loads DaData credentials from .env file
class LocalDaDataTokenProvider implements DaDataTokenProvider {
  @override
  String? get secret => dotenv.env['DADATA_SECRET'];

  @override
  String? get token => dotenv.env['DADATA_TOKEN'];
}
