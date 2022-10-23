import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medication_app/services.dart';

import 'package:uuid/uuid.dart';
import 'models/log.dart';

class LogsComplaintsPage extends StatefulWidget {
  const LogsComplaintsPage({Key? key}) : super(key: key);

  @override
  State<LogsComplaintsPage> createState() => Logs();
}

class Logs extends State<LogsComplaintsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Log>>(
          future: CreateDatabase.instance.GetComplaintLogs(),
          builder: (BuildContext context, AsyncSnapshot<List<Log>> snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('Geen klachten weer te geven'));
            } else {
              List<Log> logs = snapshot.data!.toList();
              return ListTileTheme(
                  tileColor: Colors.yellow,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: snapshot.data!.map((log) {
                      return Center(
                          child: Card(
                              child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: ((context) => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddOrEditLogWidget(
                                                        log: log)),
                                          ).then(onGoBack)
                                        }),
                                    backgroundColor: const Color(0xFFFF7435),
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                    label: 'Wijzig',
                                  ),
                                  SlidableAction(
                                    onPressed: ((context) => {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                      title: Text(
                                                          "Zeker dat je ${log.title} wil verwijderen?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    "Nee"),
                                                            child: const Text(
                                                                "Nee",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0))),
                                                        TextButton(
                                                            child: const Text(
                                                                "Ja",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0)),
                                                            onPressed: () {
                                                              setState(() {
                                                                Future<int>
                                                                    removed =
                                                                    CreateDatabase
                                                                        .instance
                                                                        .RemoveComplaintLog(
                                                                            log.id);
                                                                if (removed !=
                                                                    null) {
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              });
                                                            })
                                                      ]))
                                        }),
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Verwijder',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                style: Theme.of(context).listTileTheme.style,
                                leading: Icon(Icons.medication),
                                title: Text(log.title),
                                subtitle: Text(
                                    "${DateTime.parse(log.date).hour}:${DateTime.parse(log.date).minute < 10 ? "0${DateTime.parse(log.date).minute}" : "${DateTime.parse(log.date).minute}"} \t ${DateTime.parse(log.date).day}/${DateTime.parse(log.date).month}/${DateTime.parse(log.date).year}"),
                              ))
                        ],
                      )));
                    }).toList(),
                  ));
            }
          }),
    );
  }

  FutureOr onGoBack(dynamic value) {
    // update list after you add a product
    setState(() => {Logs()});
  }
}

class AddOrEditLogWidget extends StatefulWidget {
  AddOrEditLogWidget({Key? key, required this.log}) : super(key: key);
  Log log;
  @override
  AddOrEditLog createState() => AddOrEditLog(log);
}

class AddOrEditLog extends State<AddOrEditLogWidget> {
  final title = TextEditingController();
  Log? log;
  bool validation = false;
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  AddOrEditLog(Log log) {
    if (log.id.isNotEmpty) {
      pickedDate = DateTime.parse(log.date);
      pickedTime = TimeOfDay(hour: pickedDate.hour, minute: pickedDate.minute);
      title.text = log.title;
    } else {
      title.text = "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
          appBar: AppBar(
            title: widget.log.id.isEmpty
                ? const Text('Voeg klacht toe')
                : const Text('Wijzig klacht'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
          ),
          body: Column(
            children: <Widget>[
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                    icon: const Icon(Icons.local_drink),
                    hintText: 'Klacht',
                    labelText: 'Klacht',
                    errorText: validation ? "Vul een klacht in" : null),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 16.0)),
                    child: const Text("Kies datum"),
                    onPressed: () async {
                      showDatePicker(
                              context: context,
                              initialDate: pickedDate,
                              firstDate: DateTime(DateTime.now().year - 20),
                              lastDate: DateTime(DateTime.now().year + 10))
                          .then((date) {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (date == null) {
                            return;
                          } else {
                            pickedDate = date;
                            pickedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute);
                          }
                        });
                      });
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 16.0)),
                    child: const Text("Kies uur"),
                    onPressed: () async {
                      showTimePicker(
                        context: context,
                        initialTime: pickedTime,
                      ).then((time) {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (time == null) {
                            return;
                          } else {
                            pickedTime = time;
                            pickedDate = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute);
                          }
                          ;
                          print(time);
                        });
                      });
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: Text(
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} \t ${pickedTime.hour}:${pickedTime.minute < 10 ? "0" + pickedTime.minute.toString() : pickedTime.minute}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var uuid = Uuid();
                  if (title.text.isNotEmpty) {
                    if (widget.log.id.isNotEmpty) {
                      await CreateDatabase.instance.UpdateComplaintLog(Log(
                          id: widget.log.id,
                          title: title.text,
                          date: pickedDate.toString()));
                    } else {
                      await CreateDatabase.instance.AddComplaintLog(Log(
                        id: uuid.v4(),
                        title: title.text,
                        date: pickedDate.toString(),
                      ));
                    }
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      validation = true;
                    });
                  }
                },
                child: widget.log.id.isEmpty
                    ? const Text('Voeg toe')
                    : const Text('Wijzig'),
              ),
            ],
          )),
    );
  }
}
