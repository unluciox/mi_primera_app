import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SchedulePage(),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  final List<String> days = [
    "lunes",
    "martes",
    "miercoles",
    "jueves",
    "viernes"
  ];

  Map<String, dynamic> schedule = {};

  /// GENERa horas
  List<Map<String, String>> generateHours() {
    List<Map<String, String>> hours = [];

    for (int i = 7; i <= 21; i++) {

      String start = "${i.toString().padLeft(2, '0')}:00";
      String end = "${i.toString().padLeft(2, '0')}:59";

      hours.add({
        "key": start,
        "label": "$start - $end"
      });
    }

    return hours;
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  /// CARGA JSON
  Future<void> loadJson() async {

    final String data =
        await rootBundle.loadString('assets/schedule.json');

    setState(() {
      schedule = jsonDecode(data);
    });
  }

  @override
  Widget build(BuildContext context) {

    final hours = generateHours();

    return Scaffold(
      appBar: AppBar(title: const Text("Horario")),
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    /// HEADER
                    Row(
                      children: [
                        const SizedBox(width: 100),

                        ...days.map((day) => Container(
                              width: 150,
                              height: 50,
                              alignment: Alignment.center,
                              color: Colors.blue.shade200,
                              child: Text(
                                day.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),

                    /// BODY
                    ...hours.map((hourData) {

                      String hourKey = hourData["key"]!;
                      String hourLabel = hourData["label"]!;

                      return Row(
                        children: [

                          /// HORAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                          Container(
                            width: 100,
                            height: 80,
                            alignment: Alignment.center,
                            color: Colors.grey.shade300,
                            child: Text(hourLabel),
                          ),

                          /// CELDAS
                          ...days.map((day) {

                            String text = "";

                            if (schedule[day] != null &&
                                schedule[day][hourKey] != null) {
                              text = schedule[day][hourKey];
                            }

                            return Container(
                              width: 150,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                              ),
                            );
                          })

                        ],
                      );
                    })

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}