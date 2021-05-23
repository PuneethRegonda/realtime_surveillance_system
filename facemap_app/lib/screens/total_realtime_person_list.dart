import 'package:facemap_app/models/recognized_face.dart';
import 'package:facemap_app/provider/recognized_faces.dart';
import 'package:facemap_app/utils/session.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:facemap_app/utils/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RealTimePeopleList extends StatefulWidget {
  @override
  _RealTimePeopleListState createState() => _RealTimePeopleListState();
}

class _RealTimePeopleListState extends State<RealTimePeopleList> {
  Socket socket;

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    socket = io(Urls.host + 'facemap', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {
        'Authorization': 'TOKEN ' + Session.authToken,
      } // optional
    });

    socket.connect();

    socket.on('connect', (_) {
      print('connected');
    });

    socket.on("old_faces", (data) {
      print("old_faces");

      print(data.toString());
      // convert to KnownFaces
      if (data != null) {
        print("adding oldFaces");
        Provider.of<RecognizedFacesProvider>(context, listen: false)
            .realtimefaces = RecognizedFace.fromOldFacesJsonList(data);
        setState(() {});
      }
    });
    // convert to KnownFace and display
    socket.on('new_faces', (data) {
      print("new Faces");
      Provider.of<RecognizedFacesProvider>(context, listen: false)
          .realtimefaces
          .add(RecognizedFace.fromKnownFace(data));
      setState(() {});
    });

    socket.on('disconnect', (_) => print('disconnected'));

    super.initState();
  }

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  Widget getCard(int index) {
    return Card(
      elevation: 5.0,
      child: ListTile(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Realtime List",
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
      body: Provider.of<RecognizedFacesProvider>(context, listen: false)
                  .realtimefaces
                  .length ==
              0
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount:
                  Provider.of<RecognizedFacesProvider>(context, listen: false)
                      .realtimefaces
                      .length,
              itemBuilder: (BuildContext context, int index) {
                return getCard(index);

                // Card(
                //   elevation: 5.0,
                //   child: ListTile(
                //       title: Text(
                //         Provider.of<RecognizedFacesProvider>(context,
                //                 listen: false)
                //             .realtimefaces[index]
                //             .name,
                //         style: kIsWeb
                //             ? TextStyle(
                //                 fontWeight: FontWeight.w800, fontSize: 30.0)
                //             : Theme.of(context).textTheme.bodyText2,
                //       ),
                //       subtitle: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             Provider.of<RecognizedFacesProvider>(context,
                //                     listen: false)
                //                 .realtimefaces[index]
                //                 .location,
                //             style: TextStyle(
                //                 fontSize: 15.0, fontStyle: FontStyle.italic),
                //           ),
                //           Text(
                //             DateTime.parse(Provider.of<RecognizedFacesProvider>(
                //                         context,
                //                         listen: false)
                //                     .realtimefaces[index]
                //                     .time)
                //                 .toLocal()
                //                 .toString(),
                //             style: TextStyle(
                //                 fontSize: 15.0, fontStyle: FontStyle.italic),
                //           ),
                //         ],
                //       )),
                // );
              },
            ),
    );
  }
}
