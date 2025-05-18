import 'dart:async';

import 'package:elbe/bit/bit/bit_control.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:rescuemule/bit/b_messaging.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_user_service.dart';

UserService userService = UserService();

class _Data{
  final List<String> contacts;
  final String? user;
  _Data(this.contacts, this.user);
}

class ExampleBit extends MapMsgBitControl<_Data> {
  StreamSubscription? _listener;

  static const builder = MapMsgBitBuilder<_Data, ExampleBit>.make;
  ExampleBit() : super.worker((_) async => _Data(await userService.loadContacts(), await userService.loadUser())){
    _listener = MessagingBit.msgStream.stream.listen((msg) async {
      if(msg.receiver == await userService.loadUser()){
        addContact(msg.sender);
      }
    });
  }

  addContact(String contact) async{
    await userService.saveContact(contact);
    reload(silent: true);
  }

  setUsername(String user) async{
    await userService.saveUser(user);
    reload(silent: true);
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }
}
