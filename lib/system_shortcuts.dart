import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

/// You can use shortcuts like pressing home and back button programatically
/// by calling home() and back() functions respectively.
///
/// You can also control volume keys by calling volUp() and volDown()
/// to press volume Up button and volume Down button respectively.
///
/// You can change the orientation of your app by calling functions
/// orientLandscape() or orientPortrait() to turn the app into
/// landscape and portrait mode respectively.
///
/// You can toggle wifi and bluetooth as well using wifi() and bluetooth()
/// functions respectively

const MethodChannel _channel = MethodChannel('system_shortcuts');

/// Press home button programatically .
///
/// Implemetation :-
///
/// await SystemShortcuts.home();
Future<void> home() async => _channel.invokeMethod('home');

/// Press back button programatically .
///
/// Implemetation :-
///
/// await SystemShortcuts.back();
Future<void> back() async => _channel.invokeMethod('back');

/// Press Volume Down button programatically .
///
/// Implemetation :-
///
/// await SystemShortcuts.volDown();
Future<void> volDown() async => _channel.invokeMethod('volDown');

/// Press Volume Up button programatically .
///
/// Implemetation :-
///
/// await SystemShortcuts.volUp();
Future<void> volUp() async => _channel.invokeMethod('volUp');

/// Change app orientation to landscape mode
///
/// Implemetation :-
///
/// await SystemShortcuts.orientLandscape();
Future<void> orientLandscape() async =>
    _channel.invokeMethod('orientLandscape');

/// Change app orientation to Portrait mode
///
/// Implemetation :-
///
/// await SystemShortcuts.orientPortrait();
Future<void> orientPortrait() async => _channel.invokeMethod('orientPortrait');

/// Toggle Wifi.
///
/// If it is already turned on wifi() will turn it off
/// else it'll turn it on.
/// will always return false for Android Q
///
/// It will always return false for Android 10 (Q)
/// because Q doesn't allow apps to enable/disable Wi-Fi.
Future<bool?> wifi() async {
  if (Platform.isAndroid) {
    return _channel.invokeMethod<bool>('wifi');
  }

  return null;
}

/// Return true if the wifi is alreay turned on.
///
/// Return false if the wifi is turned off.
Future<bool?> get checkWifi async =>
    _channel.invokeMethod<bool>('checkWifi');

/// Display a settings dialog containing controls for Wi-Fi.
///
/// This action allows an application to present a user with a panel
/// for managing Wi-Fi settings without navigating to the full Android Settings app.
///
/// This method is only supported on Android 10 (Q) and later versions.
Future<void> openAndroidWifiSettingsPanel() async {
  if (Platform.isAndroid) {
    await _channel.invokeMethod<void>('openWifiSettingsPanel');
  }
}

/// Display a settings dialog containing a broader range of internet settings,
/// including Wi-Fi, mobile data, and airplane mode.
///
/// This method is only supported on Android 10 (Q) and later versions.
Future<void> openAndroidInternetSettingsPanel() async {
  if (Platform.isAndroid) {
    await _channel.invokeMethod<void>('openInternetSettingsPanel');
  }
}

/// Toggle bluetooth.
///
/// If it is already turned on bluetooth() will turn it off
/// else it'll turn it on
Future<bool?> bluetooth() async {
  if (Platform.isAndroid) {
    return _channel.invokeMethod<bool>('bluetooth');
  }

  return null;
}

/// Return true if the bluetooth is alreay turned on.
///
/// Return false if the bluetooth is turned off.
Future<bool?> get checkBluetooth async =>
    _channel.invokeMethod<bool>('checkBluetooth');
