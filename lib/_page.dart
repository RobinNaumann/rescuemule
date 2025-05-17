// Example: Advertising a BLE service

/*
//final serviceBattery = UUID.fromString("0000180F-0000-1000-8000-00805F9B34FB");
final aUid = UUID.fromString("00002A37-0000-1000-8000-10000000000A");
final bUid = UUID.fromString("00002A37-0000-1000-8000-10000000000B");

final a = CentralManager();
final p = Peripheral(uuid: bUid);

discover() async {
  await a.authorize();
  await a.startDiscovery(serviceUUIDs: [bUid]);
  a.discovered.listen(
    (dev) => print("found:" + dev.peripheral.uuid.toString()),
  );
  await Future.delayed(const Duration(seconds: 5));
  await a.stopDiscovery();
}

advertise() async {
  if (!runPlatform.isMacos) await pMan.authorize();

  await pMan.addService(
    GATTService(
      uuid: aUid,
      isPrimary: true,
      includedServices: [],
      characteristics: [
        GATTCharacteristic.mutable(
          uuid: bUid,
          properties: [
            GATTCharacteristicProperty.read,
            GATTCharacteristicProperty.write,
            GATTCharacteristicProperty.notify,
          ],

          permissions: [GATTCharacteristicPermission.read],
          descriptors: [
            /*GATTDescriptor.mutable(
              uuid: charUuid,
              permissions: [GATTCharacteristicPermission.read],
            ),*/
          ],
        ),
      ],
    ),
  );

  if (!runPlatform.isMacos) {
    pMan.connectionStateChanged.listen((state) {
      print("ON CONNECTION STATE CHANGED");
      print(state.state.name);
      print(state.central.uuid);
    });
  }

  pMan.characteristicNotifyStateChanged.listen((state) {
    print("ON CHARACTERISTIC NOTIFY STATE CHANGED");
    print(state.characteristic.uuid.toString());
  });

  pMan.characteristicReadRequested.listen((state) {
    print("ON CHARACTERISTIC READ REQUESTED");
    print(state.characteristic.uuid.toString());
    pMan.respondReadRequestWithValue(
      state.request,
      value: Uint8List.fromList([0x01, 0x02, 0x03, 0x04]),
    );
  });

  /*pMan.descriptorReadRequested.listen((state) {
    print("ON DESCRIPTOR READ REQUESTED");
    print(state.descriptor.uuid.toString());
    pMan.respondReadRequestWithValue(
      state.request,
      value: Uint8List.fromList([0x01, 0x02, 0x03, 0x04]),
    );
  });*/

  await pMan.startAdvertising(
    Advertisement(name: "DisasterMule", serviceUUIDs: [aUid]),
  );
}*/
