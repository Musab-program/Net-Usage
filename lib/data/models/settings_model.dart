/// Model representing application settings.
class SettingsModel {
  /// Unique ID for the settings record (usually 1).
  final int id;

  /// The cost per gigabyte of data.
  final double gigabytePrice;

  SettingsModel({this.id = 1, required this.gigabytePrice});

  /// Converts the model to a map for database storage.
  Map<String, dynamic> toMap() {
    return {'id': id, 'gigabytePrice': gigabytePrice};
  }

  /// Creates a [SettingsModel] from a map.
  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'] as int,
      gigabytePrice: map['gigabytePrice'] as double,
    );
  }
}
