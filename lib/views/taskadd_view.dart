/// Done by Chin poh, Jarrel , Cheng Feng , Hong Zhao , Ryan
/// Version 1.1.5
import 'package:flutter/material.dart';

/// Add Task Pages 
class TaskAddView extends StatefulWidget {
  const TaskAddView({super.key});

  @override
  TaskAddViewState createState() => TaskAddViewState();
}

/// Add Task Page Background 
class TaskAddViewState extends State<TaskAddView> {
  /// TextBox Controoler initialise
  final TextEditingController _textFieldControllerAddtask =
      TextEditingController();
  /// Task Item Name
  String taskitemname = "";
  /// Minutes Number
  int intminselectedindex = -1;
  /// Second Number
  int intsecselectedindex = -1;
  /// Check Add Button Status
  bool boolTextinputed = false;
  /// Throw Always When left the app
  @override
  void dispose() {
    _textFieldControllerAddtask.dispose();
    super.dispose();
  }
  /// Inital State
  @override
  void initState() {
    super.initState();
    // See Text change
    _textFieldControllerAddtask.addListener(_onTextChanged);
  }
  /// Trim excesses Text
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
  /// Process for Add Task
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Minutes"),
                Text("Second"),
              ],
            ),
            Row(
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
