import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:prova_flutter/exandableFloatingActionButton.dart';
import 'package:prova_flutter/switch.dart';

import 'cameraPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool nfcEnabled = false;
  _setNfcEnabledValue(value) {
    setState(() {
      nfcEnabled = value;
    });
  }

  void takePicture() async {
    await availableCameras().then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
  }

  void nfcRead() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable && nfcEnabled) {
      Fluttertoast.showToast(
        msg: "Lettura NFC abilitata",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
      );
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
        Fluttertoast.showToast(
          msg: tag.data.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        NfcManager.instance.stopSession();
        _setNfcEnabledValue(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(nfcEnabled ? 'Enabled' : 'Disabled'),
            SwitchNFC(
              initialValue: nfcEnabled,
              onChanged: _setNfcEnabledValue,
            )
            // SwitchExample(text: "NFC", onChanged: _setNfcEnabledValue),
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(distance: 120, children: [
        FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: takePicture,
          tooltip: 'Photo',
          child: const Icon(Icons.insert_photo),
        ),
        FloatingActionButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(color: Colors.white)),
            onPressed: takePicture,
            tooltip: 'Photo',
            child: const Row(
                children: <Widget>[Icon(Icons.insert_photo), Text("Photo")])),
        FloatingActionButton(
          onPressed: nfcRead,
          tooltip: 'NFC',
          child: const Icon(Icons.nfc),
        ),
      ]),

      // FloatingActionButton(
      //   onPressed: takePicture,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
    );
  }
}
