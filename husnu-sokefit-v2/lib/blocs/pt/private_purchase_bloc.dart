import 'package:sokefit/blocs/api_event.dart';
import 'package:sokefit/blocs/bloc.dart';
import 'package:sokefit/blocs/pt/private_purchase_event.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/models/pt/purchase_pagination_model.dart';
import 'package:sokefit/repositories/pt/private_purchased_item_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../pagination_bloc.dart';

class PrivatePurchaseBloc extends BaseBloc
    implements PaginationBloc<PrivatePurchasePaginationModel> {
  var _subject = BehaviorSubject<ApiEvent>();
  var _eventSubject = BehaviorSubject<ApiEvent>();
  ApiEvent event;

  get stream => _subject.stream;

  get eventStream => _eventSubject.stream;

  get eventSink => _eventSubject.sink;

  PrivatePurchaseBloc() {
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
    }
  }

  @override
  Future<PaginationModel> items(int page, int itemCount) async {
    if (_subject.isClosed) return null;
    if (this.event is LoadPurchasedItemsEvent)
      return this.purchasedItems(page, itemCount, (this.event as LoadPurchasedItemsEvent).userId);
  }

  Future<PaginationModel> purchasedItems(
      int page, int itemCount, int userId) async {
    var userRepository = new PrivatePurchasedItemsRepository();
    return userRepository.purchasedItems(page, itemCount, userId);
  }

  void loadPurchasedItems(int page, int itemCount, {int userId = 0}) {
    this.event = LoadPurchasedItemsEvent(page, itemCount, userId);
    _eventSubject.add(new LoadPurchasedItemsEvent(page, itemCount, userId));
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
}
