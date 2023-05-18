import 'dart:convert';
import "package:dio/dio.dart";
import "package:intl/intl.dart";

class Client {
  Dio init() {
    Dio _dio = new Dio();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, handler) {
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        return handler.next(e);
      },
    ));
    _dio.options.baseUrl =
        "https://hooks.slack.com/services/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";
    return _dio;
  }
}

class MonitorParams {
  String? method;
  int? sendTimeout;
  int? receiveTimeout;
  int? connectTimeout;
  String? data;
  String? path;
  Map<String, dynamic>? queryParameters;
  String? baseUrl;

  MonitorParams(
      {this.method,
      this.sendTimeout,
      this.receiveTimeout,
      this.connectTimeout,
      this.data,
      this.path,
      this.queryParameters,
      this.baseUrl});
}

class FiedlText {
  String? type;
  Map<String, Object>? text;

  FiedlText({this.type, this.text});

  Map<String, dynamic> toJson({String? type, Map<String, Object>? text}) {
    final Map<String, dynamic> field = <String, dynamic>{};
    field['type'] = type ?? this.type;
    field['text'] = text ?? this.text;
    return field;
  }
}

class Section {
  String? type;
  List? fields;

  Section({this.type, this.fields});

  Map<String, dynamic> toJson({String? type, List? fields}) {
    final Map<String, dynamic> section = <String, dynamic>{};
    section['type'] = type ?? this.type;
    section['fields'] = fields ?? this.fields;
    return section;
  }
}

class MonitorLog {
  Dio _client;

  MonitorLog(this._client);

  Options options = Options(headers: {"Content-type": "application/json"});

  post(Map<String, dynamic> params) {
    final Map<String, dynamic> body = <String, dynamic>{};

    // header
    var text = {
      "type": "plain_text",
      "text": ":beetle: New error",
      "emoji": true
    };
    var header = FiedlText(type: 'header', text: text).toJson();

    // section path
    var path = {"type": "mrkdwn", "text": "*Path:* ${params['path']}"};
    var sectionPath = FiedlText(type: 'section', text: path).toJson();

    // section method, status
    var method = {"type": "mrkdwn", "text": "*Method:* ${params['method']}"};
    var status = {"type": "mrkdwn", "text": "*Status:* ${params['status']}"};
    List fieldsMethod = [];
    fieldsMethod.add(method);
    fieldsMethod.add(status);
    var sectionMethod = Section(type: 'section', fields: fieldsMethod).toJson();

    // section Time
    var createTime = {
      "type": "mrkdwn",
      "text":
          "*Create time:* ${DateFormat('dd/MM/y').add_jm().format(DateTime.now())}"
    };

    List fieldsTime = [];
    fieldsTime.add(createTime);
    var sectionTime = Section(type: 'section', fields: fieldsTime).toJson();

    // section headers
    var headers = {
      "type": "mrkdwn",
      "text": "*Headers:*\n```${params['headers']}```"
    };
    var sectionHeaders = FiedlText(type: 'section', text: headers).toJson();

    // section data
    var data = {"type": "mrkdwn", "text": "*Body:*\n```${params['data']}```"};
    var sectionData = FiedlText(type: 'section', text: data).toJson();

    // section params
    var queryParameters = {
      "type": "mrkdwn",
      "text": "*Parameters:*\n```${params['queryParameters']}```"
    };
    var sectionQueryParameters =
        FiedlText(type: 'section', text: queryParameters).toJson();

    // section params
    var response = {
      "type": "mrkdwn",
      "text": "*Response:*\n```${params['reponse']}```"
    };
    var sectionResponse = FiedlText(type: 'section', text: response).toJson();

    // section error
    var error = {
      "type": "mrkdwn",
      "text": "*Error:*\n```${params['error']}```"
    };
    var sectionError = FiedlText(type: 'section', text: error).toJson();

    body['blocks'] = [];
    body['blocks'].add(header);
    body['blocks'].add(sectionPath);
    body['blocks'].add(sectionMethod);
    body['blocks'].add(sectionTime);
    body['blocks'].add(sectionHeaders);
    body['blocks'].add(sectionData);
    body['blocks'].add(sectionQueryParameters);
    body['blocks'].add(sectionResponse);
    body['blocks'].add(sectionError);

    return _client.post(
        "https://hooks.slack.com/services/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",
        data: json.encode(body),
        options: options);
  }

  Map<String, dynamic> toJson(
      {required String path,
      dynamic data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      dynamic reponse,
      String? method,
      int? status,
      String? error}) {
    final Map<String, dynamic> result = <String, dynamic>{};

    result['path'] = path;
    result['method'] = method;
    result['status'] = status;
    result['data'] = json.encode(data);
    result['headers'] = json.encode(headers);
    result['queryParameters'] = json.encode(queryParameters);
    result['reponse'] = json.encode(reponse);
    result['error'] = error;
    return result;
  }
}
