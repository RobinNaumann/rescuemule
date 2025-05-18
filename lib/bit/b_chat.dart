import 'dart:async';

import 'package:elbe/bit/bit/bit_control.dart';
import 'package:elbe/elbe.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as f;
import 'package:rescuemule/bit/b_messaging.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_user_service.dart';

MessageService messageService = MessageService();
UserService userService = UserService();


class _Data extends JsonModel{
  final List<Message> messages;
  _Data(this.messages);

  @override
  get map => {"map": messages};
}

class ChatBit extends MapMsgBitControl<_Data> {
  final String contact;
  StreamSubscription? _listener;

  static const builder = MapMsgBitBuilder<_Data, ChatBit>.make;
  ChatBit(this.contact) : super.worker((_) async => _Data(await messageService.getMessagesBetweenUsers(contact))){
    _listener = MessagingBit.msgStream.stream.listen((msg) async {
      //if(msg.receiver == await userService.loadUser() && msg.sender == contact){
      await Future.delayed(Duration(milliseconds: 200));
        reload(silent: true);
      //}
    });
  }

  addMsg(Message m)async {
    await messageService.saveMessage(m);
    reload(silent: true);
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }
}
