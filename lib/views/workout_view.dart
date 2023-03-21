import 'package:flutter/material.dart';

// Done by Chinpoh
// Bug issue
// When click Start again, the await cause the time to speed up
//First Page
class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

//Second page
class TaskAddPage extends StatefulWidget {
  const TaskAddPage({super.key});

  @override
  _TaskAddPageState createState() => _TaskAddPageState();
}

class _WorkoutViewState extends State<WorkoutView> {
  int ListViewItemNumber = 0;
  List<List<dynamic>> listitem = [];
  List<List<dynamic>> copiedList = [];
  bool boolstartbutton = false;
  int count = 0;

  String nametitle = "Test";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                                  builder: (context) => const TaskAddPage(),
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

//Second Page
class _TaskAddPageState extends State<TaskAddPage> {
  final TextEditingController _textFieldControllerAddtask =
      TextEditingController();
  String taskitemname = "";
  int intminselectedindex = -1;
  int intsecselectedindex = -1;
  bool boolTextinputed = false;

  @override
  void dispose() {
    _textFieldControllerAddtask.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // See Text change
    _textFieldControllerAddtask.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final String text = _textFieldControllerAddtask.text;
    if ((text.trim()) != "") {
      setState(() {
        boolTextinputed = true;
      });
    } else {
      setState(() {
        boolTextinputed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            //Label
            const Text("Name Task :"),
            //TextBox
            TextField(
              controller: _textFieldControllerAddtask,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: null),
            ),

            const Text("    "),
            // Label for timer
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Minutes"),
                  const Text("Second"),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // For Minute ListView
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: 80,
                    child: ListView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 60,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                  '$index',
                                  textAlign: TextAlign.center,
                                ),
                                tileColor: intminselectedindex == index
                                    ? Colors.black12
                                    : null,
                                onTap: () {
                                  setState(() {
                                    intminselectedindex = index;
                                  });
                                },
                              );
                            })
                      ],
                    ),
                  ),
                  // For Second ListView
                  Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: 80,
                    child: ListView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 60,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                  '$index',
                                  textAlign: TextAlign.center,
                                ),
                                tileColor: intsecselectedindex == index
                                    ? Colors.black12
                                    : null,
                                onTap: () {
                                  setState(() {
                                    intsecselectedindex = index;
                                  });
                                },
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Text("    "),
            //Add button
            if (boolTextinputed &&
                (intminselectedindex >= 0 || intsecselectedindex >= 0))
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    taskitemname = _textFieldControllerAddtask
                        .text; // Save textbox input to a variable
                    if (intsecselectedindex == -1) intsecselectedindex = 0;
                    if (intminselectedindex == -1) intminselectedindex = 0;
                    final data = {
                      "taskname": taskitemname,
                      "min": intminselectedindex,
                      "sec": intsecselectedindex
                    };
                    Navigator.pop(context, data);
                  });
                },
                child: const Text("Add"),
              )
          ]),
        ),
      ),
    );
  }
}
