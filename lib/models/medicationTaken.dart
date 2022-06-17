enum Types { Morning, Afternoon, Evening, Night }

class MedicationTaken {
  final String id;
  final int taken;
  final String date;
  final String type;

  MedicationTaken(
      {required this.id,
      required this.taken,
      required this.type,
      required this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'taken': taken, 'date': date, 'type': type};
  }

  factory MedicationTaken.fromMap(Map<String, dynamic> json) => MedicationTaken(
        id: json['id'],
        taken: json['taken'],
        type: json['type'],
        date: json['date'],
      );

  @override
  String toString() {
    return 'Log{id: $id, title: $taken, type: $type , date: $date}';
  }
}
