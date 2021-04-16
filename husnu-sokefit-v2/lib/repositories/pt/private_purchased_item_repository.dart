import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/providers/pt/private_purchased_items_provider.dart';

/*
This class is us
 */
class PrivatePurchasedItemsRepository {
  var provider = PrivatePurchaseItemsProvider();

  Future<PaginationModel> purchasedItems(int page, int itemCount,int userId)=> provider.purchasedItems(page,itemCount,userId);


}
