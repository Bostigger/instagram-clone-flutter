import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';

class FavvoritePosts extends StatefulWidget {
  const FavvoritePosts({Key? key}) : super(key: key);

  @override
  _FavvoritePostsState createState() => _FavvoritePostsState();
}

class _FavvoritePostsState extends State<FavvoritePosts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
       future: FirebaseFirestore.instance.collection("favorites").get(),
        builder:(context,snapshot){
         if(!snapshot.hasData){
           return Center(
             child: Text("No favorites post", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
           );


         }
         return GridView.builder(

             gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             crossAxisSpacing: 5,
             mainAxisSpacing: 1.5,
             childAspectRatio: 1,
             ),
             itemBuilder: (context, index) {
               DocumentSnapshot snap =
               (snapshot.data! as dynamic).docs[index];
               return SizedBox(
                 height: 250,
                 width: 250,
                 child: Column(
                     children: [

                     Expanded(
                       child: Image(
                         image: NetworkImage(snap['postImage']),
                         fit: BoxFit.cover,
                   ),

                     ),
                       InkWell(
                         onTap: (){
                           Navigator.of(context).push(MaterialPageRoute(
                             builder: (context) =>
                                 ProfileScreen(uid: snap['userId']),
                           ));
                         },
                           child: Expanded(
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [

                                 Text("Posted by: "+ snap['username'],style: TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: Colors.grey,)),
                                 IconButton(
                                   icon: Icon(Icons.delete,size: 10,),
                                   onPressed: () async{
                                     await FireStoreMethods().removeFav(snap['postId']);
                                   },

                                 )
                               ],
                             ),
                           )),

                 ]
                 ),
               );
               

          },
           itemCount: (snapshot.data! as dynamic).docs.length,
          );
        }

      );
  }
}
