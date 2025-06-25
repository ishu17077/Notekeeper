import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/state_management/note/note_bloc.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];

  late final NoteBloc _noteBloc;

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  void initState() {
    _noteBloc = context.read<NoteBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headlineMedium;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          if (!didPop) {
            moveToLastScreen();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            backgroundColor: Colors.deepPurple,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                ListTile(
                  title: DropdownButton<String>(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getPriorityAsString(note.priority),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser ?? 'High');
                        });
                      }),
                ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.deepPurple),
                              textStyle: WidgetStatePropertyAll(TextStyle(
                                color: Theme.of(context).primaryColorDark,
                              ))),
                          child: Text(
                            'Save',
                            textScaler: TextScaler.linear(1.2),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              textStyle: WidgetStatePropertyAll(TextStyle(
                                color: Theme.of(context).primaryColorDark,
                              ))),
                          child: Text(
                            'Delete',
                            textScaler: TextScaler.linear(1.2),
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority = "Low";
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      // Case 1: Update operation
      _noteBloc.add(NoteUpdate(note));
    } else {
      // Case 2: Insert Operation
      _noteBloc.add(NoteEvent.addNote(note));
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    if (note.id != null) {
      _noteBloc.add(NoteEvent.deleteNote(note));
      //// int result = await helper.deleteNote(note.id ?? 1);
      // //if (result != 0) {
      // //  _showAlertDialog('Status', 'Note Deleted Successfully');
      //// } else {
      ////   _showAlertDialog('Status', 'Error Occured while Deleting Note');
      //// }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
