import 'package:crossfit/models/api_response_model.dart';
import 'package:crossfit/models/pagination_model.dart';

abstract class ApiEvent{
  String message;
}
class RefreshEvent extends ApiEvent{}
class LoadWodHourEvent extends ApiEvent{}

class WodHourDeleteEvent extends ApiEvent{}
class WodHourDeleteFailedEvent extends ApiFailedEvent{
  WodHourDeleteFailedEvent(String message) : super(message);
}
class WodHourDeleteFinishedEvent extends ApiSuccessEvent{
  WodHourDeleteFinishedEvent(String message) : super(message);
}

class ApiStartedEvent extends ApiEvent{}
class ApiFinishedEvent extends ApiEvent{
  String message;
  ApiFinishedEvent(this.message);
}
class ApiFinishedResponseModelEvent extends ApiEvent{
  ApiResponseModel responseModel;
  ApiFinishedResponseModelEvent(this.responseModel);
}
class PaginationEvent extends ApiEvent{
  PaginationModel paginationModel;
  PaginationEvent(this.paginationModel);
}
class ApiFailedEvent extends ApiEvent{
  String message;
  ApiFailedEvent(this.message);
}
class ApiSuccessEvent extends ApiEvent{
  String message;
  ApiSuccessEvent(this.message);
}