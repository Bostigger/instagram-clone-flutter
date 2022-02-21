import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class NotificationPage extends StatefulWidget {
  final String uid;

  const NotificationPage({Key? key, required this.uid}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var userData = {};
  var chatId = "";
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var userNotif = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('notices')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("New Notifications"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notices").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                       Navigator.of(context).push(MaterialPageRoute(
                           builder: (context) => ProfileScreen(
                               uid: snapshot.data!.docs[index]['uid'])));
                      await FireStoreMethods().deletePostFromNotification(
                          snapshot.data!.docs[index]['postId']);
                     PhotoView(imageProvider:NetworkImage(snapshot.data!.docs[index]['photoUrl']),);

                    },
                    child: FirebaseAuth.instance.currentUser!.uid ==
                            snapshot.data!.docs[index]['uid']
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 24),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "New post made by: ",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                    Text(
                                        "${snapshot.data!.docs[index]['postBy']}",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                  ],
                                ),
                                Text(
                                  DateFormat.yMMMd().format(snapshot
                                      .data!.docs[index]['timePublished']
                                      .toDate()),
                                  style: const TextStyle(
                                    color: secondaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                  );
                });
          }),
    );
  }
}
