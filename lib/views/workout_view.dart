/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5

import 'package:flutter/material.dart';
import 'package:sweatpals/views/taskadd_view.dart';


/// Workout Page 
class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  WorkoutViewState createState() => WorkoutViewState();
}

/// Workout Page Background 
class WorkoutViewState extends State<WorkoutView> {
  /// List View Item Value
  int ListViewItemNumber = 0;
  /// List of Detail 
  List<List<dynamic>> listitem = [];
  ///  A copied of [listitem] 
  List<List<dynamic>> copiedList = [];
  /// Checking Start button Statue
  bool boolstartbutton = false;
  /// Count number of Button press
  int count = 0;

  /// Process for WorkoutView
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.grey.shade800,
            appBar: AppBar(
                backgroundColor: Colors.green,
                centerTitle: true, // set title to middle
                title: const Text("Listview")),
            //top container
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    // List Property
                    child: ListView(
                  children: [
                    ListView.builder(
                        itemCount: ListViewItemNumber,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              color: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 5, color: Colors.lightGreenAccent),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  // lisitem[index][0] taskname
                                  // lisitem[index][1] min
                                  // lisitem[index][2] sec
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(listitem[index][0]),
                                      Text(
                                          "${listitem[index][1]}:${listitem[index][2]}"),
                                    ],
                                  ),
                                ),
                              ));
                        })
                  ],
                )),
                //btm container
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add Button
                      if (boolstartbutton == false)
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TaskAddView(),
                                ));
                            setState(() {
                              ListViewItemNumber += 1;
                              print(ListViewItemNumber);
                              // Update The List Item number
                              listitem.add([
                                result["taskname"],
                                result["min"],
                                result["sec"]
                              ]);
                              copiedList.add([
                                result["taskname"],
                                result["min"],
                                result["sec"]
                              ]);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 24),
                            backgroundColor: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                          ),
                          child: const Text("Add"),
                        ),
                      // Delete button
                      if (boolstartbutton == false)
                        ElevatedButton(
                            onPressed: () {
                              if (ListViewItemNumber != 0) {
                                setState(() {
                                  listitem.removeAt(ListViewItemNumber - 1);
                                  copiedList.removeAt(ListViewItemNumber - 1);
                                  ListViewItemNumber--;
                                });
                              }
                            },
                            child: const Text("Delete"),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 24),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(24),
                              primary: Colors.green,
                            )),
                      // Start Button
                      ListViewItemNumber >= 1
                          ? ElevatedButton(
                              onPressed: () async {
                                if (count == 0) {
                                  count++;
                                  boolstartbutton = true;
                                  // Count Down timer
                                  for (int i = 0; i < ListViewItemNumber;) {
                                    while (listitem[i][2] != 0) {
                                      setState(() {
                                        if (boolstartbutton == true)
                                          listitem[i][2]--;
                                      });
                                      await Future.delayed(const Duration(
                                          milliseconds:
                                              1000)); // putting delay on every count
                                    }
                                    if (count == 1 && listitem[i][1] != 0) {
                                      listitem[i][2] = 59;
                                      listitem[i][1]--;
                                    } else if (listitem[i][2] == 0) i++;
                                  }
                                  //Reset timer
                                  for (int k = 0; k < ListViewItemNumber; k++) {
                                    setState(() {
                                      listitem[k][1] = copiedList[k][1];
                                      listitem[k][2] = copiedList[k][2];
                                      boolstartbutton = false;
                                      count = 0;
                                    });
                                  }
                                } else {
                                  boolstartbutton = false;
                                  count = 0;
                                  //Reset timer
                                  for (int k = 0; k < ListViewItemNumber; k++) {
                                    setState(() {
                                      listitem[k][1] = copiedList[k][1];
                                      listitem[k][2] = copiedList[k][2];
                                      boolstartbutton = false;
                                      count = 0;
                                    });
                                  }
                                }
                              },
                              child: boolstartbutton
                                  ? const Text("End")
                                  : const Text("Start"),
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 24),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(24),
                                primary: Colors.green,
                              ),
                            )
                          : const Text("")
                    ],
                  ),
                )
              ],
            )));
  }
}

