import 'dart:convert';

import 'package:erebrus_app/view/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceChatBot extends StatefulWidget {
  @override
  _VoiceChatBotState createState() => _VoiceChatBotState();
}

final List<Map<String, String>> messages = [];

class _VoiceChatBotState extends State<VoiceChatBot> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  String _apiKey = dotenv.get("OPENAI_CHATGPT_TOKEN");

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendToOpenAI(String query) async {
    setState(() {
      messages.add({"role": "user", "content": query});
    });

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_apiKey",
    };
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": messages
          .map((m) => {"role": m["role"], "content": m["content"]})
          .toList(),
      "max_tokens": 150,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];
        setState(() {
          messages
              .add({"role": "assistant", "content": reply}); // Use "assistant"
        });
        // _speak(reply);
      } else {
        setState(() {
          messages.add({
            "role": "assistant",
            "content": "Error: ${response.body}"
          }); // Use "assistant"
        });
      }
    } catch (e) {
      setState(() {
        messages.add(
            {"role": "assistant", "content": "Error: $e"}); // Use "assistant"
      });
    }
  }

  Future<void> _speak(String text) async {
    // await _flutterTts.setLanguage("en-US");
    // await _flutterTts.setSpeechRate(0.5);
    // await _flutterTts.speak(text);
  }

  void _startListening() async {
    // Initialize Speech-to-Text
    await Permission.microphone.request().then((a) {
      if (a.isDenied) {
        Fluttertoast.showToast(msg: "Allow Microphone Permission");
        return;
      }
    });
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Speech status: $status");
        if (status == "notListening") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print("Speech error: $error");
        setState(() => _isListening = false);
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String recognizedText = result.recognizedWords;
            setState(() {
              _isListening = false;
              _textController.text = recognizedText;
            });
            _sendToOpenAI(recognizedText);
          }
        },
        listenFor: Duration(seconds: 10), // Stop listening after 10 seconds
        pauseFor: Duration(seconds: 8), // Pause detection timeout
        cancelOnError: true, // Cancel on error
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Widget _buildMessageBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Your Assistant",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const SettingPage());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (messages.isEmpty)
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/Erebrus_AI_Cyrene.png",
                  height: Get.height * .3,
                ),
              ),
            ),
          if (messages.isEmpty)
            Text(
              "Cyrene",
              style: TextStyle(color: Colors.grey, fontSize: 26),
            ),
          if (messages.isNotEmpty)
            Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Start New Chat"),
                trailing: Icon(Icons.edit_note_outlined),
                dense: true,
                onTap: () {
                  messages.clear();
                  setState(() {});
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return _buildMessageBubble(
                    message["content"]!, message["role"] == "user");
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: InkWell(
                        onTap: _isListening ? null : _startListening,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor:
                                _isListening ? Colors.grey : Colors.blue,
                            radius: 14,
                            child: Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendToOpenAI(value);
                      _textController.clear();
                    },
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      _sendToOpenAI(_textController.text);
                      _textController.clear();
                    },
                    child: Icon(Icons.send, size: 22)),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
