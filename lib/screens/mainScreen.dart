import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softareo/models/Tasks.dart';
import 'package:softareo/widgets/Styling.dart';

class AllTasks extends StatefulWidget {
  //not added notifyllistens antwhere till now
  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Tasks>(context).fetchAndSetTasks();

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

//   void _addNewTask(BuildContext ctx) {
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         builder: (context) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 1),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 1.0),
//                     child: ,
//                   ),
//                   SizedBox(
//                     height: 8.0,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                   ),
//                   SizedBox(height: 10.0),
//                 ],
//               ),
//             ));
//   }

  final titleController = TextEditingController();

  Future<void> validateAndSubmit(BuildContext ctx) {
    if (titleController.text.isEmpty) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Empty Title'),
                content: Text('Please add title of your Task before adding'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'))
                ],
              ));
    } else {
      Provider.of<Tasks>(ctx, listen: false).addtoTask(
          Task(task: titleController.text, id: DateTime.now().toString()));
      clearText();
      FocusScope.of(context).unfocus();
    }
  }

  void clearText() {
    titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<Tasks>(context).myTasksList;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'TO DO App',
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 50,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Type Something here....",
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                          autofocus: false,
                          controller: titleController,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        validateAndSubmit(context);
                        // _addNewTask
                      },
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      mini: true,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return StylingWidget(list[index]);
                    },
                    itemCount: list.length,
                  ),
                ),
              ],
            ),
    );
  }
}
