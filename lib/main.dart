import 'package:flutter/material.dart';
import 'package:medication_app/check_medication.dart';
import 'package:medication_app/log_complaints.dart';
import 'package:medication_app/log_medication.dart';

import 'models/log.dart';
import 'log_complaints.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const Medication(),
    );
  }
}

class Medication extends StatefulWidget {
  const Medication({Key? key}) : super(key: key);

  @override
  State<Medication> createState() => _NavigationState();
}

// page to thick if you took your medication
class _NavigationState extends State<Medication> {
  int currentPage = 0;
  List<String> titles = ["Medication check", "Logs"];
  List<Widget> pages = [
    const CheckMedicationPage(),
    const LogsComplaintsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            titles[currentPage],
          ),
          actions: <Widget>[
            Visibility(
              // if page logs is clicked (index 1), show add icon in appbar
              visible: currentPage == 0 ? true : false,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(Icons.menu),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogsMedicationPage()),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              // if page logs is clicked (index 1), show add icon in appbar
              visible: currentPage == 1 ? true : false,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(Icons.add),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrEditLogWidget(
                                log: Log(
                                    id: "",
                                    date: DateTime.now().toString(),
                                    title: ""),
                              )),
                    );
                  },
                ),
              ),
            ),
          ]),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.medication), label: 'Checker'),
          NavigationDestination(
            icon: Icon(Icons.menu),
            label: 'logs',
          ),
        ],
        onDestinationSelected: (int index) => {
          setState(() {
            currentPage = index;
          })
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
