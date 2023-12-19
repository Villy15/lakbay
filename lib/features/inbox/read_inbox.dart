import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ReadInboxPage extends ConsumerStatefulWidget {
  final String senderId;
  const ReadInboxPage({super.key, required this.senderId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadInboxPageState();
}

class _ReadInboxPageState extends ConsumerState<ReadInboxPage> {
  @override
  void initState() {
    super.initState();
    _messages = [
      types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'dvEosZUoe8i5hE-0vNBbhw==',
        text: 'Hello',
      ),
      types.TextMessage(
        author: _otherUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: 'abcEosZUoe8i5hE-0vNBbhw==',
        text: 'Hi there',
      ),
    ];

    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  late List<types.Message> _messages = [];
  final _user = types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
    firstName: 'Villy',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FVilly%2FAFAC%20(square)-1.png?alt=media&token=56e1deef-caaf-413e-bf53-e9a02e78b62f',
    lastSeen: DateTime.now().millisecondsSinceEpoch,
  );
  final _otherUser = types.User(
    id: 'other-user',
    firstName: 'Adrian Test',
    lastSeen: DateTime.now().millisecondsSinceEpoch,
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FVilly%2FAFAC%20(square)-1.png?alt=media&token=56e1deef-caaf-413e-bf53-e9a02e78b62f',
  );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
      debugPrintJson(_messages);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      Icon(Icons.photo),
                      SizedBox(width: 10.0),
                      Text('Photo'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file),
                      SizedBox(width: 10.0),
                      Text('File'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(width: 10.0),
                      Text('Cancel'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: randomString(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        color: _user.id != message.author.id ||
                message.type == types.MessageType.image
            ? const Color(0xfff5f5f7)
            : const Color(0xff6f61e8),
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _user.id != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserProvider(widget.senderId)).when(
          data: (UserModel user) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                context.pop();
                ref.read(navBarVisibilityProvider.notifier).show();
              },
              child: Scaffold(
                appBar: _appBar(user, context),
                body: Chat(
                  bubbleBuilder: _bubbleBuilder,
                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onMessageTap: _handleMessageTap,
                  showUserAvatars: true,
                  showUserNames: true,
                  messages: _messages,
                  onAttachmentPressed: _handleAttachmentPressed,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                  theme: DefaultChatTheme(
                    userAvatarImageBackgroundColor: Colors.transparent,
                    seenIcon: const Icon(Icons.done_all),
                    inputTextColor: Theme.of(context).colorScheme.onBackground,
                    inputBackgroundColor:
                        Theme.of(context).colorScheme.onSecondary,
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(error: error.toString()),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  AppBar _appBar(UserModel user, BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage:
                user.profilePic != '' ? NetworkImage(user.profilePic) : null,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            child: user.profilePic == ''
                ? Text(
                    user.name[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10.0),
          Text(user.name),
        ],
      ),
    );
  }
}
