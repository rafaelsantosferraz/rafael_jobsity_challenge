import 'package:rafael_jobsity_challenge/data/datasources/local/pin_code_local_datasource.dart';
import 'package:rafael_jobsity_challenge/domain/repositories_interfaces/pin_code_repository_interface.dart';

class PinCodeRepository implements PinCodeRepositoryInterface{

  final PinCodeLocalDataSource pinCodeLocalDataSource;

  PinCodeRepository(this.pinCodeLocalDataSource);

  @override
  Future<String?> getPinCode() async {
    return pinCodeLocalDataSource.getPinCode();
  }

  @override
  Future setPinCode(String pin) async {
    await pinCodeLocalDataSource.setPinCode(pin);
  }
}