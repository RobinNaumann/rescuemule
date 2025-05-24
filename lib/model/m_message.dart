import 'dart:typed_data';

import 'package:bson/bson.dart';
import 'package:elbe/elbe.dart';

// a 8 byte int
typedef DeviceId = String;

typedef TextMessage = Message<String>;

class Hop extends JsonModel {
  final DeviceId device;
  final String connectionType;

  Hop({required this.device, required this.connectionType});

  Hop.ble(DeviceId device) : this(device: device, connectionType: 'ble');
  Hop.wifi(DeviceId device) : this(device: device, connectionType: 'wifi');
  Hop.relay(DeviceId device) : this(device: device, connectionType: 'relay');

  @override
  get map => {'device': device, 'type': connectionType};

  String asString() => '${connectionType}_$device';
  factory Hop.fromString(String str) {
    final first_ = str.indexOf('_');
    if (first_ == -1) throw ArgumentError('Invalid hop format: $str');

    return Hop(
      device: str.substring(first_ + 1),
      connectionType: str.substring(0, first_),
    );
  }
}

class Message<T> extends JsonModel {
  final String type;
  final DeviceId sender;
  final DeviceId receiver;
  final T message;
  final UnixMs timestamp;
  final List<Hop> hops;

  String get id => [type, sender, receiver].join('-').hashCode.toString();

  const Message({
    required this.type,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    this.hops = const [],
  });

  factory Message.create({
    required String type,
    required sender,
    required receiver,
    required message,
  }) => Message(
    type: type,
    sender: sender,
    receiver: receiver,
    message: message,
    timestamp: DateTime.now().asUnixMs,
    hops: [],
  );

  @override
  get map => {
    'type': type,
    'sender': sender,
    'receiver': receiver,
    'message': message,
    'timestamp': timestamp,
    'hops': hops,
  };

  factory Message.fromPacket(Uint8List packet) {
    final map = BsonCodec.deserialize(BsonBinary.from(packet));
    return Message(
      type: map.asCast("mt"),
      sender: map.asCast("s"),
      receiver: map.asCast("r"),
      message: map.asCast("m"),
      timestamp: UnixMs(int.parse(map['t'].toString())),
      hops: map.maybeCastList<String>("h")?.map(Hop.fromString).toList() ?? [],
    );
  }

  Uint8List asPacket() =>
      BsonCodec.serialize({
        'mt': type,
        's': sender,
        'r': receiver,
        'm': message,
        't': timestamp,
        'h': hops,
      }).byteList;

  Message copyWith({
    String? type,
    DeviceId? sender,
    DeviceId? receiver,
    String? message,
    UnixMs? timestamp,
    List<Hop>? hops,
  }) {
    return Message(
      type: type ?? this.type,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      hops: hops ?? this.hops,
    );
  }

  Message withHop(Hop hop) => copyWith(hops: [...this.hops, hop]);
}
