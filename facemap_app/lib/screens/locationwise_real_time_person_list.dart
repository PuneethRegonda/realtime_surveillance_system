import 'package:facemap_app/models/recognized_face.dart';
import 'package:facemap_app/provider/recognized_faces.dart';
import 'package:facemap_app/screens/group_mail_screen.dart';
import 'package:facemap_app/screens/user_location_timeLine.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:facemap_app/utils/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LocationWiseRealTimePersonList extends StatefulWidget {
  final String location;

  const LocationWiseRealTimePersonList({Key key, this.location})
      : super(key: key);

  @override
  _LocationWiseRealTimePersonListState createState() =>
      _LocationWiseRealTimePersonListState();
}

class _LocationWiseRealTimePersonListState
    extends State<LocationWiseRealTimePersonList> {
  Socket socket;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    socket = io(Urls.host + 'facemap', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {
        'Authorization': 'TOKEN ' + Session.authToken,
      } // optional
    });
    // Provider.of<RecognizedFacesProvider>(context,listen:false).realtimefaces=[];
    socket.connect();

    socket.on('connect', (_) {
      print('connected');
    });

    socket.on("old_faces", (data) {
      print("old_faces");

      if (data != null) {
        print("adding oldFaces");
        // all old faces will be segragated into locations and then used.
        print(data);
        Provider.of<RecognizedFacesProvider>(context, listen: false)
                .realtimefaces =
            RecognizedFace.facesatLocation(
                location: widget.location, data: data);
      }
    });

    socket.on('new_faces', (data) {
      print("new_faces");
      print(data.toString());

      Provider.of<RecognizedFacesProvider>(context, listen: false)
          .realtimefaces
          .add(RecognizedFace.fromKnownFace(data));
    });

    socket.on('disconnect', (_) => print('disconnected'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecognizedFacesProvider>(
        builder: (context, myModel, child) => Scaffold(
            appBar: AppBar(
                actions: [
                  Session.user.isAdmin && myModel.realtimefaces.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              tooltip:
                                  "Group Mail people at ${widget.location} ",
                              color: Colors.blue,
                              onPressed: () {
                                myModel.setUniqueFaces(widget.location);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GroupMailingScreen(
                                          location: widget.location,
                                          faces: myModel.realtimefaces,
                                        )));
                              },
                              icon: Icon(Icons.mail_outlined)),
                        )
                      : Container()
                ],
                title: Text("${widget.location}",
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
                      if (!socket.disconnected) socket.disconnect();
                    })),
            body: ListView.builder(
                itemCount: (myModel.realtimefaces == null ||
                        myModel.realtimefaces.isEmpty)
                    ? 1
                    : myModel.realtimefaces.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildLocationWiseList(context, index))));
  }

  Widget buildLocationWiseList(BuildContext context, int index) {
    if (Provider.of<RecognizedFacesProvider>(context, listen: false)
                .realtimefaces ==
            null ||
        Provider.of<RecognizedFacesProvider>(context, listen: false)
            .realtimefaces
            .isEmpty)
      return Center(
        child: Container(child: Text("No Persons found!!")),
      );
    RecognizedFace face =
        Provider.of<RecognizedFacesProvider>(context, listen: false)
            .realtimefaces[index];
    return getCard(index);
  }

  Widget getCard(int index) {
    return Tooltip(
      message: "Check History",
      child: ListTile(
          onTap: () {
            // UserLocationTimeLine
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserLocationTimeLine(
                    Provider.of<RecognizedFacesProvider>(context, listen: false)
                        .realtimefaces[index]
                        .name)));
          },
          title: Text(
            Provider.of<RecognizedFacesProvider>(context, listen: false)
                .realtimefaces[index]
                .name,
            style: kIsWeb
                ? TextStyle(fontWeight: FontWeight.w800, fontSize: 30.0)
                : Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Provider.of<RecognizedFacesProvider>(context, listen: false)
                    .realtimefaces[index]
                    .location,
                style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
              ),
              Text(
                DateTime.parse(Provider.of<RecognizedFacesProvider>(context,
                            listen: false)
                        .realtimefaces[index]
                        .time)
                    .toLocal()
                    .toString(),
                style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
