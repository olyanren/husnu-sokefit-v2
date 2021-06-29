import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiHelper {


  Future<ApiResponseModel> request(String url,
      {Map<String, String> queryParameters,
      accessToken = '',
      contentType = "application/json"}) async {
    return _innerRequest(url, 'GET',
        accessToken: accessToken,
        contentType: contentType,
        params: queryParameters);
  }

  Future<ApiResponseModel> deleteRequest(String url,
      {Map<String, dynamic> parameters,
      String accessToken,
      contentType = 'application/json'}) {
    return _innerRequest(url, 'DELETE',
        accessToken: accessToken, contentType: contentType, params: parameters);
  }

  Future<ApiResponseModel> _innerRequest(String url, String type,
      {Map<String, dynamic> params,
      accessToken = '',
      contentType = "application/json",
      useApiPrefix = true}) async {
    if (type == 'GET' && params != null)
      url = _getUrl(url, useApiPrefix: useApiPrefix, params: params);
    else
      url = _getUrl(url, useApiPrefix: useApiPrefix);
    Dio dio = _getDio(accessToken, contentType: contentType);
    try {
      var response;
      if (type == 'GET')
        response = await dio.get(url);
      else if (type == 'POST') {
        log('POST Params: ' + jsonEncode(params));
        response = await dio.post(url,
            data: contentType == "application/json"
                ? jsonEncode(params)
                : params);
      } else if (type == 'PUT') {
        log('PUT Params: ' + jsonEncode(params));
        response = await dio.put(url,
            data: contentType == "application/json"
                ? jsonEncode(params)
                : params);
      } else if (type == 'DELETE') {
        log('DELETE Params: ' + jsonEncode(params));
        response = await dio.delete(url,
            data: contentType == "application/json"
                ? jsonEncode(params)
                : params);
      } else
        throw Exception('type must be one of GET, POST');
      if (response.statusCode == 200) {
        return _getApiResponseModel(response.data);
      }
    } on DioError catch (e) {
      if (e.response == null) {
        log('Dio Error: ' + e.error.message);
        return _getApiUnhandledError();
      }
      if (e.response.statusCode == 400 || e.response.statusCode == 401) {
        return _getApiResponseModel(e.response.data);
      } else {
        return _getApiUnhandledError();
      }
    } catch (error) {
      return _getApiUnhandledError();
    }
  }

  Future<ApiResponseModel> owinLogin(
      String url, Map<String, dynamic> postParams) async {
    url = _getUrl(url, useApiPrefix: false);
    Dio dio = _getDio(null, contentType: "application/x-www-form-urlencoded");
    try {
      var response;

      log('POST Params: ' + jsonEncode(postParams));
      response = await dio.post(url, data: postParams);

      if (response.statusCode == 200) {
        var apiResponse = new ApiResponseModel();
        apiResponse.message = 'Giriş başarılı';
        apiResponse.status = true;
        apiResponse.data = response.data;
        return apiResponse;
      }
    } on DioError catch (e) {
      if (e.response == null) {
        log('Dio Error: ' + e.error.message);
        return _getApiUnhandledError();
      }
      if (e.response.statusCode == 400 || e.response.statusCode == 401) {
        return _getApiResponseModel(e.response.data);
      } else {
        return _getApiUnhandledError();
      }
    } catch (error) {
      return _getApiUnhandledError();
    }
  }

  String _getUrl(String relativePath, {useApiPrefix = true, params}) {
    if (!relativePath.startsWith("/")) relativePath = '/' + relativePath;
    var uri = Constants.BASE_PATH.startsWith("https://")
        ? Uri.https(
        Constants.BASE_PATH.substring("https://".length),
            useApiPrefix == true ? (Constants.API_PATH + relativePath) : relativePath,
            params)
        : Uri.http(
        Constants.BASE_PATH.substring("http://".length),
            useApiPrefix == true ? (Constants.API_PATH + relativePath) : relativePath,
            params);
    log('URL: $uri');

    return uri.toString();
  }

  Dio _getDio(accessToken, {contentType = "application/json; charset:utf-8"}) {
    // or new Dio with a BaseOptions instance.
    BaseOptions options = new BaseOptions();
    options.headers["Accept"] = "application/json";
    if (accessToken != null && accessToken != '')
      options.headers["Authorization"] = 'Bearer ' + accessToken;

    Dio dio = new Dio(options);
    if (contentType.toString().startsWith("application/json")) {
      dio.options.contentType = Headers.jsonContentType;
    } else {
      dio.options.contentType = Headers.formUrlEncodedContentType;
    }
    return dio;
  }

  ApiResponseModel _getApiResponseModel(result) {
    log('Response: ' + jsonEncode(result));
    var apiResponse = new ApiResponseModel();
    apiResponse.message = result['message'] == 'Unauthenticated.'
        ? 'Oturumunuz kapandı. Lütfen çıkış yapıp tekrar giriş yapınız'
        : result['message'];
    apiResponse.status = result['success'] == null ? false : result['success'];
    apiResponse.data = result['data'];

    return apiResponse;
  }

  ApiResponseModel _getApiUnhandledError() {
    var apiResponse = new ApiResponseModel();
    apiResponse.message = 'Beklenmeyen bir hata oluştu';
    apiResponse.status = false;
    apiResponse.data = '';
    return apiResponse;
  }

  Future<ApiResponseModel> postRequest(
      String url, Map<String, dynamic> postParams,
      {String accessToken,
      contentType = 'application/json',
      useApiPrefix = true}) async {
    return _innerRequest(url, 'POST',
        params: postParams,
        accessToken: accessToken,
        contentType: contentType,
        useApiPrefix: useApiPrefix);
  }

  Future<ApiResponseModel> putRequest(
      String url, Map<String, dynamic> postParams,
      {String accessToken,
      contentType = 'application/json',
      useApiPrefix = true}) async {
    return _innerRequest(url, 'PUT',
        params: postParams,
        accessToken: accessToken,
        contentType: contentType,
        useApiPrefix: useApiPrefix);
  }

  Future<ApiResponseModel> uploadFile(
      String url, String parameterName, String path,
      [accessToken = '']) async {
    String fileName = path.split('/').last;
    Dio dio = _getDio(accessToken);

    FormData formData = FormData.fromMap({
      parameterName: await MultipartFile.fromFile(path, filename: fileName),
    });
    var response = await dio.post(_getUrl(url).toString(), data: formData);
    return _getApiResponseModel(response.data);
  }
}
