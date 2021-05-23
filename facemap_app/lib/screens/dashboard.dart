import 'package:facemap_app/screens/live_locations.dart';
import 'package:facemap_app/screens/total_realtime_person_list.dart';
import 'package:facemap_app/screens/uploadPicture_screen.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/search_bar.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool isWebsite = false;
  @override
  void didChangeDependencies() {
    isWebsite = MediaQuery.of(context).size.width >= 1080 ? true : false;
    super.didChangeDependencies();
  }

  Widget buildSearchBar() {
    return Hero(
      tag: "search_bar",
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Card(
            elevation: 0.0,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchByRollNo()));
              },
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
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "Search Roll No",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/parchment_paper.jpg'))),
          child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .05,
        ),
        Text(
          "Welcome Back ${Session.user.username} ",
          style: kIsWeb
              ? TextStyle(fontWeight: FontWeight.w800, fontSize: Styles.txt_h1)
              : Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * .2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                // color: Colors.blue,
                width: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                height: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                child: Tooltip(
                  message: 'Search Person in Picture',
                  child: InkWell(
                    onTap: () {
                      // LiveLocations
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadPicture()));
                    },
                    child: Card(
                      elevation: 5,
                      child: Center(
                        child: Text(
                          "Upload Picture",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                // color: Colors.blue,
                width: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                height: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                child: Tooltip(
                  message: 'Check all recognized people',
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RealTimePeopleList()));
                    },
                    child: Card(
                      elevation: 2.5,
                      child: Center(
                        child: Text(
                          "Real Time List",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                // color: Colors.blue,
                width: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                height: isWebsite
                    ? MediaQuery.of(context).size.height * .35
                    : 250.0,
                child: Tooltip(
                  message: 'Check people locations',
                  child: InkWell(
                    onTap: () {
                      //
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LiveLocations()));
                    },
                    child: Card(
                      elevation: 2.5,
                      child: Center(
                        child: Text(
                          "Live Locations",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: <Widget>[

    //     buildSearchBar(),
    //     Text(
    //       "Welcome Back!!",
    //       style: kIsWeb
    //           ? TextStyle(
    //               fontWeight: FontWeight.w800, fontSize: Styles.txt_h1)
    //           : Theme.of(context).textTheme.bodyText1,
    //     ),
    //     SizedBox(
    //       height: kIsWeb
    //           ? MediaQuery.of(context).size.height * .75
    //           : MediaQuery.of(context).size.height * .6,
    //       width: kIsWeb
    //           ? MediaQuery.of(context).size.width * .85
    //           : MediaQuery.of(context).size.width * .75,
    //       child: GridView.count(
    //         // padding: isWebsite
    //         //     ? EdgeInsets.symmetric(
    //         //         horizontal: MediaQuery.of(context).size.width *.013,
    //         //         vertical: MediaQuery.of(context).size.height * .1)
    //         //     : EdgeInsets.all(30.0),
    //         mainAxisSpacing: 20.0,
    //         crossAxisSpacing: 20.0,
    //         crossAxisCount: isWebsite ? 6 : 2,
    //         children: buildCards(context),
    //       ),
    //     )
    //   ],
    // );
  }

  // List<Widget> buildCards(BuildContext context) {
  //   return [
  //     "Upload Picture",
  //     "Live Locations",
  //     "Real Time List",
  //     "Search By Roll Number"
  //   ]
  //       .map((String location) => SizedBox(
  //             width:
  //                 isWebsite ? MediaQuery.of(context).size.height * .05 : 250.0,
  //             height:
  //                 isWebsite ? MediaQuery.of(context).size.height * .05 : 250.0,
  //             child: InkWell(
  //               onTap: () {
  //                 if (Provider.of<RecognizedFacesProvider>(context,
  //                             listen: false)
  //                         .locations[location] !=
  //                     null)

  //                 Navigator.of(context).push(CupertinoPageRoute(
  //                     builder: (_) => RealTimePersonsList()));
  //               },
  //               child: Card(
  //                 elevation: 2.5,
  //                 child: Center(
  //                   child: Text(
  //                     location,
  //                     style: Theme.of(context).textTheme.bodyText2,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ))
  //       .toList();
  // }
}
