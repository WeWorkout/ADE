
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<SendPort> initIsolate() async {
  Completer<SendPort> completer = Completer<SendPort>();
  ReceivePort isolateToMain = ReceivePort();

  isolateToMain.listen((message) {
    if(message is SendPort) {
      SendPort mainToIsolate = message;
      completer.complete(mainToIsolate);
    } else {
      print("[isolateToMain] $message");
    }
  });

  Isolate isolate = await Isolate.spawn(_isolate, isolateToMain.sendPort);
  return completer.future;
}

_isolate(SendPort isolateToMain) {
  ReceivePort mainToIsolate = ReceivePort();
  isolateToMain.send(mainToIsolate.sendPort);
  
  mainToIsolate.listen((message) {
    print('[mainToIsolate] $message');
    exit(0);
  });

  isolateToMain.send("This is from my isolate!");
}

main() async {
  SendPort mainToIsolate = await initIsolate();
  mainToIsolate.send(['hello', 'world']);
}