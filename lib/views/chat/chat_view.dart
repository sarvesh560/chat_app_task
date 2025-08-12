import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_textstyles.dart';
import '../../core/screen_util_helper.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;

  const ChatView({
    Key? key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    chatController.sendText(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      receiverId: widget.otherUserId,
      text: text,
    );

    _textController.clear();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return DateFormat('hh:mm a').format(dt);
  }

  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: ScreenUtilHelper.scaleWidth(24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.otherUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const SizedBox.shrink();
            }

            final userData = snapshot.data!.data()!;
            final name = userData['name'] ?? 'Unknown';
            final profileImage = userData['profileImage'] ?? '';

            return Row(
              children: [
                CircleAvatar(
                  radius: ScreenUtilHelper.radius(20),
                  backgroundImage: (profileImage.isNotEmpty && _isValidUrl(profileImage))
                      ? NetworkImage(profileImage)
                      : null,
                  child: (profileImage.isEmpty || !_isValidUrl(profileImage))
                      ? Icon(Icons.person, size: ScreenUtilHelper.scaleWidth(20))
                      : null,
                ),
                SizedBox(width: ScreenUtilHelper.width(10)),
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.headline6.copyWith(
                      color: Colors.white,
                      fontSize: ScreenUtilHelper.fontSize(18),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: chatController.messagesStream(widget.chatId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: AppTextStyles.bodyText2.copyWith(
                        fontSize: ScreenUtilHelper.fontSize(14),
                      ),
                    ),
                  );
                }

                final messages = snap.data!.docs.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtilHelper.width(12),
                    vertical: ScreenUtilHelper.height(12),
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();
                    final isMe = data['senderId'] == widget.currentUserId;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final timeString = timestamp != null ? _formatTimestamp(timestamp) : '';
                    final senderProfile = data['senderProfile'] ?? '';

                    return Container(
                      margin: EdgeInsets.only(
                        bottom: ScreenUtilHelper.height(10),
                        left: isMe ? ScreenUtilHelper.width(50) : 0,
                        right: isMe ? 0 : ScreenUtilHelper.width(50),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            CircleAvatar(
                              radius: ScreenUtilHelper.radius(15),
                              backgroundColor: AppColors.greyLight,
                              backgroundImage: (senderProfile.isNotEmpty && _isValidUrl(senderProfile))
                                  ? NetworkImage(senderProfile)
                                  : null,
                              child: senderProfile.isEmpty || !_isValidUrl(senderProfile)
                                  ? Icon(Icons.person, size: ScreenUtilHelper.scaleWidth(15))
                                  : null,
                            ),
                          if (!isMe) SizedBox(width: ScreenUtilHelper.width(8)),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtilHelper.width(14),
                                vertical: ScreenUtilHelper.height(10),
                              ),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? const LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                    : null,
                                color: isMe ? null : AppColors.greyLight,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(ScreenUtilHelper.radius(18)),
                                  topRight: Radius.circular(ScreenUtilHelper.radius(18)),
                                  bottomLeft: Radius.circular(ScreenUtilHelper.radius(isMe ? 18 : 0)),
                                  bottomRight: Radius.circular(ScreenUtilHelper.radius(isMe ? 0 : 18)),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data['text'] ?? '',
                                    style: isMe
                                        ? AppTextStyles.chatTextWhite
                                        : AppTextStyles.chatTextBlack,
                                  ),
                                  if (timeString.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: ScreenUtilHelper.height(4)),
                                      child: Text(
                                        timeString,
                                        style: AppTextStyles.timestamp(isMe),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (isMe) SizedBox(width: ScreenUtilHelper.width(8)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtilHelper.width(12),
              ).copyWith(bottom: ScreenUtilHelper.height(8)),
              color: AppColors.background,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontSize: ScreenUtilHelper.fontSize(14),
                        ),
                        filled: true,
                        fillColor: AppColors.greyLight,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtilHelper.width(16),
                          vertical: ScreenUtilHelper.height(12),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ScreenUtilHelper.radius(25)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenUtilHelper.width(8)),
                  Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                      splashRadius: ScreenUtilHelper.radius(24),
                      iconSize: ScreenUtilHelper.scaleWidth(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
