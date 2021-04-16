import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressBarWave extends StatelessWidget {
  CustomProgressBarWave();

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: Colors.white,
      size: 100.0,
    );
  }
}
