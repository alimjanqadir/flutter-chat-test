import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

final kiOSTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);
final kDefaultTheme =
    ThemeData(primaryColor: Colors.purple, accentColor: Colors.orange[400]);
void main() {
  runApp(ChatApp());
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textFieldController = TextEditingController();
  final _focusNode = FocusNode();
  var _isComposing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Chat Demo"),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0),
        body: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length)),
            Divider(height: 1.0),
            Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextField())
          ],
        ));
  }

  @override
  void dispose() {
    for (var message in _messages) message.animationController.dispose();
    super.dispose();
  }

  void _handleSubmit(String value) {
    _textFieldController.clear();
    ChatMessage message = ChatMessage(
        text: value,
        animationController: AnimationController(
            duration: const Duration(milliseconds: 700), vsync: this));
    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget _buildTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
                controller: _textFieldController,
                onChanged: (value) =>
                    setState(() => {_isComposing = value.length > 0}),
                onSubmitted: _isComposing ? _handleSubmit : null,
                decoration:
                    InputDecoration.collapsed(hintText: "Enter your message!"),
                focusNode: _focusNode),
          ),
          IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text("Send"),
                      onPressed: _isComposing
                          ? () => _handleSubmit(_textFieldController.text)
                          : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmit(_textFieldController.text)
                          : null,
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kiOSTheme
            : kDefaultTheme,
        home: ChatPage());
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final _name = "Al";
  final text;
  final animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(child: Text(_name[0]))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme.of(context).textTheme.headline6),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child:
                      Text(text, style: Theme.of(context).textTheme.bodyText2),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
