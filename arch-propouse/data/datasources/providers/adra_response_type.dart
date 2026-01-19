import 'package:dio/dio.dart';

enum ResponseTypeEnum {
  json,
  stream,
  plain,
  bytes,
}

class ResponseTypeClient {
  final ResponseTypeEnum? type;

  const ResponseTypeClient({this.type});

  ResponseType get responseType {
    switch (type) {
      case ResponseTypeEnum.json:
        return ResponseType.json;
      case ResponseTypeEnum.stream:
        return ResponseType.stream;
      case ResponseTypeEnum.plain:
        return ResponseType.plain;
      case ResponseTypeEnum.bytes:
        return ResponseType.bytes;
      default:
        return ResponseType.json;
    }
  }

  @override
  String toString() {
    return 'ResponseTypeWrapper{type: $type}';
  }
}
