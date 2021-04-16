import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/constants/constants.dart';
import 'package:sokefit/helpers/api_helper.dart';
import 'package:sokefit/helpers/database_helper.dart';
import 'package:sokefit/models/api_response_model.dart';

/*
This class is us
 */
class WodProvider {
  Future<ApiResponseModel> todayWod() {
    if (Constants.USER_ROLES.contains('user'))
      return new ApiHelper()
          .request('users/wods/today', accessToken: Constants.ACCESS_TOKEN);
    else if (Constants.USER_ROLES.contains('admin'))
      return new ApiHelper()
          .request('admin/wods/today', accessToken: Constants.ACCESS_TOKEN);
    else
      return new ApiHelper()
          .request('coaches/wods/today', accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> wods() {
    var link="users/wods/all";
    if(Constants.USER_ROLES.contains("coach")){
      link="coaches/wods/all";
    }
    return new ApiHelper()
        .request(link, accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> wodHours() {
    return new ApiHelper()
        .request('admin/wods/hours', accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> todayWodHoursUser() {
    if (Constants.USER_ROLES.contains('user'))
      return new ApiHelper().request('users/wods/today/hours',
          accessToken: Constants.ACCESS_TOKEN);
    else if (Constants.USER_ROLES.contains('coach'))
      return new ApiHelper().request('coaches/wods/today/hours',
          accessToken: Constants.ACCESS_TOKEN);
    else
      return new ApiHelper().request('admin/wods/today/hours',
          accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> todayWodHourDetail(DateTime updatedAt) {
    var postParams = {
      'wod-updated-at': updatedAt.toString(),
    };

    if (Constants.USER_ROLES.contains('user'))
      return new ApiHelper().request('users/wods/users',
          queryParameters: postParams, accessToken: Constants.ACCESS_TOKEN);
    else if (Constants.USER_ROLES.contains('coach'))
      return new ApiHelper().request('coaches/wods/users',
          queryParameters: postParams, accessToken: Constants.ACCESS_TOKEN);
    else
      return new ApiHelper().request('admin/wods/users',
          queryParameters: postParams, accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> participateUserToWod(DateTime updatedAt) {
    var postParams = {
      'wod-updated-at': updatedAt.toString(),
    };
    return new ApiHelper().postRequest('users/wods/today/hours', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> cancelParticipate(DateTime updatedAt) {
    var postParams = {
      'wod-updated-at': updatedAt.toString(),
    };
    return new ApiHelper().postRequest(
        'users/wods/today/hours/cancel', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> addScore(
      DateTime wodUpdatedAt, String category, String score) {
    var postParams = {
      'wod-updated-at': wodUpdatedAt.toString(),
      'category': category,
      'score': score
    };
    return new ApiHelper().postRequest('users/wods/score', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> coachSetParticipated(int userWodId, String status) {
    var postParams = {
      'user-wod-id': userWodId,
      'status': status,
    };
    return new ApiHelper().postRequest(
        'coaches/wods/users/set-participated', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> saveWodHour(
      String day, String hour, int total, int coachId) {
    var postParams = {
      'day': day,
      'hours': hour,
      'total': total,
      'coach_id': coachId,
    };
    return new ApiHelper().postRequest('admin/wods', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiEvent> removeWodHours() {
    return new ApiHelper()
        .deleteRequest('admin/wods', accessToken: Constants.ACCESS_TOKEN)
        .then((value) {
      if (value.status == false)
        return WodHourDeleteFailedEvent(value.message);
      else
        return WodHourDeleteFinishedEvent(value.message);
    });
  }

  Future<ApiResponseModel> createWod(String date, String content) {
    var postParams = {
      'day': date,
      'content': content,
    };
    return new ApiHelper().postRequest('admin/today-wods-create', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> wodDetail(int id) {
    var queryParams = {
      'id': id.toString(),
    };
    var link="users/wods/detail";
    if(Constants.USER_ROLES.contains("coach")){
      link="coaches/wods/detail";
    }
    return new ApiHelper().request(link,
        accessToken: Constants.ACCESS_TOKEN, queryParameters: queryParams);
  }
}
