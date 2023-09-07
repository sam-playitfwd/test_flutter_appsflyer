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
  late AppsflyerSdk appsflyerSdk;
  String appsflyerInit = "Initializing...";
  String installConversionData = "",
      onAppOpenAttribution = "",
      onDeepLinking = "";
  String defaultEventName = "Purchase";
  String defaultEventValueString =
      "{af_content_id: id123, af_currency: USD, af_revenue: 1,}";
  String eventName = "";
  String eventValueString = "";

  @override
  void initState() {
    super.initState();
    initialAppsFlyerEvent();
    yourCallingFunction();
  }

  void initialAppsFlyerEvent() {
    setState(() {
      eventName = defaultEventName;
      eventValueString = defaultEventValueString;
    });
  }

  void onChangeEvent(String value) {
    setState(() {
      eventName = value;
    });
  }

  void onChangeEventValues(String value) {
    eventValueString = value;
  }

  void yourCallingFunction() async {
    await initAppsflyer();
  }

  Future<void> initAppsflyer() async {
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

  void onShowDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(eventName),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void logEvent() async {
    //ignore:avoid_print

    String inputString = eventValueString.replaceAll(RegExp(r',\s*}'), '}');

    // Remove the leading and trailing curly braces
    inputString = inputString.substring(1, inputString.length - 1);

    // Split the string by commas to get individual key-value pairs
    List<String> keyValuePairs = inputString.split(', ');

    // Create a map to store the key-value pairs
    Map<String, dynamic> resultMap = {};

    // Iterate through the key-value pairs and add them to the map
    for (String keyValue in keyValuePairs) {
      List<String> parts = keyValue.split(': ');
      if (parts.length == 2) {
        String key = parts[0].trim();
        String value = parts[1].trim();
        resultMap[key] = value;
      }
    }

    //ignore:avoid_print
    print('resultMap $resultMap');

    await appsflyerSdk.logEvent(eventName, resultMap).then((value) {
      //ignore:avoid_print
      onShowDialog(
          "logging event succesful ${value.toString()} parameters:$resultMap");
    }).catchError((onError) {
      onShowDialog('${onError.toString()} parameters:$resultMap');
    });
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            controller: TextEditingController(text: eventName),
                            onChanged: onChangeEvent,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Event Name"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller:
                                TextEditingController(text: eventValueString),
                            onChanged: onChangeEventValues,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Event Name"),
                            ),
                            maxLines: 6,
                          ),
                          Center(
                            child: Row(
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: initialAppsFlyerEvent,
                                  child: const Text("Reset"),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: logEvent,
                                  child: const Text("Send purchase event"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}
