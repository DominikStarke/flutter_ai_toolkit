// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main() async {
  /// Doesn't depend on Firebase.
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'Example: Firebase Vertex AI';

  const App({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: ChatPage(),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: OpenwebuiProvider(
            host: 'http://127.0.0.1:3000',
            model: 'llama3.1:latest',
            apiKey: "YOUR_API_KEY",
          ),
        ),
      );
}
