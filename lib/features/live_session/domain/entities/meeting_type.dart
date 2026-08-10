enum MeetingType {
  zoom('zoom'),
  googleMeet('googleMeet');
  const MeetingType(this.value);

  final String value;

  static MeetingType fromValue(String value) {
    return MeetingType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError.value(value),
    );
  }
}