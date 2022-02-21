import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/widgets/post_card.dart';

import 'notification_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var userData={};
  int Noticeslen=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   getData();
  }

  getData()async{
    var snap = await FirebaseFirestore.instance.collection("notices").get();
    Noticeslen = snap.docs.length;
    print(Noticeslen);
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                Noticeslen==0?IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                    color: primaryColor,
                  ),
                  onPressed: () async{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationPage(uid: FirebaseAuth.instance.currentUser!.uid,)));
                  }
                ):IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () async{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationPage(uid: FirebaseAuth.instance.currentUser!.uid,)));
                    }
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
