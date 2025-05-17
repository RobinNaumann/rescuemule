import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:flutter/material.dart' as material;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => material.Scaffold(
    appBar: AppBar(title: const Text('topbar hier!')),
    bottomNavigationBar: material.BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Container(height: 50.0),
    ),
    body: Padded.all(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children:
            [
              Button.minor(
                label: "advertise",
                onTap: () async {
                  await BluetoothService.i.advertise();
                  context.showToast("started to advertise");
                  //await advertise();
                },
              ),
              Button.minor(
                label: "scan",
                onTap: () async {
                  context.showToast("TODO: discover");
                  //await discover();
                },
              ),
              Mule(name: "test"),
            ].spaced(),
      ),
    ),
  );
}

class Mule extends StatelessWidget {
  final String name;
  const Mule({super.key, this.name = "Unknown Mule"});

  @override
  Widget build(BuildContext context) {
    return Text("Hello I'm the mule $name");
  }
}
