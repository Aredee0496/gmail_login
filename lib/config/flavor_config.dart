class FlavorConfig {
  final String env;
  final String urlApiFamily;
  final String urlApiApp;
  final String urlOAuth;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.env,
    required this.urlApiFamily,
    required this.urlApiApp,
    required this.urlOAuth,
  });

  static void init({required String env}) {
    _instance = FlavorConfig._internal(
      env: env,
      urlApiFamily: "${env}apifamily.sritranggroup.com",
      urlApiApp: "${env}apissj.sritranggroup.com",
      urlOAuth: "${env}oauth.sritranggroup.com",
    );
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception("FlavorConfig not initialized!");
    }
    return _instance!;
  }
}
