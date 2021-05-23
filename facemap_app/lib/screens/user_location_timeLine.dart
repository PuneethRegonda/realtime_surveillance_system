import 'package:facemap_app/api/user_api.dart';
import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData.light(),
      debugShowMaterialGrid: false,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      home: UserLocationTimeLine("Puneeth")));
}

class UserLocationTimeLine extends StatefulWidget {
  final String name;

  const UserLocationTimeLine(this.name);
  @override
  UserLocationTimeLineState createState() => UserLocationTimeLineState();
}

class UserLocationTimeLineState extends State<UserLocationTimeLine> {
  // Map<String, dynamic> data = {
  //   "2019-08-21": [
  //     {"location": "Aryabatta IT block", "time": "18.04"},
  //     {"location": "CSE Block", "time": "18.04"},
  //   ],
  //   "2019-08-22": [
  //     {"location": "CSE Block", "time": "18.04"},
  //     {"location": "Gandhi Statue", "time": "18.04"},
  //   ],
  //   "2019-08-23": [
  //     {"location": "Aryabatta IT block", "time": "18.04"},
  //     {"location": "Gandhi Statue", "time": "18.04"},
  //   ],
  //   "2019-08-24": [
  //     {"location": "Aryabatta IT block", "time": "18.04"},
  //     {"location": "Gandhi Statue", "time": "18.04"},
  //   ],
  //   "2019-08-25": [
  //     {"location": "Aryabatta IT block", "time": "18.04"},
  //     {"location": "Gandhi Statue", "time": "18.04"},
  //   ],
  //   "2019-08-26": [
  //     {"location": "Aryabatta IT block", "time": "18.04"},
  //     {"location": "CSE Block", "time": "18.04"},
  //     {"location": "Gandhi Statue", "time": "18.04"},
  //   ],
  // };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Check History of ${widget.name}",
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
      body: FutureBuilder<Result>(
          future: UserAPI.checkhistory(widget.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Align(
                alignment: Alignment.centerLeft,
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    nodePosition: .15,
                    color: Colors.blue[200],
                    indicatorTheme: IndicatorThemeData(color: Colors.blue),
                    connectorTheme: ConnectorThemeData(
                      indent: 1,
                      space: 32.0,
                    ),
                  ),
                  builder: TimelineTileBuilder.fromStyle(
                    contentsAlign: ContentsAlign.basic,
                    oppositeContentsBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.data.keys.elementAt(index),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    contentsBuilder: (context, index) => Padding(
                      padding: EdgeInsets.all(24.0),
                      child: buildData(snapshot.data.data,
                          snapshot.data.data.keys.elementAt(index)),
                    ),
                    itemCount: snapshot.data.data.length,
                  ),
                ),
              );
          }),
    );
  }

  buildData(data, String key) {
    return Column(
      children:
          List.generate(data[key].length, (indx) => buildCard(data[key][indx]))
              .toList(),
    );
  }

  Widget buildCard(map) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Location: ${map["location"]}"),
              Text(
                "At: ${map["time"].toString().substring(0, 5)}",
                // style: TextStyle(color: Colors.black, fontSize: Styles.txt_h4),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          color: Colors.white,
          // height: MediaQuery.of(context).size.height * .06,
          // width: MediaQuery.of(context).size.width * .,
        ),
      ),
    );
  }
}
