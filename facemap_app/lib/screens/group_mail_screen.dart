import 'dart:ui';

import 'package:facemap_app/api/admin_api.dart';
import 'package:facemap_app/models/recognized_face.dart';
import 'package:facemap_app/provider/recognized_faces.dart';
import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMailingScreen extends StatefulWidget {
  final String location;
  final List<RecognizedFace> faces;
  const GroupMailingScreen({Key key, this.location, this.faces})
      : super(key: key);
  @override
  _GroupMailingScreenState createState() => _GroupMailingScreenState();
}

class _GroupMailingScreenState extends State<GroupMailingScreen> {
  TextEditingController subjectTxtContrl, composeTxtContrl;

  @override
  void initState() {
    composeTxtContrl = TextEditingController();
    subjectTxtContrl = TextEditingController();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<RecognizedFacesProvider>(
        builder: (context, myModel, child) => Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  isExtended: true,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final isValid = _formKey.currentState.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState.save();

                    Result result = await AdminServices.sendGroupMail(
                        myModel.mailingList.keys.toList(),
                        widget.location,
                        subjectTxtContrl.text,
                        composeTxtContrl.text);
                    print(result);

                    if (result.isSuccess)
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text(result.message),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text("Back"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                  }),
            ),
            appBar: AppBar(
                title: Text("Group Mailing Service",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: Styles.txt_h2)),
                elevation: 0.0,
                backgroundColor: Colors.white,
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text("To: "),
                          Wrap(
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                  myModel.mailingList.length,
                                  (index) => buildRawChip(index))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        height: 2.0,
                        width: double.infinity,
                        color: Colors.grey[350],
                      ),
                    ),
                    TextFormField(
                      validator: (String subject) =>
                          subject.isEmpty ? "Subject cannot be empty" : null,
                      controller: subjectTxtContrl,
                      decoration: InputDecoration(
                        // labelText: '',
                        hintText: 'Subject',
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        validator: (String body) =>
                            body.isEmpty ? "Body cannot be empty" : null,

                        controller: composeTxtContrl,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        // selectionHeightStyle: BoxHeightStyle.max,
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget buildRawChip(int index) {
    return Consumer<RecognizedFacesProvider>(
      builder: (context, myModel, child) => RawChip(
        deleteButtonTooltipMessage: "Remove Person",
        isEnabled: true,
        deleteIcon: Icon(
          Icons.highlight_remove,
        ),
        onDeleted: () {
          myModel.mailingListRemoveAt(index);
        },
        label: Text(myModel.mailingList.keys.elementAt(index)),
      ),
    );
  }

  @override
  void dispose() {
    subjectTxtContrl.clear();
    composeTxtContrl.clear();
    super.dispose();
  }
}
