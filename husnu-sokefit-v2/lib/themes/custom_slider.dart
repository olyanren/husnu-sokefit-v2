import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  double value;
  ValueChanged<double> onChanged;
  double min;
  double max;
  int multiply;

  CustomSlider(this.value, this.onChanged, this.min, this.max,
      {this.multiply = 0});

  @override
  State<StatefulWidget> createState() => _InnerState(
      this.value, this.onChanged, this.min, this.max, this.multiply);
}

class _InnerState extends State<CustomSlider> {
  double _value;
  ValueChanged<double> onChanged;
  double min;
  double max;
  int multiply;

  _InnerState(this._value, this.onChanged, this.min, this.max, this.multiply);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
          value: _value,
          onChanged: this.onChangedEvent,
          min: this.min,
          max: this.max),
    );
  }

  void onChangedEvent(value) {
    setState(() {
      if (this.multiply == 0)
        this._value = value;
      else
        this._value =
            value.roundToDouble() - value.roundToDouble() % this.multiply;
    });
    onChanged(this._value);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx + 10;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 10;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
