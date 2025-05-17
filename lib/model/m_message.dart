
class Message {
  final int id;
  final String sender;
  final String receiver;
  final String message;
  final DateTime creationTime;
  

  Message({required this.id, required this.sender, required this.receiver, required this.message, required this.creationTime});

  static Message createMessage({required sender, required receiver,required message}){
    DateTime time = DateTime.now();
    int id = (sender+receiver+time.toString()).hashCode;
    return Message(
      id : id,
      sender: sender,
      receiver: receiver,
      message: message,
      creationTime: time
    );
  }

  Map<String, dynamic> toJson() => {
        'id' : id,
        'sender': sender,
        'receiver' : receiver,
        'message': message,
        'creationTime' : creationTime.toString()
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id : json['id'],
        sender: json['sender'],
        receiver: json['receiver'],
        message: json['message'],
        creationTime: DateTime.parse(json['creationTime'])
      );
}