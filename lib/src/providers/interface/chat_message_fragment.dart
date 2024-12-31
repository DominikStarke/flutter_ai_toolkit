import 'package:flutter/widgets.dart';

abstract class ChatMessageFragment {
  final Key key = GlobalKey();
  ChatMessageFragment();

  Widget builder (BuildContext context);
}
