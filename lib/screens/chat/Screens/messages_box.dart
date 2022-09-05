import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../../../../utils.dart';

class MessagesBoxPage extends StatefulWidget {
  MessagesBoxPage({Key? key}) : super(key: key);

  @override
  _MessagesBoxPageState createState() => _MessagesBoxPageState();
}

class _MessagesBoxPageState extends State<MessagesBoxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
    );
    // return  StreamBuilder<QuerySnapshot>(
    //       stream: chats,
    //       builder:
    //           (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //         if (snapshot.hasError) {
    //           return Text('Something went wrong');
    //         }

    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Text("Loading");
    //         }

    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: ListView(
    //             children: snapshot.data!.docs.map((DocumentSnapshot document) {
    //               Map<String, dynamic> data =
    //                   document.data()! as Map<String, dynamic>;
    //               String username = data['from'];
    //               String userIMG = data['img'];
    //               String senderId = document.id;

    //               return InkWell(
    //                 onTap: () {
    //                   Navigator.of(context).push(MaterialPageRoute(
    //                       builder: (builder) =>
    //                           FetchReceiverInfos(receiverID: senderId)));
    //                 },
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(top: 4.0),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         //border: Border.all(color: Colors.red, width:!data['isRead']? 1:0.2),
    //                         borderRadius: BorderRadius.circular(8)),
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Row(
    //                         children: [
    //                           Container(
    //                             height: 36,
    //                             width: 36,
    //                             child: userIMG ==
    //                                     "default"
    //                                 ? Image.asset("assets/icons/user.png",color: Theme.of(context).primaryColor,)

    //                                     : CachedNetworkImage(
    //                                         imageUrl: userIMG,
    //                                         imageBuilder:
    //                                             (context, imageProvider) =>
    //                                                 Container(
    //                                           decoration: BoxDecoration(
    //                                             shape: BoxShape.circle,
    //                                             image: DecorationImage(
    //                                                 image: imageProvider,
    //                                                 fit: BoxFit.cover),
    //                                           ),
    //                                         ),
    //                                         placeholder: (context, url) =>
    //                                             CircularProgressIndicator(),
    //                                         errorWidget:
    //                                             (context, url, error) =>
    //                                                 Icon(Icons.error),
    //                                       ),
    //                           ),
    //                           SizedBox(
    //                             width: 12,
    //                           ),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Row(
    //                                 children: [
    //                                   Text(
    //                                     username,
    //                                     style: TextStyle(
    //                                         fontWeight: FontWeight.bold,
    //                                         fontSize: 16),
    //                                   ),
    //                                   SizedBox(
    //                                     width: 8,
    //                                   ),
    //                                   Visibility(
    //                                     visible: !data['isRead'],
    //                                     child: Container(
    //                                       height: 8,
    //                                       width: 8,
    //                                       decoration: BoxDecoration(
    //                                           color: kPrimaryColor,
    //                                           shape: BoxShape.circle),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                               SizedBox(
    //                                 width: SizeConfig.screenWidth / 1.6,
    //                                 child: Text(
    //                                   data['lastMessage'],
    //                                   overflow: TextOverflow.ellipsis,
    //                                   maxLines: 1,
    //                                   style: TextStyle(
    //                                       fontWeight: !data['isRead']
    //                                           ? FontWeight.bold
    //                                           : FontWeight.w100),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           Spacer(),
    //                           Text(Utils.toTime(data['time'].toDate())),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               );
    //               //  ListTile(

    //               //   title: Text(username),
    //               //   subtitle: Text(data['lastMessage']),
    //               // );
    //             }).toList(),
    //           ),
    //         );
    //       },
    //     );
  }
}
