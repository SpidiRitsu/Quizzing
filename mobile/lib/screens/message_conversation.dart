import 'package:Quizzing/models/message.dart';
import 'package:Quizzing/models/user.dart';
import 'package:Quizzing/providers/auth.dart';
import 'package:Quizzing/providers/messages.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MessageConversationScreen extends StatefulWidget {
  final User sender;
  MessageConversationScreen(this.sender, {Key key}) : super(key: key);

  @override
  _MessageConversationScreenState createState() =>
      _MessageConversationScreenState();
}

class _MessageConversationScreenState extends State<MessageConversationScreen> {
  var _isLoading = true;
  List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() {
      _isLoading = true;
    });

    int userId = (await Auth.getUserData())['userId'];

    Provider.of<Messages>(context, listen: false).fetchMessages().then((_) {
      var newMessages = Provider.of<Messages>(context, listen: false)
          .getConversation(userId, widget.sender.id);
      messages = _convertMessages(newMessages);

      setState(() {
        _isLoading = false;
      });
    });
  }

  List<ChatMessage> _convertMessages(List<Message> messages) {
    List<ChatMessage> newMessages = [];
    messages.forEach((message) {
      newMessages.add(ChatMessage(
        user: message.sender.id == widget.sender.id
            ? ChatUser(
                uid: message.sender.id.toString(),
                name: message.sender.name ?? message.sender.username,
              )
            : ChatUser(
                uid: Provider.of<Auth>(context, listen: false)
                    .user
                    .id
                    .toString(),
                name: Provider.of<Auth>(context, listen: false).user.name ??
                    Provider.of<Auth>(context, listen: false).user.username,
                containerColor: Theme.of(context).primaryColor,
                color: Colors.white,
              ),
        text: message.message,
        createdAt: message.dateSent,
      ));
    });
    return newMessages;
  }

  onSend(ChatMessage message) async {
    messages.add(message);

    int sender = int.parse(message.user?.uid);

    int fromUser = sender;
    int toUser = widget.sender.id;
    var apiMessage = {
      'message': message.text,
      'dateSent': message.createdAt.toUtc().toIso8601String(),
      'fromUser': fromUser,
      'toUser': toUser
    };

    Provider.of<Messages>(context, listen: false).sendMessage(apiMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.sender.name ?? widget.sender.username}',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : DashChat(
              user: ChatUser(
                uid: Provider.of<Auth>(context).user.id.toString(),
                name: Provider.of<Auth>(context).user.username,
              ),
              showUserAvatar: true,
              messages: messages,
              onSend: onSend,
              dateFormat: DateFormat('dd-MMM-yyy'),
              inputMaxLines: 5,
              messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
              inputTextStyle: TextStyle(fontSize: 16.0),
              inputDecoration:
                  InputDecoration.collapsed(hintText: "Add message here..."),
              scrollToBottom: false,
            ),
    );
  }
}
