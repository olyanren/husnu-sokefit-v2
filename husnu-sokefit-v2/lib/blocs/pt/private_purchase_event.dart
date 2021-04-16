import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/models/pt/hour_model.dart';
class LoadPurchasedItemsEvent extends ApiEvent{
  int page;
  int itemCount;
  int userId;
  LoadPurchasedItemsEvent(this.page,this.itemCount,this.userId);
}

class SearchPurchaseEvent extends ApiEvent{
  String startDate;
  String endDate;
  String query;
  int page;
  int itemCount;
  int coachId;
  SearchPurchaseEvent(this.startDate,this.endDate,this.query,this.page,this.itemCount,this.coachId);
}