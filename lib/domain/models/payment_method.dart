enum PaymentMethod { cash, transfer, mixed }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Efectivo',
        PaymentMethod.transfer => 'Transfer/QR',
        PaymentMethod.mixed => 'Mixto',
      };
}
