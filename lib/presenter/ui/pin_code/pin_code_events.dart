part of 'pin_code_controller.dart';

class PinCodeEvent {

  PinCodeEvent._();

  factory PinCodeEvent.checkPin(String pin) = _PinTextEvent;
  factory PinCodeEvent.setPint(String pin) = _SetPinTextEvent;
  factory PinCodeEvent.start() = _StartEvent;
}
class _StartEvent extends PinCodeEvent {
  _StartEvent():super._();
}

class _PinTextEvent extends PinCodeEvent {
  final String text;
  _PinTextEvent(this.text):super._();
}

class _SetPinTextEvent extends PinCodeEvent {
  final String text;
  _SetPinTextEvent(this.text):super._();
}