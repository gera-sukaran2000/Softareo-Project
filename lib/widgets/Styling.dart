import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:softareo/models/Tasks.dart';
import 'package:community_material_icon/community_material_icon.dart';

class StylingWidget extends StatefulWidget {
  Task singleobject;
  StylingWidget(this.singleobject);

  @override
  _StylingWidgetState createState() => _StylingWidgetState();
}

class _StylingWidgetState extends State<StylingWidget> {
  var _isEditing = false;
  var taskid;
  String _someText;
  final valuechangeController = TextEditingController();

  String getInitialText(String id) {
    taskid = id;
    final list = Provider.of<Tasks>(context, listen: false).myTasksList;
    final index = list.indexWhere((element) => element.id == id);
    final element = list[index];
    return element.task;
  }

  void changeValue() {
    if (valuechangeController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Cannot be Empty'),
              content: Text(
                  'Please enter a new title for the task \nPress Edit Again'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            );
          });
    }
    Provider.of<Tasks>(context, listen: false)
        .changeData(taskid, Task(id: taskid, task: valuechangeController.text));
    taskid = null;
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Container(
      margin: EdgeInsets.only(left: 7, right: 7),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            leading: Container(
              padding: EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  CommunityMaterialIcons.check_circle_outline,
                  color: Colors.black,
                  size: 25.0,
                ),
                onPressed: () async {
                  await Provider.of<Tasks>(context, listen: false)
                      .addToCompletedTask(widget.singleobject.id);
                },
              ),
            ),
            title: (_isEditing)
                ? Container(
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done,
                      controller: valuechangeController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Type Here....",
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 16)),
                      autofocus: false,
                      onSubmitted: (_) {
                        changeValue();
                        setState(() {
                          _isEditing = false;
                        });
                      },
                    ),
                  )
                : Text(widget.singleobject.task,
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
            trailing: Wrap(
              spacing: 3,
              children: [
                IconButton(
                    onPressed: () {
                      _someText = getInitialText(widget.singleobject.id);
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: Icon(CommunityMaterialIcons.square_edit_outline,
                        color: Colors.black, size: 25.0)),
                IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<Tasks>(context, listen: false)
                            .removeTask(widget.singleobject.id);
                      } catch (error) {
                        scaffold.showSnackBar(
                            SnackBar(content: Text('Error Deleting Product')));
                      }
                    },
                    icon: Icon(CommunityMaterialIcons.trash_can_outline,
                        color: Colors.black, size: 25.0))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
