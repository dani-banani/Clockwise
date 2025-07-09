import 'dart:convert';

import 'package:computing_project/api/api_response_json.dart';
import 'package:computing_project/api/authentication_api.dart';
import 'package:computing_project/model/subtask.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/api_response.dart';

class SubTaskApi {
  static Future<ApiResponse<Subtask?>> createSubTask({
    required int taskId,
    required String subTaskName,
  }) async {
    String jsonResponse = "";
    try {
      final userAuthResponse = await AuthenticationApi.authenticateUser();
      if (!userAuthResponse.success) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          statusCode: 401,
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse),
            fromJson: (json) => null);
      }

      final response =
          await Supabase.instance.client.from('cw_user_subtasks').insert({
        'cw_task_id': taskId,
        'cw_subtask_name': subTaskName,
        'cw_subtask_completion_status': false,
      }).select();

      if (response.isEmpty) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["Something went wrong"],
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse),
            fromJson: (json) => null);
      }

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: true, data: response[0]);

      return ApiResponse.fromJson(jsonDecode(jsonResponse),
          fromJson: (json) => Subtask.fromJson(json));
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
      return ApiResponse.fromJson(jsonDecode(jsonResponse),
          fromJson: (json) => null);
    }
  }

  static Future<ApiResponse> editSubTask({
    required int subTaskId,
    required Map<String, dynamic> fieldsToUpdate,
  }) async {
    String jsonResponse = "";
    try {
      final userAuthResponse = await AuthenticationApi.authenticateUser();
      if (!userAuthResponse.success) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          statusCode: 401,
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      if (fieldsToUpdate.isEmpty) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["No fields to update"],
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      await Supabase.instance.client
          .from('cw_user_subtasks')
          .update(fieldsToUpdate)
          .eq('cw_subtask_id', subTaskId);

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
      );

      return ApiResponse.fromJson(jsonDecode(jsonResponse));
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
      return ApiResponse.fromJson(jsonDecode(jsonResponse));
    }
  }

  static Future<ApiResponse> deleteSubTask({
    required int subTaskId,
  }) async {
    String jsonResponse = "";
    try {
      final userAuthResponse = await AuthenticationApi.authenticateUser();
      if (!userAuthResponse.success) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          statusCode: 401,
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      await Supabase.instance.client
          .from('cw_user_subtasks')
          .delete()
          .eq('cw_subtask_id', subTaskId);

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
      );
      return ApiResponse.fromJson(jsonDecode(jsonResponse));
    } catch (e) {
      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: false,
        message: ["Unexpected error: $e"],
      );
      return ApiResponse.fromJson(jsonDecode(jsonResponse));
    }
  }
}
