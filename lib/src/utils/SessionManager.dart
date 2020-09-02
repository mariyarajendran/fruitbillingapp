import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SessionManager {
  static const String KEY_USERID = "key_user_id";
  static const String KEY_LEADINFO_ID = "key_lead_info_id";
  static const String KEY_IS_USER_EXISTING = "is_existing_user";
  static const String JWT_TOKEN = "JWT_token";
  static const String STORE_EMAILID = "Store_email_id";
  static const String SUBSCRIBER_ID = "Subscriber_ID";
  static const String USER_ID = "User_ID";
  static const String LOGIN_SESSION = "Login_Session";
  static const String FIRST_TIME_APP = "First_Time_APP";
  static const String APP_LANG_SESSION = "App_Lang_Session";

  void removeAllPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(KEY_USERID);
    await preferences.remove(KEY_LEADINFO_ID);
    await preferences.remove(KEY_IS_USER_EXISTING);
    await preferences.remove(JWT_TOKEN);
    await preferences.remove(STORE_EMAILID);
    await preferences.remove(SUBSCRIBER_ID);
    await preferences.remove(LOGIN_SESSION);
    await preferences.remove(APP_LANG_SESSION);
  }

  Future<bool> setJWTToken(String jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(JWT_TOKEN, jwtToken);
  }

  Future<String> getJWTToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getString(JWT_TOKEN);
  }

  Future<bool> setAppLang(String appLang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(APP_LANG_SESSION, appLang);
  }

  Future<String> getAppLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getString(APP_LANG_SESSION);
  }

  Future<bool> setEmailId(String jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(STORE_EMAILID, jwtToken);
  }

  Future<String> getEmailId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getString(STORE_EMAILID);
  }

  Future<bool> setSubscriberID(int jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(SUBSCRIBER_ID, jwtToken);
  }

  Future<String> getSubscriberID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getString(SUBSCRIBER_ID);
  }

  Future<bool> setUserID(int jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(USER_ID, jwtToken);
  }

  Future<int> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getInt(USER_ID);
  }

  Future<bool> setLoginSession(String jwtToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(LOGIN_SESSION, jwtToken);
  }

  Future<String> getLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getString(LOGIN_SESSION);
  }

  Future<bool> setAppFirstTimeSession(bool boolFirstTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(FIRST_TIME_APP, boolFirstTime);
  }

  Future<bool> getAppFirstTimeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs?.getBool(FIRST_TIME_APP);
  }
}
