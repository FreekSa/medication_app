import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medication_app/models/medicationTaken.dart';
import 'package:medication_app/services.dart';

class LogsMedicationPage extends StatefulWidget {
  const LogsMedicationPage({Key? key}) : super(key: key);

  @override
  State<LogsMedicationPage> createState() => LogsMedication();
}

class LogsMedication extends State<LogsMedicationPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.amber),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("logs"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context)),
            ),
            body: Center(
                child: FutureBuilder<List<MedicationTaken>>(
                    future: CreateDatabase.instance.GetMedicationTakenLogs(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<MedicationTaken>> snapshot) {
                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(child: Text('Geen logs weer te geven'));
                      } else {
                        List<MedicationTaken> logs = snapshot.data!.toList();
                        return ListTileTheme(
                            child: ListView(
                          children: snapshot.data!.map((log) {
                            return Center(
                                child: Card(
                                    child: Column(
                              children: <Widget>[
                                ListTile(title: Text(log.date))
                              ],
                            )));
                          }).toList(),
                        ));
                      }
                    }))));
  }
}
