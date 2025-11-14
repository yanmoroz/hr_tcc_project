enum ResellStatus {
  onSale(1),
  booked(2);

  const ResellStatus(this.value);
  final int value;

  static ResellStatus fromValue(int value) {
    return ResellStatus.values.firstWhere((e) => e.value == value);
  }
}
