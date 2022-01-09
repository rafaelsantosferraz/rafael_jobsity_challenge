import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rafael_jobsity_challenge/data/datasources/local/pin_code_local_datasource.dart';
import 'package:rafael_jobsity_challenge/data/repositories/pin_code_repository.dart';
import 'package:rafael_jobsity_challenge/domain/entities/pin_code.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/pin_code/pin_code_state.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

part 'pin_code_events.dart';

class PinCodeController {

  final PinCode pinCode;

  PinCodeController():
    pinCode = PinCode(PinCodeRepository(PinCodeLocalDataSource())),
    super(){
    _update(currentState);
    addEvent(PinCodeEvent.start());
  }

  final StreamController<PinCodeState> _stateStreamController = StreamController();
  Stream<PinCodeState> get state => _stateStreamController.stream;
  PinCodeState _currentState = PinCodeState.initial();
  PinCodeState get currentState => _currentState;


  ///Check if pop dialog was already call
  bool isPop = false;

  //region Public --------------------------------------------------------------
  addEvent(PinCodeEvent event){
    _onEvent(event);
  }

  close(){
    _stateStreamController.close();
  }
  //endregion

  //region Private -------------------------------------------------------------
  Future _onEvent(PinCodeEvent event) async {
    switch(event.runtimeType){
      case _StartEvent: await _onStartEvent(event as _StartEvent);
      break;
      case _PinTextEvent: await _onPinCodeTextEvent(event as _PinTextEvent);
      break;
      case _SetPinTextEvent: await _onSetPinTextEvent(event as _SetPinTextEvent);
      break;
      default: throw Exception('Event ${event.runtimeType} not process');
    }
  }

  _onStartEvent(_StartEvent event) async {
    bool isPinSet = await pinCode.checkPin('') != null;
    _update(currentState.copyWith(isPinSet: isPinSet, isLoading: false));
    if(isPinSet){
      _checkFingerPrint();
    }
  }

  _onPinCodeTextEvent(_PinTextEvent event) async {
    if(event.text.length == 4){
      var isValid = (await pinCode.checkPin(event.text))!;
      if(isValid && !isPop){
        isPop = true;
        _update(currentState.copyWith(isSuccess: true));
      }
    }
  }

  _onSetPinTextEvent(_SetPinTextEvent event) async {
    if(event.text.length == 4 && !isPop){
        try {
          await pinCode.setPinCode(event.text);
          isPop = true;
          _update(currentState.copyWith(isSuccess: true));
        } catch (e, s){
          print(e);
          print(s);
          _update(currentState.copyWith(isError: true));
          _update(currentState.copyWith(isError: false));
        }
    }
  }

  _checkFingerPrint() async {
    var localAuth = LocalAuthentication();
    if(await localAuth.canCheckBiometrics) {
      try {
        bool didAuthenticate = await localAuth.authenticate(
            localizedReason: 'Cancel to use pin code instead',
            useErrorDialogs: false,
            biometricOnly: true
        );
        if(didAuthenticate){
          _update(currentState.copyWith(isSuccess: true));
        }
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          print('No');
        }
      }
    }
  }

  _update(PinCodeState state) {
    _currentState  = state;
    _stateStreamController.sink.add(state);
  }
  //endregion
}