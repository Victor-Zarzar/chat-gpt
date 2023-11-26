// ignore_for_file: unused_field, unused_element, non_constant_identifier_names
import 'package:chat_gpt/core/app_theme.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/repositories/chat_gpt_repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatGPTScreen extends StatefulWidget {
  const ChatGPTScreen({Key? key}) : super(key: key);

  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final _inputCtrl = TextEditingController();
  final _repository = ChatGPTRepository(Dio());
  final _messages = <ChatModel>[];
  final _scrollCtrl = ScrollController();

  Future<void> _sendMessage() async {
    if (_inputCtrl.text.isNotEmpty) {
      final prompt = _inputCtrl.text;

      setState(() {
        _messages.add(ChatModel(
          message: prompt,
          messageFrom: MessageFrom.me,
        ));

        _inputCtrl.text = '';

        _scrollDown();
      });

      final chatResponse = await _repository.promptMessage(prompt);

      setState(() {
        _messages.add(ChatModel(
          message: chatResponse,
          messageFrom: MessageFrom.bot,
        ));

        _scrollDown();
      });
    }
  }

  void _scrollDown() {
    Future.delayed(const Duration(microseconds: 200), () {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'ChatGPT - Flutter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: AppTheme.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) {
                    return Row(
                      children: [
                        if (_messages[index].messageFrom == MessageFrom.me)
                          const Spacer(),
                        Container(
                          margin: const EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _messages[index].message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              TextField(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                maxLines: 4,
                minLines: 1,
                controller: _inputCtrl,
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: AppTheme.secondaryColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
