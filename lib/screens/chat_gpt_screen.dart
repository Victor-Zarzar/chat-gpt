// ignore_for_file: unused_field, unused_element
import 'package:chat_gpt/core/app_theme.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/repositories/chat_gpt_repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatGPTScreen extends StatefulWidget {
  const ChatGPTScreen({super.key});

  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final _inputCtrl = TextEditingController();
  final _repository = ChatGPTRepository(Dio());
  final _messages = <ChatModel>[];
  final _scrollCtrl = ScrollController();

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
                          return const Row(
                            children: [
                              if (_messages[index].messageFrom ==
                                  MessageFrom.me)
                                Spacer(),
                            ],
                          );
                        }),
                  ),
                  TextField(),
                ],
              ))),
    );
  }
}
