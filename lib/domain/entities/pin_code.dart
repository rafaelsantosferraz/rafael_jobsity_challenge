import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/pin_code_repository_interface.dart';

class PinCode {

  final PinCodeRepositoryInterface pinCodeRepository;

  PinCode(this.pinCodeRepository);

  Future<bool?> checkPin(String input) async {
    var pinCode = await pinCodeRepository.getPinCode();
    if(pinCode == null){
      return null;
    }
    return input == pinCode;
  }

  Future setPinCode(String pinCode) {
    return pinCodeRepository.setPinCode(pinCode);
  }
}