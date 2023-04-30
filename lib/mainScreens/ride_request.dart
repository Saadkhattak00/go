import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go/tabPages/home_tab.dart';

import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';

class RideRequest extends StatefulWidget {
  const RideRequest({Key? key}) : super(key: key);

  @override
  State<RideRequest> createState() => _RideRequestState();
}

class _RideRequestState extends State<RideRequest> {
  List<Widget> list = [];
  bool request = false;
  Map map = {};
  TextEditingController controller = TextEditingController();
  final driverRideRequest =
      FirebaseDatabase.instance.ref().child("Driver Ride Request");
  int i = 0;
  customerRideRequest() async {
    print("sdfsd");
    list.clear();
    final customerRef =
        await FirebaseDatabase.instance.ref("Customer Ride Request").get();

    if (!customerRef.children.isEmpty) {
      print("Customer refrence is not empty");
      map = customerRef.value as Map;

      map.forEach((customerKey, value) async {
        print("Customer Key customer request" + customerKey.toString());
        var _list = ListTile(
          leading: Column(
            children: [
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              Text(value["username"])
            ],
          ),
          title: Column(
            children: [
              Text("From :" + value["destinationAddress"],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("To :" + value["originAddress"])
            ],
          ),
          trailing: Column(
            children: [
              Text("PKR"),
              Text(value["fare"]),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value["fareDistance"]),
              Text(
                value["fareTime"],
              ),
              TextButton(
                  onPressed: () async {
                    await NDialog(
                      dialogStyle: DialogStyle(titleDivider: true),
                      title: Center(child: Text("Your Bid")),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                      ),
                      actions: <Widget>[
                        TextButton(
                            child: Text("Confirm"),
                            onPressed: () async {
                              setState(() {
                                request = false;
                              });
                              refreshList();
                              driverRideRequest
                                  .child(currentFirebaseUser!.uid)
                                  .child(customerKey)
                                  .set({
                                "fare": controller.text,
                                "accept": false
                              });
                              controller.clear();
                              Navigator.pop(context);
                            }),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"))
                      ],
                    ).show(context);
                  },
                  child: Text("Bid"))
            ],
          ),
        );
        var d = Container(
          width: double.maxFinite,
          height: 2,
          color: Colors.grey,
        );
        final drequest = await FirebaseDatabase.instance
            .ref()
            .child("Driver Ride Request")
            .child(currentFirebaseUser!.uid)
            .get();
        //if driver request exist
        if (drequest.exists) {
          //print(drequest.exists);
          Map dmap = drequest.value as Map;
          //driver sent bid for this request or not
          if (!(dmap.containsKey(customerKey))) {
            i++;
            list.add(_list);
            list.add(d);
            setState(() {
              request = true;
            });
          }

          // dmap.forEach((key, value) {
          //   print("Driver Key " + customerKey);
          //   print("User key " + key.toString());
          //   print(value.toString());
          //
          //   if (key != customerKey) {
          //     i++;
          //     list.add(_list);
          //     list.add(d);
          //     setState(() {
          //       request = true;
          //     });
          //   }
          // });
          print("i value  $i");
        } //driver request not exists
        else {
          list.add(_list);
          list.add(d);
          setState(() {
            request = true;
          });
        }

        //syncronized function off
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
      });
      Fluttertoast.showToast(msg: "No Ride Request");
    }
  }

  refreshList() {
    customerRideRequest();
  }

  @override
  void initState() {
    // TODO: implement initState
    customerRideRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          automaticallyImplyLeading: false,
          title: Text("Ride Request"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: request
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Column(
                children: request
                    ? list
                    : [Center(child: CircularProgressIndicator())]),
            TextButton(
                onPressed: () {
                  setState(() {
                    request = false;
                    customerRideRequest();
                  });
                },
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.black54),
                ))
          ],
        ),
      ),
    );
  }
}
