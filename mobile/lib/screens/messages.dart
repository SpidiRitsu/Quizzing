import 'package:Quizzing/models/user_message.dart';
import 'package:Quizzing/providers/messages.dart';
import 'package:Quizzing/screens/message_conversation.dart';
import 'package:Quizzing/widgets/main_drawer.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  static const route = '/messages';

  const MessagesScreen({Key key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Messages>(context, listen: false).fetchMessages().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Messages>(context, listen: false).fetchMessages().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void createMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      // backgroundColor: Color(0xFF9A48D0),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        TextFormField(
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Username'),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a value.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                // Provider.of<Quizzes>(context, listen: false)
                                //     .updateQuestion(
                                //         questionId,
                                //         title.split(' ').join(''),
                                //         controller.text);
                                Provider.of<Messages>(context, listen: false)
                                    .createMessage(controller.text);
                              }
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text(
                              'Create conversation',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
        onPressed: () {
          createMessage();
        },
      ),
      // backgroundColor: Theme.of(context).primaryColor,
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('messages').tr(),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      ),
      body: Consumer<Messages>(
        builder: (context, messages, _) => _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                child: Container(
                  color: Colors.white,
                  child: messages.userMessages.length == 0
                      ? Center(
                          child: Text('no_msg_to_show').tr(),
                        )
                      : ListView.builder(
                          itemCount: messages.userMessages.length,
                          itemBuilder: (context, index) {
                            final UserMessage message =
                                messages.userMessages[index];

                            return ListTile(
                              // leading: Icon(Icons.account_circle),
                              leading: Container(
                                width: 40,
                                // height: 48,
                                child: AvatarContainer(
                                  user: ChatUser(
                                    name: message.sender.name ??
                                        message.sender.username,
                                  ),
                                ),
                              ),
                              title: Text(message.sender.name ??
                                  message.sender.username),
                              subtitle: Text(
                                message.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MessageConversationScreen(
                                      message.sender,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
      ),
    );
  }
}
