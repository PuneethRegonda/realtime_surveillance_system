import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchByRollNo extends StatefulWidget {
  SearchByRollNo({
    Key key,
  }) : super(key: key);

  @override
  _SearchByRollNoState createState() => _SearchByRollNoState();
}

class _SearchByRollNoState extends State<SearchByRollNo> {
  bool selected = false;

  final TextEditingController textFieldcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: kIsWeb
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : null,
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: "search_bar",
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .80,
                  height: 60.0,
                  child: Card(
                    elevation: 3.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: textFieldcontroller,
                              onChanged: (String value) {},
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  border: InputBorder.none,
                                  hintText: " Search Your Friend by Roll No",
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.0,
                                      fontStyle: FontStyle.normal)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                          color: Colors.blue[200],
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
