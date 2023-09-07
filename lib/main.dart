import 'package:flutter/material.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Landing Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String appsflyerInit = "Initializing...";
  String installConversionData = "",
      onAppOpenAttribution = "",
      onDeepLinking = ""; // Store the install conversion data

  @override
  void initState() {
    super.initState();
    yourCallingFunction();
  }

  void yourCallingFunction() async {
    await initAppsflyer();
  }

  Future<void> initAppsflyer() async {
    AppsflyerSdk appsflyerSdk;
    try {
      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "7VmuGPyWcLJzHqASnx5PF",
        appId: "7VmuGPyWcLJzHqASnx5PF",
        showDebug: false,
        timeToWaitForATTUserAuthorization: 15,
      );

      appsflyerSdk = AppsflyerSdk(options);

      appsflyerSdk.onInstallConversionData((res) {
        //ignore:avoid_print
        print('onInstallConversionData ${res.toString()}');
        setState(() {
          // Update the installConversionData with the received data
          installConversionData = 'Install Conversion Data: ${res.toString()}';
        });
      });

      appsflyerSdk.onAppOpenAttribution((res) {
        //ignore:avoid_print
        print('onAppOpenAttribution ${res.toString()}');
        setState(() {
          // Update the installConversionData with the received data
          onAppOpenAttribution = 'onAppOpenAttribution: ${res.toString()}';
        });
      });

      appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
        //ignore:avoid_print
        print(dp.status.toString());
        //ignore:avoid_print
        print(dp.deepLink?.toString());
        //ignore:avoid_print
        print("deep link value: ${dp.deepLink?.deepLinkValue}");
        setState(() {
          // Update the installConversionData with the received data
          onDeepLinking =
              'DeepLink Status: ${dp.status.toString()} DeepLink: ${dp.deepLink?.toString()} Deeplink Value: ${dp.deepLink?.deepLinkValue.toString()}';
        });
      });

      await appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );

      setState(() {
        appsflyerInit = "Initialization successful";
      });
    } catch (e) {
      setState(() {
        appsflyerInit = "Initialization error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Appsflyer Init Result:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SelectableText(
                        appsflyerInit,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      SelectableText(
                        installConversionData, // Display install conversion data here
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      SelectableText(
                        onAppOpenAttribution, // Display install conversion data here
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      SelectableText(
                        onDeepLinking, // Display install conversion data here
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}
