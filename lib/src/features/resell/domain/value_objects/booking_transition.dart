enum BookingTransition {
  cancel(0),
  confirm(1);

  const BookingTransition(this.value);
  final int value;
}
