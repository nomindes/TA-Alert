import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class AudioHandler {
  static StreamController<double>? _volumeController;

  static Future<void> startListening() async {
    _volumeController = StreamController<double>.broadcast();
    
    // JavaScriptを呼び出してマイクからの音声処理を開始
    js.context.callMethod('startAudioProcessing');

    // JavaScriptからのコールバックを設定
    js.context['updateVolume'] = (double volume) {
      _volumeController?.add(volume);
    };
  }

  static Future<void> stopListening() async {
    js.context.callMethod('stopAudioProcessing');
    await _volumeController?.close();
    _volumeController = null;
  }

  static Stream<double> get volumeStream {
    if (_volumeController == null) {
      throw Exception('Audio processing has not been started');
    }
    return _volumeController!.stream;
  }
}