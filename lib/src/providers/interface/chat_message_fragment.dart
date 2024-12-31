import 'package:flutter/widgets.dart';

abstract class ChatMessageFragment {
  Key key = GlobalKey();
  ChatMessageFragment();

  Widget builder (BuildContext context);
}
