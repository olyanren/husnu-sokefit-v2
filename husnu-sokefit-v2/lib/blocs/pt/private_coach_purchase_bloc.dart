import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/bloc.dart';
import 'package:crossfit/blocs/pt/private_purchase_event.dart';
import 'package:crossfit/models/pagination_model.dart';
import 'package:crossfit/models/pt/private_coach_purchase_pagination_model.dart';
import 'package:crossfit/repositories/pt/private_coach_purchased_item_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../pagination_bloc.dart';

class PrivateCoachPurchaseBloc extends BaseBloc
    implements PaginationBloc<PrivateCoachPurchasePaginationModel> {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();
  ApiEvent event;

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;

  get eventSink => _eventSubject.sink;

  PrivateCoachPurchaseBloc() {
    eventStream.listen(_mapEventToState);
  }

  void _mapEventToState(ApiEvent event) {
    if (event is LoadPurchasedItemsEvent) {
      this.items(event.page, event.itemCount).then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    } else if (event is SearchPurchaseEvent) {
      _searchInner(event.startDate, event.endDate, event.query, event.page,
              event.itemCount,event.coachId)
          .then((result) {
        if (result.success) {
          _subject.sink.add(PaginationEvent(result));
        } else {
          _subject.sink.add(ApiFailedEvent(result.message));
        }
      });
    }
  }

  @override
  Future<PaginationModel> items(int page, int itemCount) async {
    if (_subject.isClosed) return null;
    if (this.event is LoadPurchasedItemsEvent)
      return this.purchasedItems(page, itemCount);
  }

  Future<PaginationModel> purchasedItems(int page, int itemCount) async {
    var userRepository = new PrivateCoachPurchasedItemsRepository();
    return userRepository.purchasedItems(page, itemCount);
  }

  void loadPurchasedItems(int page, int itemCount,{int coachId:0}) {
    this.event = LoadPurchasedItemsEvent(page, itemCount,coachId);
    _eventSubject.add(new LoadPurchasedItemsEvent(page, itemCount,coachId));
  }

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void dispose() {
    _subject.close();
    _eventSubject.close();
  }

  @override
  void refresh() {
    _subject.first.then((event) {
      _subject.sink.add(event);
    });
  }

  void search(
      String startDate, String endDate, String query, int page, int itemCount,{int coachId:0}) {
    _eventSubject.add(
        new SearchPurchaseEvent(startDate, endDate, query, page, itemCount,coachId));
  }

  Future<PaginationModel> _searchInner(String startDate, String endDate,
      String query, int page, int itemCount,int coachId) async {
    var userRepository = new PrivateCoachPurchasedItemsRepository();
    return userRepository.search(startDate,endDate,query, page, itemCount,coachId);
  }
}
