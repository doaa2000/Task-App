import 'row.dart';

class Data {
  List<Row>? rows;
  String? message;

  Data({this.rows, this.message});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rows: (json['rows'] as List<dynamic>?)
            ?.map((e) => Row.fromJson(e as Map<String, dynamic>))
            .toList(),
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'rows': rows?.map((e) => e.toJson()).toList(),
        'message': message,
      };
}
