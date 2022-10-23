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
              if (snapshot.data == null ||
                  snapshot.data!
                          .where((x) =>
                              DateTime.parse(x.date).day == DateTime.now().day)
                          .length >=
                      2) {
                return Column(children: [
                  // Container(
                  //   height: 100,
                  //   color: Colors.red,
                  //   child: Center(
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         for (var item in snapshot.data!) {
                  //           print(item.id +
                  //               "  " +
                  //               item.date +
                  //               "  " +
                  //               item.type.toString());
                  //         }
                  //       },
                  //       child: const Text("Show data in database"),
                  //     ),
                  //   ),
                  // ),
                  Center(child: Text('Medication taken for today'))
                ]);
              } else {
                return Column(
                  children: [
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
                    Container(
                      margin: EdgeInsets.only(top: 100.0),
                      child: Text(
                          "${DateTime.now().hour}:${DateTime.now().minute < 10 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"} \t ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                    ),
                    Expanded(
                      child: Visibility(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: snapshot.data!
                                      .where((x) =>
                                          DateTime.parse(x.date).day ==
                                              DateTime.now().day &&
                                          x.type == Types.Morning.toString())
                                      .isEmpty
                                  ? true
                                  : false,
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
                              visible: snapshot.data!
                                      .where((x) =>
                                          DateTime.parse(x.date).day ==
                                              DateTime.now().day &&
                                          x.type == Types.Evening.toString())
                                      .isEmpty
                                  ? true
                                  : false,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      var filteredList = snapshot.data!.where(
                                          (x) =>
                                              DateTime.parse(x.date).day ==
                                              DateTime.now().day);
                                      if (filteredList.isNotEmpty) {
                                        var uuid = Uuid();
                                        check = MedicationTaken(
                                            id: uuid.v4(),
                                            taken: 1,
                                            type: Types.Evening.toString(),
                                            date: DateTime.now().toString());
                                        if (check.id.isNotEmpty) {
                                          CreateDatabase.instance
                                              .AddMedicationTakenLog(check);
                                        }
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
            }));
  }

  Future<bool> CheckIfMedsTakenToday() async {
    List<MedicationTaken> list =
        await CreateDatabase.instance.GetMedicationTakenLogs();
    if (list
            .where((x) => DateTime.parse(x.date).day == DateTime.now().day)
            .length >
        2) {
      return false;
    } else {
      return true;
    }
  }
}
