// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';

enum MicrophonePermissionStatus {
  granted,
  denied,
  prompt,
  notSupported
}

class MicrophonePermissionsHandler {
  Future<bool> get isGranted async {
    if (!_isBrowserSupported()) {
      return false;
    }

    try {
      final devices = await html.window.navigator.mediaDevices?.enumerateDevices();
      final hasMicrophone = devices?.any((device) => device.kind == 'audioinput') ?? false;
      if (!hasMicrophone) {
        return false;
      }

      final status = await _getPermissionStatus();
      return status == MicrophonePermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking microphone permission: $e');
      }
      return false;
    }
  }

  Future<MicrophonePermissionStatus> request() async {
    if (!_isBrowserSupported()) {
      return MicrophonePermissionStatus.notSupported;
    }

    try {
      await html.window.navigator.mediaDevices?.getUserMedia({'audio': true});
      return MicrophonePermissionStatus.granted;
    } catch (e) {
      if (e is html.DomException) {
        if (e.name == 'NotAllowedError') {
          return MicrophonePermissionStatus.denied;
        } else if (e.name == 'NotFoundError') {
          return MicrophonePermissionStatus.notSupported;
        }
      }
      if (kDebugMode) {
        print('Error requesting microphone permission: $e');
      }
      return MicrophonePermissionStatus.denied;
    }
  }

  Future<MicrophonePermissionStatus> _getPermissionStatus() async {
    try {
      final permissionStatus = await html.window.navigator.permissions?.query({'name': 'microphone'});
      switch (permissionStatus?.state) {
        case 'granted':
          return MicrophonePermissionStatus.granted;
        case 'denied':
          return MicrophonePermissionStatus.denied;
        case 'prompt':
          return MicrophonePermissionStatus.prompt;
        default:
          return MicrophonePermissionStatus.notSupported;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting permission status: $e');
      }
      return MicrophonePermissionStatus.notSupported;
    }
  }

  bool _isBrowserSupported() {
    return html.window.navigator.mediaDevices != null;
  }
}