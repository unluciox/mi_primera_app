import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatBotPage extends StatelessWidget {

  void openChat() async {
    try {
      dynamic conversationObject = {
        'appId': '32896fb7cdc2e77b5486c94ff18e6f9bc'
      };

      KommunicateFlutterPlugin.buildConversation(conversationObject);
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot Universidad"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Abrir Chatbot"),
          onPressed: openChat,
        ),
      ),
    );
  }
}