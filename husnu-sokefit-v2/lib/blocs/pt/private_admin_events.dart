import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/pt/hour_model.dart';
class LoadPurchasedItemsEvent extends ApiEvent{
  int page;
  int itemCount;
  LoadPurchasedItemsEvent(this.page,this.itemCount);
}
class LoadPrivateScheduleFinishedEvent extends ApiEvent{
  List<HourModel> hours;
  LoadPrivateScheduleFinishedEvent(this.hours);
}

class SearchPrivateRegisterEvent extends ApiEvent{
  String query;
  int page;
  int itemCount;
  SearchPrivateRegisterEvent(this.query,this.page,this.itemCount);
}