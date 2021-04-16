
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomStepper extends StatefulWidget {
  List<Step> _steps;
  List<GlobalKey<FormState>> _formKeys = [];
  Function _submit;
  String _submitText;
  Color submitColor;
  Color nextColor;
  Color cancelColor;

  CustomStepper(this._steps, this._submitText, this._submit,
      {this.submitColor, this.nextColor, this.cancelColor}) {
    var i = 0;
    for (Step o in this._steps) {
      var key = GlobalKey<FormState>();
      _formKeys.add(key);
      var formWidget = new Form(key: key, child: o.content);

      if(i==0){
        this._steps[i] = new Step(title: o.title, content: formWidget,state: StepState.editing);
      }else{
        this._steps[i] = new Step(title: o.title, content: formWidget,state: StepState.disabled);
      }
      i++;
    }
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomStepperState(
        this._steps, this._formKeys, this._submitText, this._submit,
        submitColor: this.submitColor);
  }
}

class _CustomStepperState extends State<CustomStepper> {
  int _currentStep = 0;
  List<Step> _steps;
  List<GlobalKey<FormState>> _formKeys = [];
  Function _submit;
  String _submitText;
  Color submitColor;
  Color nextColor;
  Color cancelColor;

  _CustomStepperState(
      this._steps, this._formKeys, this._submitText, this._submit,
      {this.submitColor, this.nextColor, this.cancelColor});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return getStepper();
  }

  getStepper() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Expanded(
        child: Stepper(
          steps: _steps,
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            this.next(context);
          },
          onStepTapped: (step) => goTo(step),
          onStepCancel: cancel,
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => next(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _currentStep == _steps.length - 1
                            ? submitColor ?? Colors.black
                            : this.nextColor ?? Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          _currentStep == _steps.length - 1
                              ? this._submitText
                              : 'DEVAM ET',
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => this.cancel(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: this.cancelColor ?? Colors.red.shade800,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CustomText(
                          'İPTAL',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  next(BuildContext context) {
    if (_formKeys[_currentStep].currentState.validate()) {
      this._steps[_currentStep] = new Step(
          title: _steps[_currentStep].title,
          content: _steps[_currentStep].content,
          state: StepState.complete);

      _currentStep + 1 != _steps.length
          ? goTo(_currentStep + 1)
          : this._submit();
    }
  }

  cancel() {
    if (_currentStep > 0) {

      goTo(_currentStep - 1);
    }
    //_merchantRegisterBloc.refresh();
  }

  goTo(int step) {
    setState(() {
      _currentStep = step;

      this._steps[step] = new Step(
          title: _steps[step].title,
          content: _steps[step].content,
          state: StepState.editing);
    });
  }
}
