import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/providers/pt/private_admin_private_register_provider.dart';

/*
This class is us
 */
class PrivateAdminPrivateRegisterRepository {
  var provider = PrivateAdminPrivateRegisterProvider();

  Future<PaginationModel> search(String query, int page, int itemCount) =>
      provider.search(query, page, itemCount);
}
