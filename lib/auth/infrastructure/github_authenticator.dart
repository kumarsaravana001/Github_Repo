import 'package:flutter/services.dart';
import 'package:github_repo/auth/infrastructure/credential_storage/credential_storage.dart';
import 'package:oauth2/oauth2.dart';

class GithubAuthenticator {
  final CredentialStorage _credentialStorage;

  GithubAuthenticator(this._credentialStorage);
  static const clientId = '6184856f74132e0376d4';
  static const clientSecret = '37876444594bf48a5cb4a641896815f797d63b9e';
  static const scopes = ['read:user', 'repo'];
  static final authorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:3000/callback');

  Future<Credentials?> getSignedInCredentials() async {
    try {
      final storedCredentials = await _credentialStorage.read();
      if (storedCredentials != null) {
        if (storedCredentials.canRefresh && storedCredentials.isExpired) {
          //todo: refresh
        }
      }
      return storedCredentials;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> isSignedIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
      clientId,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
    );
  }
}
