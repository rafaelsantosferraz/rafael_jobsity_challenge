import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeLocalDataSource {

  final _storage = const FlutterSecureStorage();
  final String _pinCodeKey = 'pin_code';

  Future<String?> getPinCode() async {
    return _storage.read(key: _pinCodeKey,
      aOptions: _aOptions);
  }

  Future setPinCode(String pin) async {
    await _storage.write(key: _pinCodeKey, value: pin, aOptions: _aOptions);
  }

  AndroidOptions get _aOptions => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

}