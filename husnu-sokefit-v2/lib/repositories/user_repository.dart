import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/models/coach_model.dart';
import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/user_model.dart';
import 'package:crossfit/providers/user_provider.dart';

/*
This class is us
 */
class UserRepository {
  UserProvider _userProvider = UserProvider();

  Future<ApiResponseModel> login(String phone, String password) =>
      _userProvider.login(phone, password);

  Future<ApiResponseModel> forgetPassword(String phone) =>
      _userProvider.forgetPassword(phone);

  Future<ApiResponseModel>  register(UserModel userModel) => _userProvider.register(userModel);
  Future<ApiResponseModel>  privateRegister(UserModel userModel) => _userProvider.privateRegister(userModel);
  Future<ApiResponseModel>  privateManuelPaymentRegister(UserModel userModel) => _userProvider.privateManuelPaymentRegister(userModel);
  Future<ApiResponseModel>  payment(int packageId) => _userProvider.payment(packageId);
  Future<ApiResponseModel>  privatePayment(int packageId,int coachId,bool isManuel) => _userProvider.privatePayment(packageId,coachId,isManuel);

  Future<ApiResponseModel> updatePhoto(String path) => _userProvider.updatePhoto(path);
  Future<ApiResponseModel> freezeAccount() => _userProvider.freezeAccount();
  Future<ApiResponseModel> users() => _userProvider.users();
  Future<PaginationModel> passiveUsers(int page,int itemCount) => _userProvider.passiveUsers(page,itemCount);
  Future<PaginationModel> activeUsers(int page,int itemCount) => _userProvider.activeUsers(page,itemCount);
  Future<ApiResponseModel> privateUsers() => _userProvider.privateUsers();
  Future<PaginationModel> searchPassiveUsers(String query,int page,int itemCount) => _userProvider.searchPassiveUsers(query,page,itemCount);
  Future<PaginationModel> searchActiveUsers(String query,int page,int itemCount) => _userProvider.searchActiveUsers(query,page,itemCount);
  Future<ApiResponseModel> updateScore(int scoreId, String value) {
    return _userProvider.updateScore(scoreId,value);
  }
  Future<ApiResponseModel> sendSms(String userIds, String message) => _userProvider.sendSms(userIds,message);
  Future<ApiResponseModel> sendSmsToCoach(int coachId, String message) => _userProvider.sendSmsToCoach(coachId,message);
  Future<ApiResponseModel> sendOneSignalNotification(String userIds, String message,String tag) {
    return _userProvider.sendOneSignalNotification(userIds,message,tag);
  }
  Future<ApiResponseModel> createCoach(CoachModel coachModel) {
    return _userProvider.createCoach(coachModel);
  }
  Future<ApiResponseModel> coaches(int locationId) => _userProvider.coaches(locationId);
  Future<ApiResponseModel> privateRenewAccount(int coachId, int packageId,int userId) => _userProvider.privateRenewAccount(coachId,packageId,userId);
  Future<ApiEvent> deleteCoach(int id) => _userProvider.deleteCoach(id);

}
