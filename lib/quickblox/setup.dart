import 'package:flutter/services.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

String appId = "98084";
String authKey = "sTGOtGzdQdZAheA";
String authSecret = "EUhKnaMBABc3wW9";
String accountKey = "4S_NxqbLTsC8gYcSYxPh";

void initQuickBlox() async {
  try {
    await QB.settings.init(appId, authKey, authSecret, accountKey);
  } on PlatformException catch (e) {
    // Some error occurred, look at the exception message for more details
  }
}
