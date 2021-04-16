import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/models/api_response_model.dart';
import 'package:sokefit/providers/wod_provider.dart';

/*
This class is us
 */
class WodRepository {
  WodProvider _provider = WodProvider();

  Future<ApiResponseModel> todayWod() => _provider.todayWod();
  Future<ApiResponseModel> wods() => _provider.wods();
  Future<ApiResponseModel> wodHours() => _provider.wodHours();
  Future<ApiResponseModel> todayWodHoursUser() => _provider.todayWodHoursUser();
  Future<ApiResponseModel> todayWodHourDetail(DateTime _updatedWodDate) => _provider.todayWodHourDetail(_updatedWodDate);
  Future<ApiResponseModel> participateUserToWod(DateTime updatedAt) => _provider.participateUserToWod(updatedAt);
  Future<ApiResponseModel> cancelParticipate(DateTime updatedAt) => _provider.cancelParticipate(updatedAt);
  Future<ApiResponseModel> addScore(DateTime wodUpdatedAt, String category, String score)=> _provider.addScore(wodUpdatedAt,category,score);
  Future<ApiResponseModel> coachSetParticipated(int userWodId,String status)=> _provider.coachSetParticipated(userWodId,status);
  Future<ApiResponseModel> saveWodHour(String day, String hour,int total,int coachId)=> _provider.saveWodHour(day,hour,total,coachId);
  Future<ApiEvent> removeWodHours()=> _provider.removeWodHours();
  Future<ApiResponseModel> createWod(String date, String content)=> _provider.createWod(date,content);
  Future<ApiResponseModel> wodDetail(int id)=> _provider.wodDetail(id);


}
