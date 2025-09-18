class SettingsModel {
  final int id;
  final double gigabytePrice;

  SettingsModel({
    this.id = 1,
    required this.gigabytePrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gigabytePrice': gigabytePrice,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'] as int,
      gigabytePrice: map['gigabytePrice'] as double,
    );
  }
}   