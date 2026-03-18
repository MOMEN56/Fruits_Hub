part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.orderInput,
    required this.currentStepIndex,
    required this.addressAutovalidateMode,
  });

  static const int lastStepIndex = 2;

  final OrderInputEntity orderInput;
  final int currentStepIndex;
  final AutovalidateMode addressAutovalidateMode;

  factory CheckoutState.initial({
    required CartEntity cartEntity,
    required String userId,
  }) {
    return CheckoutState(
      orderInput: OrderInputEntity(
        cartEntity,
        userId: userId,
        shippingAddressEntity: const ShippingAddressEntity(),
      ),
      currentStepIndex: 0,
      addressAutovalidateMode: AutovalidateMode.disabled,
    );
  }

  bool get canContinueFromShipping => orderInput.hasSelectedPaymentMethod;

  bool get isLastStep => currentStepIndex == lastStepIndex;

  String get nextButtonText {
    if (!isLastStep) {
      return S.current.next;
    }
    return orderInput.nextActionLabel;
  }

  CheckoutState copyWith({
    OrderInputEntity? orderInput,
    int? currentStepIndex,
    AutovalidateMode? addressAutovalidateMode,
  }) {
    return CheckoutState(
      orderInput: orderInput ?? this.orderInput,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      addressAutovalidateMode:
          addressAutovalidateMode ?? this.addressAutovalidateMode,
    );
  }

  @override
  List<Object?> get props => [
    orderInput,
    currentStepIndex,
    addressAutovalidateMode,
  ];
}
