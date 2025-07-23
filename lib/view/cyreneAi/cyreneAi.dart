import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:erebrus_app/config/common.dart';
import 'package:erebrus_app/config/strings.dart';
import 'package:erebrus_app/config/responsive.dart';
import 'package:erebrus_app/view/cyreneAi/agentModel.dart';
import 'package:erebrus_app/view/settings/SettingPage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:link_text/link_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CyreneAi extends StatefulWidget {
  final Agent data;
  const CyreneAi({super.key, required this.data});
  @override
  _CyreneAiState createState() => _CyreneAiState();
}

class _CyreneAiState extends State<CyreneAi> {
  final List<Map<String, String>> messages = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  // final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;

  @override
  void dispose() {
    _speech.stop();
    // _flutterTts.stop();p
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendToCyreneAI(String query) async {
    setState(() {
      messages.add({"role": "user", "content": query});
      messages.add({"role": "assistant", "content": "Thinking..."});
    });

    final url =
        Uri.parse("https://${widget.data.domain}/${widget.data.id}/message");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "text": query,
      "userId": "${box!.get("uid") ?? ""}",
      "userName": "${box!.get("name") ?? ""}"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data[0]["text"];
        setState(() {
          messages.removeLast();
          messages.add({"role": "assistant", "content": reply});
        });
      } else {
        setState(() {
          messages
              .add({"role": "assistant", "content": "Error: ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "assistant", "content": "Error: $e"});
      });
    }
  }

  void _startListening() async {
    await Permission.microphone.request().then((a) {
      if (a.isDenied) {
        Fluttertoast.showToast(msg: "Allow Microphone Permission");
        return;
      }
    });
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "notListening") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
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
            _sendToCyreneAI(recognizedText);
          }
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 8),
        cancelOnError: true,
      );
    }
  }

  Widget _buildMessageBubble(String message, bool isUser) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinkText(
                message,
                textStyle:
                    TextStyle(color: isUser ? Colors.white : Colors.black),
                linkStyle: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ),
        if (!isUser)
          IconButton(
            icon: Icon(
              Icons.flag,
              color: Colors.red,
              size: 20,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Report'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.report),
                          title: Text('Spam'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle spam report
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.block),
                          title: Text('Abuse'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle abuse report
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('Other'),
                          onTap: () {
                            Navigator.pop(context);
                            // Handle other report
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                },
              );
            },
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Your Assistant", style: TextStyle(fontSize: Responsive.scaleText(context, 20))),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const SettingPage())!.whenComplete(
                () {
                  setState(() {});
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.all(Responsive.scaleWidth(context, 8.0)),
              child: Icon(Icons.settings, size: Responsive.scaleWidth(context, 24)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (messages.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: CachedNetworkImage(
                      imageUrl: "https://ipfs.io/ipfs/" + widget.data.avatarImg.toString(),
                      height: Responsive.scaleHeight(context, Get.height * .25),
                      errorWidget: (context, url, error) => Image.asset(
                          "assets/Erebrus_AI_Cyrene.png",
                          height: Responsive.scaleHeight(context, Get.height * .25)),
                    ),
                  ),
                  SizedBox(height: Responsive.scaleHeight(context, 15)),
                  Text(
                    widget.data.name!.toTitleCase(),
                    style: TextStyle(color: Colors.grey, fontSize: Responsive.scaleText(context, 26)),
                  ),
                ],
              ),
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
          if (messages.isNotEmpty)
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
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: InkWell(
                        onTap: _isListening ? null : _startListening,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundColor:
                                _isListening ? Colors.grey : Colors.blue,
                            radius: 14,
                            child:
                                Icon(Icons.mic, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      _sendToCyreneAI(value);
                      _textController.clear();
                    },
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      if (_textController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Type Something");
                        return;
                      }
                      _sendToCyreneAI(_textController.text);
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
