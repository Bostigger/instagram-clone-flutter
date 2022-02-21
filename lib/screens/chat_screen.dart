import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.chatId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  getChats() {}

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat"),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("messages")
                .doc(widget.chatId)
                .collection("chats")
                .orderBy("time", descending: false)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment:
                          snapshot.data!.docs[index]["sendBy"] == user.username
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                              color: snapshot.data!.docs[index]["sendBy"] ==
                                      user.username
                                  ? Colors.blueAccent
                                  : Colors.blueGrey,
                              borderRadius: snapshot.data!.docs[index]
                                          ["sendBy"] ==
                                      user.username
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(23),
                                      topRight: Radius.circular(23),
                                      bottomLeft: Radius.circular(23))
                                  : BorderRadius.only(
                                      topRight: Radius.circular(23),
                                      bottomRight: Radius.circular(23),
                                      topLeft: Radius.circular(23))),
                          child: snapshot.data!.docs[index]["sendBy"] ==
                                  user.username
                              ? Text("${snapshot.data!.docs[index]["message"]}")
                              : Text(
                                  "${snapshot.data!.docs[index]["message"]}",
                                  style: TextStyle(color: Colors.amber),
                                )),
                    );
                  });
            },
          ),
          Container(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        String res = await FireStoreMethods().sendMessage(
                            widget.chatId.toString(),
                            user.username,
                            _messageController.text);
                        if (res == "sent") {
                          setState(() {
                            _messageController.text = "";
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
