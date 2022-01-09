import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/pin_code/pin_code_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/pin_code/widgets/pin_put.dart';

import 'pin_code_state.dart';

class PinCodeDialog extends StatelessWidget {

  final PinCodeController _pinCodeController;
  late final BuildContext _context;

  PinCodeDialog({Key? key}) :
        _pinCodeController = PinCodeController(),
        super(key: key){
    _pinCodeController.state.listen(onStateChange);
  }

  void onStateChange(PinCodeState state){
    if(state.isSuccess){
      Navigator.of(_context).pop();
    }
    _isLoading.value = state.isLoading;
    _isPinSet.value  = state.isPinSet;
  }

  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<bool> _isPinSet  = ValueNotifier(false);
  final ValueNotifier<bool> _isReadyToSetPin  = ValueNotifier(false);


  @override
  Widget build(BuildContext context) {
    _context = context;
    var pin = '';
    return WillPopScope(
      onWillPop: () async {
        _pinCodeController.close();
        return true;
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Builder(
            builder: (context) {
              return GestureDetector(
                  onTap: () {},
                  child: const DialogBackground()
              );
            }
          ),
           Center(
            child: ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Material(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)
                    ),
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _isPinSet,
                        builder: (context, _isPinSet, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if(!_isPinSet)...[
                                Container(
                                  height: 120,
                                  padding: const EdgeInsets.all(kDefaultPadding),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                                    color: Colors.green,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.lock, color: Colors.white,),
                                      kVerticalGap,
                                      Text(
                                        'Create your PIN',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                                      color: kBackgroundColor
                                  ),
                                  child: PinPut(
                                    autofocus: true,
                                    fieldsCount: 4,
                                    textStyle: const TextStyle(
                                      fontSize: 24,
                                      color: kTextLightColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    onChanged: (inputPin) {
                                      pin = inputPin;
                                      _onSetPin(pin);
                                    },
                                    pinAnimationType: PinAnimationType.scale,
                                    eachFieldWidth:  32,
                                    eachFieldHeight: 56,
                                    eachFieldMargin: const EdgeInsets.all(8),
                                    fieldsAlignment: MainAxisAlignment.center,
                                    separator: const SizedBox(),
                                    inputDecoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 40),
                                        border: InputBorder.none,
                                        counterText: ""

                                    ),
                                    selectedFieldDecoration:  const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    followingFieldDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    submittedFieldDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isReadyToSetPin,
                                  builder: (context, _isReadyToSetPin, _) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            if(_isReadyToSetPin){
                                              _onSetPinDone(pin);
                                            }
                                          },
                                          child: Text(
                                            'Done',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: _isReadyToSetPin ? Colors.green : Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                kVerticalGap,
                                kVerticalGap,

                              ] else ...[
                                Container(
                                  height: 120,
                                  padding: const EdgeInsets.all(kDefaultPadding),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                                    color: Colors.deepOrange,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Icon(Icons.lock, color: Colors.white,),
                                      kVerticalGap,
                                      Text(
                                        'Enter your PIN',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                                      color: kBackgroundColor
                                  ),
                                  child: PinPut(
                                    obscureText: '*',
                                    autofocus: true,
                                    fieldsCount: 4,
                                    textStyle: const TextStyle(
                                      fontSize: 24,
                                      color: kTextLightColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    onChanged: (pin) => _pinCodeController.addEvent(PinCodeEvent.checkPin(pin)),
                                    pinAnimationType: PinAnimationType.scale,
                                    eachFieldWidth:  32,
                                    eachFieldHeight: 56,
                                    eachFieldMargin: const EdgeInsets.all(8),
                                    fieldsAlignment: MainAxisAlignment.center,
                                    separator: const SizedBox(),
                                    inputDecoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 40),
                                        border: InputBorder.none,
                                        counterText: ""

                                    ),
                                    selectedFieldDecoration:  const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    followingFieldDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    submittedFieldDecoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.rectangle,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: kTextLightColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                kVerticalGap,
                              ]

                            ],
                          );
                        }
                    ),
                  ),
                ),
                builder: (context, _isLoading, child) {
                return _isLoading ? const CircularProgressIndicator() : child!;
              }
            ),
          ),
        ],
      ),
    );
  }

  //region Private -------------------------------------------------------------
  void _onSetPin(String pin) {
    if(pin.length == 4){
      _isReadyToSetPin.value = true;
    } else {
      _isReadyToSetPin.value = false;
    }
  }

  void _onSetPinDone(String pin){
    _pinCodeController.addEvent(PinCodeEvent.setPint(pin));
  }
  //endregion
}

class DialogBackground extends StatelessWidget {
  const DialogBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRect(
          child: SizedBox(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height ,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                color: Colors.white.withOpacity(.5),
              ),
            ),
          ),
        )
    );
  }
}

