

class PinCodeState{
  final bool isSuccess;
  final bool isPinSet;
  final bool isLoading;
  final bool isError;

  PinCodeState({
    required this.isSuccess,
    required this.isPinSet,
    required this.isLoading,
    required this.isError,
  });

  factory PinCodeState.initial(){
    return PinCodeState(
        isSuccess: false,
        isPinSet: false,
        isLoading: true,
        isError: false,
    );
  }

  PinCodeState copyWith({
    bool? isSuccess,
    bool? isPinSet,
    bool? isLoading,
    bool? isError
  }){
    return PinCodeState(
        isSuccess: isSuccess ?? this.isSuccess,
        isPinSet: isPinSet   ?? this.isPinSet,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError
    );
  }
}