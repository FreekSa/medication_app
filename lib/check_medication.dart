import 'package:flutter/material.dart';
import 'package:medication_app/main.dart';
import 'package:medication_app/models/medicationTaken.dart';
import 'package:medication_app/services.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class CheckMedicationPage extends StatefulWidget {
  const CheckMedicationPage({Key? key}) : super(key: key);

  @override
  State<CheckMedicationPage> createState() => CheckMedication();
}

class CheckMedication extends State<CheckMedicationPage> {
  MedicationTaken check = MedicationTaken(
      id: "", taken: 1, type: Types.Morning.toString(), date: "");
  List<MedicationTaken> checks = <MedicationTaken>[];
  List<MedicationTaken> filteredList = <MedicationTaken>[];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<List<MedicationTaken>>(
            future: CreateDatabase.instance.GetMedicationTakenLogs(),
            builder: (BuildContext context,
                AsyncSnapshot<List<MedicationTaken>> snapshot) {
              //           print(snapshot.data);
              bool morning = true;
              bool evening = true;
              if (snapshot.hasData) {
                print(snapshot.data);
                if (snapshot.data!
                        .where((x) =>
                            DateTime.parse(x.date).day == DateTime.now().day)
                        .length <
                    2) {
                  print(snapshot.data!
                      .where((x) =>
                          DateTime.parse(x.date).day == DateTime.now().day &&
                          x.type == Types.Morning.toString())
                      .isEmpty);
                  print("nog geen 2x medicatie genomen");
                  print(snapshot.data!
                          .where((x) =>
                              DateTime.parse(x.date).day ==
                                  DateTime.now().day &&
                              x.type == Types.Morning.toString())
                          .isEmpty
                      ? true
                      : false);
                  morning = snapshot.data!
                          .where((x) =>
                              DateTime.parse(x.date).day ==
                                  DateTime.now().day &&
                              x.type == Types.Morning.toString())
                          .isEmpty
                      ? true
                      : false;
                  evening = snapshot.data!
                          .where((x) =>
                              DateTime.parse(x.date).day ==
                                  DateTime.now().day &&
                              x.type == Types.Evening.toString())
                          .isEmpty
                      ? true
                      : false;
                } else if (snapshot.data!
                        .where((x) =>
                            DateTime.parse(x.date).day == DateTime.now().day)
                        .length >=
                    2) {
                  List<MedicationTaken> logs = snapshot.data!.toList();
                  return Column(children: [
                    Container(
                      height: 100,
                      color: Colors.red,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            for (var item in snapshot.data!) {
                              print(item.id +
                                  "  " +
                                  item.date +
                                  "  " +
                                  item.type.toString());
                            }
                          },
                          child: const Text("Show data in database"),
                        ),
                      ),
                    ),
                    Center(child: Text('Medication taken for today'))
                  ]);
                }
                //    print("null safety");
              }
              return AskMedication(morning, evening);
              // return this widget
            }));
  }

  Widget AskMedication(
    bool morning,
    bool evening,
  ) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 100.0),
          child: Text(
              "${DateTime.now().hour}:${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"} \t ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
        ),
        Center(
          child: TextButton(
            child: Text("toon iets"),
            onPressed: () {
              print(morning);
              print(evening);
              ;
            },
          ),
        ),
        Expanded(
          child: Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: morning,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          var uuid = Uuid();
                          check = MedicationTaken(
                              id: uuid.v4(),
                              taken: 1,
                              type: Types.Morning.toString(),
                              date: DateTime.now().toString());
                          if (check != null) {
                            CreateDatabase.instance
                                .AddMedicationTakenLog(check);
                            print("data added");
                            morning = false;
                          }
                        });
                      },
                      child: const Text("Morning meds taken"),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Visibility(
                  visible: evening,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          var uuid = Uuid();
                          check = MedicationTaken(
                              id: uuid.v4(),
                              taken: 1,
                              type: Types.Evening.toString(),
                              date: DateTime.now().toString());
                          if (check != null) {
                            CreateDatabase.instance
                                .AddMedicationTakenLog(check);
                            print("data added");
                            evening = false;
                          }
                        });
                      },
                      child: const Text("Evening meds taken"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
