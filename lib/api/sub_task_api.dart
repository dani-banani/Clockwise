import 'dart:convert';

import 'package:computing_project/api/api_response_json.dart';
import 'package:computing_project/api/authentication_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/api_response.dart';

class SubTaskApi {
  static Future<ApiResponse> createSubTask({
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
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      final response = await Supabase.instance.client
          .from('cw_subtasks')
          .insert({
            'cw_task_id': taskId,
            'cw_task_name': subTaskName,
            'cw_task_completion_status': false,
          })
          .select();

      if (response.isEmpty) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["Create subtask failed"],
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        message: ["Subtask created successfully"],
        data: {
          "taskId": taskId,
          "subTaskName": subTaskName,
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

      final response = await Supabase.instance.client
          .from('cw_subtasks')
          .update(fieldsToUpdate)
          .eq('cw_subtask_id', subTaskId)
          .select();

      if (response.isEmpty) {
        jsonResponse = ApiResponseJson.dataSessionResponseHandler(
          success: false,
          message: ["Edit subtask failed"],
        );
        return ApiResponse.fromJson(jsonDecode(jsonResponse));
      }

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        message: ["Subtask updated successfully"],
        data: {
          "subTaskId": subTaskId,
          ...fieldsToUpdate,
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
          .from('cw_subtasks')
          .delete()
          .eq('cw_subtask_id', subTaskId);

      jsonResponse = ApiResponseJson.dataSessionResponseHandler(
        success: true,
        message: ["Subtask deleted successfully"],
        data: {
          "subTaskId": subTaskId,
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
}