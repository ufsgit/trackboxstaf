import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCallModel {
  String? id;
  String? teacherId;
  String? teacherName;
  String? studentId;
  String? studentName;
  String? callStart;
  String? callEnd;
  String? callDuration;
  String? callType;
  bool? isStudentCalled;
  String? liveLink;
  String? profileUrl, updatedOn, callStatus, type;

  FirebaseCallModel(
      {this.id,
      this.teacherId,
      this.teacherName,
      this.studentId,
      this.studentName,
      this.callStart,
      this.callEnd,
      this.callDuration,
      this.callType,
      this.isStudentCalled,
      this.liveLink,
      this.profileUrl,
      this.updatedOn,
      this.callStatus,
      this.type});

  // Factory constructor to create an instance from Firestore data
  factory FirebaseCallModel.fromMap(Map<String, dynamic> data) {
    return FirebaseCallModel(
      id: data['id'] ?? "",
      teacherId: data['teacher_id'].toString(),
      teacherName: data['teacher_name'],
      studentId: data['student_id'].toString(),
      studentName: data['student_name'],
      callStart: data['call_start'],
      callEnd: data['call_end'],
      callDuration: data['call_duration'],
      callType: data['call_type'],
      isStudentCalled: data['Is_Student_Called'] == 1,
      liveLink: data['Live_Link'],
      profileUrl: data['profile_url'],
      callStatus: data['call_status'],
      updatedOn: data['updated_on'].toString(),
      type: data['type'],
    );
  }
  // Method to convert instance to JSON (Map) for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'student_id': studentId,
      'student_name': studentName,
      'call_start': callStart,
      'call_end': callEnd,
      'call_duration': callDuration,
      'call_type': callType,
      'Is_Student_Called': isStudentCalled,
      'Live_Link': liveLink,
      'profile_url': profileUrl,
      'call_status': callStatus,
      'updated_on': updatedOn,
      'type': type,
    };
  }
}
