import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import 'api_response_json.dart';

import '../model/api_response.dart';

class AuthenticationApi {
  // Signup
  static Future<ApiResponse> signUpUser({
    required String email,
    required String password,
  }) async {
    String jsonResponse = "";

    try {
      final signUpResponse = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (signUpResponse.user != null) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: true,
          message: ["User registered successfully"],
          data: signUpResponse.user!.toJson(),
        );

        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["User registration failed"],
      );
    } on AuthException catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Sign up failed: ${e.message}"],
      );
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
    }

    return ApiResponse.fromJson(jsonDecode(jsonResponse));
  }

  // Update User Details
  static Future<ApiResponse> updateUserProfile({
    required String username,
    required String gender,
    required DateTime birthdate,
  }) async {
    String jsonResponse = "";

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["User not authenticated"],
        );

        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      final response = await Supabase.instance.client
          .from('cw_user_profile')
          .update({
            'cw_username': username,
            'cw_gender': gender,
            'cw_birthdate': birthdate.toIso8601String(),
          })
          .eq('cw_user_id', user.id)
          .select();

      if (response.isEmpty) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["No profile was updated UID may not exist"],
        );

        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        message: ["User profile updated successfully"],
        data: {
          "uid": user.id,
          "username": username,
          "gender": gender,
          "birthdate": birthdate.toIso8601String()
        },
      );
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
    }
    return ApiResponse.fromJson(jsonDecode(jsonResponse));
  }

  // Sign in
  static Future<ApiResponse> signInUser({
    required String email,
    required String password,
  }) async {
    String jsonResponse = "";

    try {
      final signInResponse = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      if (signInResponse.user != null) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: true,
          message: ["User logged in successfully"],
          data: signInResponse.user!.toJson(),
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["User login failed"],
      );
    } on AuthException catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Sign in failed: ${e.message}"],
      );
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
    }

    return ApiResponse.fromJson(jsonDecode(jsonResponse));
  }

  // Sign out
  static Future<ApiResponse> signOutUser() async {
    String jsonResponse = "";

    try {
      await Supabase.instance.client.auth.signOut();
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        message: ["User signed out successfully"],
      );
    } on AuthException catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Sign out failed: ${e.message}"],
      );
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
    }

    return ApiResponse.fromJson(jsonDecode(jsonResponse));
  }

  // Authenticate
  static Future<ApiResponse> authenticateUser() async {
    String jsonResponse = "";
    try {
      final valid = await ensureValidSession();
      if (!valid) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      final session = Supabase.instance.client.auth.currentSession!;
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        data: {
          "userId": session.user.id,
        },
      );
      return ApiResponse.fromJson(jsonDecode(jsonResponse));
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
    }

    return ApiResponse.fromJson(jsonDecode(jsonResponse));
  }

// Ensure valid session
  static Future<bool> ensureValidSession() async {
    final auth = Supabase.instance.client.auth;
    final session = auth.currentSession;
    final now = DateTime.now().microsecondsSinceEpoch ~/ 1000;
    if (session == null ||
        (session.expiresAt != null && session.expiresAt! < now)) {
      final refreshRes = await auth.refreshSession();
      if (refreshRes.session == null) {
        return false;
      }
    }
    return true;
  }
}
