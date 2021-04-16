import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/providers/pt/private_coach_purchased_items_provider.dart';

/*
This class is us
 */
class PrivateCoachPurchasedItemsRepository {
  var provider = PrivateCoachPurchaseItemsProvider();

  Future<PaginationModel> purchasedItems(int page, int itemCount) =>
      provider.purchasedItems(page, itemCount);

  Future<PaginationModel> search(String startDate, String endDate, String query,
          int page, int itemCount,int coachId) =>
      provider.search(startDate, endDate, query, page, itemCount,coachId);
}
