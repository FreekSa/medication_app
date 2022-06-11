class MedicationTaken {
  final String id;
  final int taken;
  final String date;

  MedicationTaken({required this.id, required this.taken, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taken': taken,
      'date': date,
    };
  }

  factory MedicationTaken.fromMap(Map<String, dynamic> json) => MedicationTaken(
        id: json['id'],
        taken: json['taken'],
        date: json['date'],
      );

  @override
  String toString() {
    return 'Log{id: $id, title: $taken, date: $date}';
  }
}
