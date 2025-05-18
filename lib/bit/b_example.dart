import 'package:elbe/bit/bit/bit_control.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:rescuemule/service/s_user_service.dart';

UserService userService = UserService();

class _Data{
  final List<String> contacts;
  final String? user;
  _Data(this.contacts, this.user);
}

class ExampleBit extends MapMsgBitControl<_Data> {
  static const builder = MapMsgBitBuilder<_Data, ExampleBit>.make;
  ExampleBit() : super.worker((_) async => _Data(await userService.loadContacts(), await userService.loadUser()));

  addContact(String contact) async{
    await userService.saveContact(contact);
    reload(silent: true);
  }

  setUsername(String user) async{
    await userService.saveUser(user);
    reload(silent: true);
  }
}
