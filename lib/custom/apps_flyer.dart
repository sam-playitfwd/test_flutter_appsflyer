import 'package:appsflyer_sdk/appsflyer_sdk.dart';

Future<String> initAppsflyer() async {
  final StringBuffer logBuffer = StringBuffer();
  AppsflyerSdk appsflyerSdk;
  try {
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "7VmuGPyWcLJzHqASnx5PF",
        appId: "7VmuGPyWcLJzHqASnx5PF",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    appsflyerSdk = AppsflyerSdk(options);

    appsflyerSdk.onAppOpenAttribution((res) {
      logBuffer.writeln('onAppOpenAttribution ${res.toString()}');
      //ignore:avoid_print
      print('onAppOpenAttribution ${res.toString()}');
    });

    appsflyerSdk.onInstallConversionData((res) {
      logBuffer.writeln('onInstallConversionData ${res.toString()}');
      //ignore:avoid_print
      print('onInstallConversionData ${res.toString()}');
    });

    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      logBuffer.writeln('DP Status ${dp.status.toString()}');
      logBuffer.writeln('DP Link ${dp.deepLink?.toString()}');
      logBuffer.writeln('DP Value ${dp.deepLink?.deepLinkValue}');
      //ignore:avoid_print
      print(dp.status.toString());
      //ignore:avoid_print
      print(dp.deepLink?.toString());
      //ignore:avoid_print
      print("deep link value: ${dp.deepLink?.deepLinkValue}");
      switch (dp.status) {
        case Status.FOUND:
          {
            //ignore:avoid_print
            print(dp.deepLink?.toString());
            //ignore:avoid_print
            print("deep link value: ${dp.deepLink?.deepLinkValue}");

            break;
          }
        case Status.NOT_FOUND:
          {
            //ignore:avoid_print
            print("deep link not found");
            break;
          }
        case Status.ERROR:
          {
            //ignore:avoid_print
            print("deep link error: ${dp.error}");
            break;
          }
        case Status.PARSE_ERROR:
          {
            //ignore:avoid_print
            print("deep link status parsing error");
            break;
          }
      }
    });
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    return logBuffer.toString();
  } catch (e) {
    //ignore:avoid_print
    print('error occured ${e.toString()}');
    return "error";
  }
}
