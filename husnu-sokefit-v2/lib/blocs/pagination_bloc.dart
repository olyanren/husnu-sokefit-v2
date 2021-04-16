import 'package:sokefit/models/pagination_model.dart';

abstract class PaginationBloc<T> {
  Future<PaginationModel> items(int page,int itemCount);
  void dispose();
}