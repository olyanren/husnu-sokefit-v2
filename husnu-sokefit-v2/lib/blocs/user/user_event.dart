import 'package:sokefit/blocs/api_event.dart';

class UploadPhotoEvent extends ApiEvent{
  String path;
  UploadPhotoEvent(this.path);
}
class UploadPhotoFinishedEvent extends ApiEvent{
  String photo;
  UploadPhotoFinishedEvent(this.photo);
}

class StartScoreUpdateEvent extends ApiEvent{
  int scoreId;
  String value;
  StartScoreUpdateEvent(this.scoreId,this.value);
}

class ScoreUpdateFinishedEvent extends ApiFinishedEvent{
  ScoreUpdateFinishedEvent(String message) : super(message);
}

class LoadPassiveUsersEvent extends ApiEvent{
  int page;
  int itemCount;
  LoadPassiveUsersEvent(this.page,this.itemCount);
}
class LoadActiveUsersEvent extends ApiEvent{
  int page;
  int itemCount;
  LoadActiveUsersEvent(this.page,this.itemCount);
}
class LoadPrivateUsersEvent extends ApiEvent{

}
class SearchPassiveUsersEvent extends ApiEvent{
  String query;
  int page;
  int itemCount;
  SearchPassiveUsersEvent(this.query,this.page,this.itemCount);
}
class SearchActiveUsersEvent extends ApiEvent{
  String query;
  int page;
  int itemCount;
  SearchActiveUsersEvent(this.query,this.page,this.itemCount);
}

class FreezeAccountEvent extends ApiEvent{

}