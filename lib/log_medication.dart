import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medication_app/models/medicationTaken.dart';
import 'package:medication_app/services.dart';
import 'package:intl/intl.dart';

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
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          children: logs.map((log) {
                            return Center(
                                child: Card(
                                    child: Column(
                              children: <Widget>[
                                Slidable(
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: ((context) => {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                  title: Text(
                                                                      "Zeker dat je ${log.type} wil verwijderen?"),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            "Nee"),
                                                                        child: const Text(
                                                                            "Nee",
                                                                            style:
                                                                                TextStyle(fontSize: 16.0))),
                                                                    TextButton(
                                                                        child: const Text(
                                                                            "Ja",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    16.0)),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            Future<int>
                                                                                removed =
                                                                                CreateDatabase.instance.RemoveMedicationTakenLog(log.id);
                                                                            if (removed !=
                                                                                null) {
                                                                              Navigator.pop(context);
                                                                            }
                                                                          });
                                                                        })
                                                                  ]))
                                                }),
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Verwijder',
                                          )
                                        ]),
                                    child: ListTile(
                                        leading: Icon(Icons.medication),
                                        title: Text(DateFormat(
                                                "dd-MM-yyyy HH:mm:ss")
                                            .format(DateTime.parse(log.date))),
                                        subtitle: Text(log.type.toString())))
                              ],
                            )));
                          }).toList(),
                        ));
                      }
                    }))));
  }
}
