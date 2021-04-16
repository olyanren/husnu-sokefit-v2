import 'package:crossfit/blocs/api_event.dart';
import 'package:crossfit/blocs/user/user_event.dart';
import 'package:crossfit/blocs/user/user_photo_bloc.dart';
import 'package:crossfit/themes/custom_progress_bar_wave.dart';
import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPhotoField extends BaseBlocScreen {
  final UserPhotoBloc _userPhotoBloc = new UserPhotoBloc();
  var photo;
  UserPhotoField([this.photo]);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiEvent>(
        stream: _userPhotoBloc.stream,
        builder: (BuildContext context, AsyncSnapshot<ApiEvent> snapshot) {
          if (snapshot.data is UploadPhotoEvent)
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomProgressBarWave(),
            );
          if(snapshot.data is UploadPhotoFinishedEvent)
            photo =(snapshot.data as UploadPhotoFinishedEvent).photo;
          return GestureDetector(
              onTap: () => updatePhoto(context),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: this.photo == null || this.photo.toString().isEmpty || this.photo.toString().startsWith('file:///')
                      ? Image.asset(
                    'assets/images/avatar.png',
                    height: 100,
                  )
                      : CircleAvatar(
                    radius: 80.0,
                    backgroundImage:
                    NetworkImage(this.photo),
                    backgroundColor: Colors.transparent,
                  )));
        });
  }

  @override
  void init(BuildContext context) {
    _userPhotoBloc.stream.listen((event) {
      showResult(context, event);
    });
  }

  @override
  void dispose() {
    _userPhotoBloc.dispose();
  }

  void updatePhoto(BuildContext context) async {
    var imagePicker = ImagePicker();
    var file = await imagePicker.getImage(source: ImageSource.camera);
    if (file == null) return;
    _userPhotoBloc.uploadPhoto(file.path);
  }
}
