import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AuthTokenProvider {
  String? get token;
}

class LocalAuthTokenProvider implements AuthTokenProvider {
  @override
  String? get token => dotenv.env['ACCESS_TOKEN'];
}
