import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_keys.g.dart';
import '../utils/pick_localized_dyn.dart';

class ApiError {
  final dynamic message;
  final Map<String, dynamic>? errors;

  ApiError({this.message, this.errors});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as Map<String, dynamic>?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  /// ✅ يرجع الرسالة حسب اللغة الحالية للتطبيق
  String getLocalizedMessage(BuildContext context) {
    // 1. Prioritize detailed field validation error (firstFieldError)
    final fieldError = firstFieldError;
    if (fieldError != null && fieldError.isNotEmpty) {
      return fieldError;
    }

    // 2. Fallback to top-level errors['message']
    if (errors != null && errors!['message'] != null) {
      return errors!['message'].toString();
    }

    // 3. Fallback to main localized message
    if (message == null) return LocaleKeys.general_unexpected_error.tr();
    return context.getLocalizedMessage(message, fallback: LocaleKeys.general_unexpected_error.tr());
  }


  /// ✅ لو فيه Errors مفصلة (زي email/phone) نرجع أول واحدة
  String? get firstFieldError {
    if (errors == null) return null;
    if (errors!['errors'] is Map) {
      final firstKey = (errors!['errors'] as Map).keys.first;
      final firstError = (errors!['errors'][firstKey] as List).first;
      return firstError.toString();
    }
    return null;
  }
}
