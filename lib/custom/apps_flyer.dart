import 'package:appsflyer_sdk/appsflyer_sdk.dart';

Future initAppsflyer() async {
  AppsflyerSdk appsflyerSdk;
  try {
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "7VmuGPyWcLJzHqASnx5PF",
        appId: "7VmuGPyWcLJzHqASnx5PF",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15);
    appsflyerSdk = AppsflyerSdk(options);

    appsflyerSdk.onAppOpenAttribution((res) {
      //ignore:avoid_print
      print('onAppOpenAttribution ${res.toString()}');
    });

    appsflyerSdk.onInstallConversionData((res) {
      //ignore:avoid_print
      print('onInstallConversionData ${res.toString()}');
    });

    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
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
  } catch (e) {
    //ignore:avoid_print
    print('error occured ${e.toString()}');
  }
}
