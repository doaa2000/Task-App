import 'data.dart';

class ProfileModel {
  int? statusCode;
  Data? data;
  bool? success;
  dynamic error;

  ProfileModel({this.statusCode, this.data, this.success, this.error});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        statusCode: json['status_code'] as int?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        success: json['success'] as bool?,
        error: json['error'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'data': data?.toJson(),
        'success': success,
        'error': error,
      };
}
