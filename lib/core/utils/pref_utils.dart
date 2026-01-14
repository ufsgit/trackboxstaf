import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: must_be_immutable
class PrefUtils {
  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static SharedPreferences? _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  bool isLiveFinished() {
    try {
      return (_sharedPreferences!.getString('isLiveFinish') ?? "1") == "1";
    } catch (e) {
      return true;
    }
  }

  String getTeacherId() {
    try {
      String id = _sharedPreferences!.getString('breffini_teacher_Id')!;
      return id;
    } catch (e) {
      return '0';
    }
  }

  String getTeacherName() {
    try {
      String id = _sharedPreferences!.getString('First_Name')!;
      return id;
    } catch (e) {
      return 'NA';
    }
  }

  String getMeetLink() {
    try {
      String id = _sharedPreferences!.getString('Live_Link')!;
      return id;
    } catch (e) {
      return 'NA';
    }
  }

  setTeacherName(String name) {
    try {
      _sharedPreferences!.setString('First_Name', name);
    } catch (e) {
      print("$e/////////////////");
    }
  }

  String getProfileUrl() {
    try {
      String id = _sharedPreferences!.getString('profile_url')!;
      return id;
    } catch (e) {
      return '';
    }
  }

  setProfileUrl(String name) {
    try {
      _sharedPreferences!.setString('profile_url', name);
    } catch (e) {}
  }

  setMeetLink(String name) {
    try {
      _sharedPreferences!.setString('Live_Link', name);
    } catch (e) {}
  }
}
