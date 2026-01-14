import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

class ChatMessageModel {
  final String studentId;
  final String teacherId;
  final String chatMessage;
  final DateTime sentTime;
  final bool isStudent;
  final String filePath;
  bool? isPlaying;
  String? senderName;
  RxDouble? progress = 0.0.obs;
  double? fileSize;
  String? thumbUrl;

  ChatMessageModel({
    required this.studentId,
    required this.teacherId,
    required this.chatMessage,
    required this.sentTime,
    required this.isStudent,
    required this.filePath,
    this.isPlaying,
    this.senderName,
    this.progress,
    this.fileSize,
    this.thumbUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'chatMessage': chatMessage,
      'sentTime': sentTime.toIso8601String(),
      'isStudent': isStudent,
      'filePath': filePath,
      'fileSize': fileSize ?? 0.0,
      'senderName': senderName,
      'thumbUrl': thumbUrl,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      studentId: map['studentId'],
      teacherId: map['teacherId'] ?? '',
      chatMessage: map['chatMessage'],
      sentTime: DateTime.parse(map['sentTime']).toLocal(),
      isStudent: map['isStudent'],
      filePath: map['filePath'],
      fileSize: map['fileSize'] ?? 0.0,
      progress: (0.0).obs,
      thumbUrl: map['thumbUrl'] ?? "",
      senderName: map['senderName'],
      isPlaying: false,
    );
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(sentTime);
  }
}
