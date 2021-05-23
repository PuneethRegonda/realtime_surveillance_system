import 'package:facemap_app/screens/locationwise_real_time_person_list.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/session.dart';

class LiveLocations extends StatefulWidget {
  @override
  _LiveLocationsState createState() => _LiveLocationsState();
}

class _LiveLocationsState extends State<LiveLocations> {
  bool isWebsite = false;
  @override
  void didChangeDependencies() {
    isWebsite = MediaQuery.of(context).size.width >= 1080 ? true : false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
          ),
          Text(
            "Search by Places",
            style: kIsWeb
                ? TextStyle(
                    fontWeight: FontWeight.w800, fontSize: Styles.txt_h1)
                : Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: kIsWeb
                ? MediaQuery.of(context).size.height * .75
                : MediaQuery.of(context).size.height * .6,
            width: kIsWeb
                ? MediaQuery.of(context).size.width * .85
                : MediaQuery.of(context).size.width * .75,
            child: GridView.count(
              padding: isWebsite ? EdgeInsets.all(20.0) : EdgeInsets.all(30.0),
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              crossAxisCount: isWebsite ? 6 : 2,
              children: buildCards(context),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildCards(BuildContext context) {
    return Session.cameraLocations.keys
        .map((String location) => SizedBox(
              width:
                  isWebsite ? MediaQuery.of(context).size.height * .05 : 250.0,
              height:
                  isWebsite ? MediaQuery.of(context).size.height * .05 : 250.0,
              child: InkWell(
                onTap: () {
                  // if (Provider.of<RecognizedFacesProvider>(context,
                  //             listen: false)
                  //         .locations[location] !=
                  //     null)
                  //   print(Provider.of<RecognizedFacesProvider>(context,
                  //           listen: false)
                  //       .locations[location]
                  //       .realTimeFaces
                  //       .toString());
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) =>
                          LocationWiseRealTimePersonList(location: location)));
                },
                child: Card(
                  child: Center(
                    child: Text(
                      location,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }
}
