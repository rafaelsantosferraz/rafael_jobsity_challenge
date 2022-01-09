abstract class PinCodeRepositoryInterface {
  Future<String?> getPinCode();
  Future setPinCode(String pin);
}