abstract class ActivationEvent {}

class VerifyActivation extends ActivationEvent {
  final String code;
  VerifyActivation(this.code);
}

class ResendActivation extends ActivationEvent {
  final String email;
  ResendActivation(this.email);
}
