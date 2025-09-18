class UserModel {
  final int? id;
  final String name;
  final double remainingBalance;

  UserModel({
    this.id,
    required this.name,
    this.remainingBalance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'remainingBalance': remainingBalance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      remainingBalance: map['remainingBalance'] as double,
    );
  }
}