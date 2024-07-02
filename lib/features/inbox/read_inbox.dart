import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ReadInboxPage extends ConsumerStatefulWidget {
  final String senderId;
  final types.Room room;
  const ReadInboxPage({
    super.key,
    required this.senderId,
    required this.room,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadInboxPageState();
}

class _ReadInboxPageState extends ConsumerState<ReadInboxPage> {
  bool _isAttachmentUploading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
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

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref('rooms/$name');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref('rooms/$name');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

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
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserProvider(widget.senderId)).when(
          data: (UserModel user) {
            return PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                ref.read(navBarVisibilityProvider.notifier).show();
                context.pop();
              },
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: _appBar(user, context),
                body: StreamBuilder<types.Room>(
                    initialData: widget.room,
                    stream: FirebaseChatCore.instance.room(widget.room.id),
                    builder: (context, snapshot) {
                      return StreamBuilder<List<types.Message>>(
                          initialData: const [],
                          stream: FirebaseChatCore.instance
                              .messages(snapshot.data!),
                          builder: (context, snapshot) {
                            return Chat(
                              isAttachmentUploading: _isAttachmentUploading,
                              onPreviewDataFetched: _handlePreviewDataFetched,
                              onMessageTap: _handleMessageTap,
                              showUserAvatars: true,
                              showUserNames: true,
                              messages: snapshot.data ?? [],
                              onAttachmentPressed: _handleAttachmentPressed,
                              onSendPressed: _handleSendPressed,
                              user: types.User(
                                id: FirebaseChatCore
                                        .instance.firebaseUser?.uid ??
                                    '',
                              ),
                              theme: DefaultChatTheme(
                                userAvatarImageBackgroundColor:
                                    Colors.transparent,
                                seenIcon: const Icon(Icons.done_all),
                                inputTextColor:
                                    Theme.of(context).colorScheme.onBackground,
                                inputBackgroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                            );
                          });
                    }),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
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
