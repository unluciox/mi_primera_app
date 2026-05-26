import 'package:flutter/material.dart';
import 'chatbot_logic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const UniversityChatbot());
}

class UniversityChatbot extends StatelessWidget {
  const UniversityChatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();

    messages.add({
      "sender": "bot",
      "text": "¡Hola! 👋\nPuedo ayudarte con dudas sobre el proceso de inscripción al Tecnológico de Mérida.\n\nPuedes preguntarme sobre:\n• Carreras\n• Proceso de inscripción\n• Requisitos\n• Fechas importantes"
    });
  }

  void sendMessage() {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": text});
    });

    controller.clear();

    scrollToBottom();

    String response = ChatbotLogic.getResponse(text);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add({"sender": "bot", "text": response});
      });scrollToBottom();
    });
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget messageBubble(String text, bool isUser) {

    bool isImage = text.startsWith("IMAGE:");
    bool isVideo = text.startsWith("VIDEO:");
    bool isAudio = text.startsWith("AUDIO:");

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: isImage
            ? Image.asset(
                text.replaceFirst("IMAGE:", ""),
                width: 250,
              )
            : isVideo
                ? VideoWidget(
                    text.replaceFirst("VIDEO:", ""),
                  )
                : isAudio
                    ? AudioWidget(
                        text.replaceFirst("AUDIO:", ""),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dudas sobre el proceso de inscripción"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {

                bool isUser = messages[index]["sender"] == "user";

                return messageBubble(
                  messages[index]["text"]!,
                  isUser,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask about inscriptions...",
                    ),
                    onSubmitted: (value) {
                      sendMessage();
                    }
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
class VideoWidget extends StatefulWidget {
  final String path;

  const VideoWidget(this.path, {super.key});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {

  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();

    player = Player();
    controller = VideoController(player);

    player.open(Media(widget.path));
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        SizedBox(
          width: 250,
          height: 150,
          child: Video(controller: controller),
        ),

        Row(
          children: [

            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                player.play();
              },
            ),

            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                player.pause();
              },
            )

          ],
        )

      ],
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
class AudioWidget extends StatefulWidget {

  final String path;

  const AudioWidget(this.path, {super.key});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {

  final AudioPlayer player = AudioPlayer();
  bool playing = false;

  void toggleAudio() async {

    if (playing) {
      await player.pause();
    } else {
      await player.play(AssetSource(widget.path.replaceFirst("assets/", "")));
    }

    setState(() {
      playing = !playing;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        IconButton(
          icon: Icon(
            playing ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: toggleAudio,
        ),

        const Text("Reproducir audio")

      ],
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
