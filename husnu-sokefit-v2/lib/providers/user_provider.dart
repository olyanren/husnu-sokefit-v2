import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/constants/constants.dart';
import 'package:crossfit/helpers/api_helper.dart';
import 'package:crossfit/helpers/database_helper.dart';
import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/models/user_pagination_model.dart';

/*
This class is us
 */
class UserProvider {
  Future<ApiResponseModel> login(String phone, String password) {
    var postParams = {
      'phone': phone,
      'password': password,
    };
    return new ApiHelper().postRequest('login', postParams);
  }

  Future<ApiResponseModel> forgetPassword(String phone) {
    var postParams = {
      'phone': phone,
    };
    return new ApiHelper().postRequest('users/forget-password', postParams);
  }

  Future<ApiResponseModel> register(UserModel userModel) {
    var nameParams = userModel.name.trim().split(" ");
    var firstName;
    var lastName;
    if (nameParams.length == 4) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2] + " " + nameParams[3];
    }
    if (nameParams.length == 3) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2];
    } else if (nameParams.length == 2) {
      firstName = nameParams[0];
      lastName = nameParams[1];
    }
    var postParams = {
      'fname': firstName,
      'lname': lastName,
      'location_id': userModel.locationId,
      'account': userModel.name.trim(),
      'jobtitle': Constants.APP_NAME,
      'company': Constants.APP_NAME,
      'email': userModel.email,
      'phone': userModel.phone,
      'password': userModel.password,
      'currency': '',
      'tags': '',
      'address': Constants.APP_NAME,
      'city': Constants.APP_NAME,
      'state': Constants.APP_NAME,
      'zip': Constants.APP_NAME,
      'country': 'Turkiye',
    };
    return new ApiHelper().postRequest('users', postParams);
  }

  Future<ApiResponseModel> privateRegister(UserModel userModel) {
    var nameParams = userModel.name.trim().split(" ");
    var firstName;
    var lastName;
    if (nameParams.length == 4) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2] + " " + nameParams[3];
    }
    if (nameParams.length == 3) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2];
    } else if (nameParams.length == 2) {
      firstName = nameParams[0];
      lastName = nameParams[1];
    }
    var postParams = {
      'fname': firstName,
      'lname': lastName,
      'account': userModel.name.trim(),
      'jobtitle': Constants.APP_NAME,
      'company': Constants.APP_NAME,
      'email': userModel.email,
      'phone': userModel.phone,
      'password': userModel.password,
      'currency': '',
      'tags': '',
      'address': Constants.APP_NAME,
      'city': Constants.APP_NAME,
      'state': Constants.APP_NAME,
      'zip': Constants.APP_NAME,
      'country': 'Turkiye',
      'coach_id': userModel.coachId,
      'package_id': userModel.packageId,
      'location_id': userModel.locationId,
    };
    return new ApiHelper().postRequest('pt/users', postParams);
  }

  Future<ApiResponseModel> privateManuelPaymentRegister(UserModel userModel) {
    var nameParams = userModel.name.trim().split(" ");
    var firstName;
    var lastName;
    if (nameParams.length == 4) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2] + " " + nameParams[3];
    }
    if (nameParams.length == 3) {
      firstName = nameParams[0] + " " + nameParams[1];
      lastName = nameParams[2];
    } else if (nameParams.length == 2) {
      firstName = nameParams[0];
      lastName = nameParams[1];
    }
    var postParams = {
      'fname': firstName,
      'lname': lastName,
      'account': userModel.name.trim(),
      'jobtitle': Constants.APP_NAME,
      'company': Constants.APP_NAME,
      'email': userModel.email,
      'phone': userModel.phone,
      'password': userModel.password,
      'currency': '',
      'tags': '',
      'address': Constants.APP_NAME,
      'city': Constants.APP_NAME,
      'state': Constants.APP_NAME,
      'zip': Constants.APP_NAME,
      'country': 'Turkiye',
      'coach_id': userModel.coachId,
      'package_id': userModel.packageId,
    };
    return new ApiHelper().postRequest('pt/admin/users', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> payment(int packageId) {
    var postParams = {
      'note': 'mobil-api',
      'currency_id': '1',
      'package_id': packageId,
      'invoice_prefix': '',
    };

    return new ApiHelper().postRequest('users/invoices', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> privatePayment(
      int packageId, int coachId, isManuel) {
    var postParams = {
      'note': 'mobil-api',
      'currency_id': '1',
      'package_id': packageId,
      'coach_id': coachId,
      'invoice_prefix': '',
      'manuel': isManuel,
    };

    return new ApiHelper().postRequest('pt/users/invoices', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> users() {
    var params = new Map<String, String>();
    params["active-users"] = "true";
    return new ApiHelper().request('admin/users',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
  }

  Future<PaginationModel> passiveUsers(int page, int itemCount) async {
    var params = new Map<String, String>();
    params["active-users"] = "false";
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    var result = await new ApiHelper().request('admin/users1',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var user = new UserPaginationModel.fromJson(result.data);
    user.success = result.status;
    user.message = result.message;
    return user;
  }

  Future<PaginationModel> activeUsers(int page, int itemCount) async {
    var params = new Map<String, String>();
    params["active-users"] = "true";
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    var result = await new ApiHelper().request('admin/users1',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var user = new UserPaginationModel.fromJson(result.data);
    user.success = result.status;
    user.message = result.message;
    return user;
  }

  Future<PaginationModel> searchPassiveUsers(
      String query, int page, int itemCount) async {
    var params = new Map<String, String>();
    params["active-users"] = "false";
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    params["query"] = query;
    var result = await new ApiHelper().request('admin/users1',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var user = new UserPaginationModel.fromJson(result.data);
    user.success = result.status;
    user.message = result.message;
    return user;
  }

  Future<PaginationModel> searchActiveUsers(
      String query, int page, int itemCount) async {
    var params = new Map<String, String>();
    params["active-users"] = "true";
    params["page"] = page.toString();
    params["total"] = itemCount.toString();
    params["query"] = query;
    var result = await new ApiHelper().request('admin/users1',
        accessToken: Constants.ACCESS_TOKEN, queryParameters: params);
    var user = new UserPaginationModel.fromJson(result.data);
    user.success = result.status;
    user.message = result.message;
    return user;
  }

  Future<ApiResponseModel> coaches(int locationId) {
    return new ApiHelper()
        .request('coach-list/' + locationId.toString(),
            accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<CoachModel>((item) => CoachModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }

  Future<ApiResponseModel> privateUsers() {
    return new ApiHelper()
        .request('pt/admin/users', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        result.data = result.data
            .map<UserModel>((item) => UserModel.fromJson(item))
            .toList();
      }
      return result;
    });
  }

  Future<ApiEvent> deleteCoach(int id) {
    return new ApiHelper()
        .deleteRequest('admin/coaches/$id', accessToken: Constants.ACCESS_TOKEN)
        .then((result) {
      if (result.status == true) {
        return ApiSuccessEvent(result.message);
      } else
        return ApiFailedEvent(result.message);
    });
  }

  Future<ApiResponseModel> updatePhoto(String path) {
    return new ApiHelper()
        .uploadFile('users/photo', 'image', path, Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> freezeAccount() {
    return new ApiHelper()
        .request('users/account/freeze', accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> updateScore(int scoreId, String value) {
    var baseUrl = 'users';
    if (Constants.USER_ROLES.contains('admin')) baseUrl = 'admin';
    if (Constants.USER_ROLES.contains('coach')) baseUrl = 'coaches';
    var postParams = {
      'score_id': scoreId,
      'value': value,
    };
    return new ApiHelper().postRequest(baseUrl + '/scores', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> sendSms(String userIds, String message) {
    var postParams = {
      'user_ids': userIds,
      'message': message,
    };
    return new ApiHelper().postRequest('admin/notifications/sms', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> sendSmsToCoach(int coachId, String message) {
    var postParams = {
      'coach_id': coachId,
      'message': message,
    };
    return new ApiHelper().postRequest('pt/users/send-sms-to-coach', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> sendOneSignalNotification(
      String userIds, String message, String tag) {
    var postParams = {
      'type': userIds == '-1' ? 'All' : 'Single',
      'user_ids': userIds,
      'title': 'Bilgilendirme',
      'is_test': false,
      'message': message,
      'tag': tag
    };
    var url = 'admin/notifications/onesignal';
    if (Constants.USER_ROLES.contains("admin")) {
      url = 'admin/notifications/onesignal';
    } else if (Constants.USER_ROLES.contains("pt")) {
      url = 'pt/users/notifications/onesignal';
    }
    return new ApiHelper()
        .postRequest(url, postParams, accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> createCoach(CoachModel coachModel) {
    return new ApiHelper().postRequest('admin/coaches', coachModel.toMap(),
        accessToken: Constants.ACCESS_TOKEN);
  }

  Future<ApiResponseModel> privateRenewAccount(
      int coachId, int packageId, int userId) {
    var postParams = {
      'coach_id': coachId,
      'package_id': packageId,
    };
    if (userId != 0) {
      postParams['user_id'] = userId;
      return new ApiHelper().postRequest(
          'pt/admin/users/renew-account', postParams,
          accessToken: Constants.ACCESS_TOKEN);
    }
    return new ApiHelper().postRequest('pt/users/renew-account', postParams,
        accessToken: Constants.ACCESS_TOKEN);
  }
}
