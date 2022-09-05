// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_app_settings/open_app_settings.dart';
// import 'package:studeed_app/helper.dart';

// import '../../../../helper/dialogs.dart';
// import '../../../../utils.dart';

class MessageSender {}

// class MessageSender {
//   bool _isRoomExist = false;
//   bool get isRoomExist => _isRoomExist;

//   Future isExist(String senderID, String receiverID) async {
//     CollectionReference chatRef =
//         FirebaseFirestore.instance.collection('Chats');

//     await chatRef
//         .doc(receiverID)
//         .collection('chats')
//         .doc(senderID)
//         .get()
//         .then((value) async {
//       if (!value.exists) {
//         _isRoomExist = false;
//       } else {
//         _isRoomExist = true;
//       }
//     });
//   }

//   Future updateSeen(String senderID, String receiverID) async {
//     CollectionReference chatRef =
//         FirebaseFirestore.instance.collection('Chats');

//     await chatRef.doc(senderID).collection('chats').doc(receiverID).update({
//       'isRead': true,
//     });
//     await chatRef.doc(receiverID).collection('chats').doc(senderID).update({
//       'isRead': true,
//     });
//   }

//   Future updateChatRooms(
//       String receiverID,
//       String senderID,
//       String? message,
//       String senderName,
//       String senderImg,
//       String receiverName,
//       String receiverImg) async {
//     CollectionReference chatRef =
//         FirebaseFirestore.instance.collection('Chats');

//     await chatRef.doc(senderID).collection('chats').doc(receiverID).set({
//       'isRead': true,
//       'time': DateTime.now(),
//       'lastMessage': message,
//       'from': receiverName,
//       'fromID': senderID,
//       'img': receiverImg
//     });

//     await chatRef.doc(receiverID).collection('chats').doc(senderID).set({
//       'isRead': false,
//       'time': DateTime.now(),
//       'lastMessage': message,
//       'from': senderName,
//       'fromID': receiverID,
//       'img': senderImg
//     });
//   }

//   Future sendMessage(
//       BuildContext context,
//       String receiverID,
//       String senderID,
//       String? message,
//       String receiverName,
//       String receiverImg,
//       String type,
//       String mediaURL,
//       String receiverToken) async {
//     CollectionReference userRef =
//         FirebaseFirestore.instance.collection("Users");

//     userRef.doc(senderID).get().then((value) async {
//       String senderName = value.get("username");
//       String senderImg = value.get("img");
//       CollectionReference chatRef =
//           FirebaseFirestore.instance.collection('Chats');

//       Map senderBlocks = value.get('blocks');
//       bool receiverBlocked = senderBlocks[receiverID] == true;

//       if (receiverBlocked) {
//         showErrorDialog(context,
//             'You blocked this user! First you need to remove the user from blocks list');
//       } else {
//         userRef.doc(receiverID).get().then((value) async {
//           Map receiverBlocks = value.get('blocks');
//           bool senderBlocked = receiverBlocks[senderID] == true;

//           if (senderBlocked) {
//             showErrorDialog(
//                 context, 'User blocked you! You can\'t send message !');
//           } else {
//             await chatRef
//                 .doc(receiverID)
//                 .collection('chats')
//                 .doc(senderID)
//                 .collection('messages')
//                 .add({
//               'from': senderID,
//               'time': DateTime.now(),
//               'message': message,
//               'media': type == "text" ? "default" : mediaURL,
//               'type': type,
//               'seen': false
//             }).then((value) async {
//               await chatRef
//                   .doc(senderID)
//                   .collection('chats')
//                   .doc(receiverID)
//                   .collection('messages')
//                   .add({
//                 'from': senderID,
//                 'time': DateTime.now(),
//                 'message': message,
//                 'media': type == "text" ? "default" : mediaURL,
//                 'type': type,
//                 'seen': false
//               });
//             });

//             await updateChatRooms(receiverID, senderID, message, senderName,
//                 senderImg, receiverName, receiverImg);

//             await sendNotify(type, receiverID, message!, senderName, senderID,
//                 receiverToken);
//           }
//         });
//       }
//     });
//   }

//   Future sendNotify(String type, String receiverID, String message,
//       String senderName, String senderID, String receiverToken) async {
//     List receivers = [];
//     receivers.add(receiverToken);
//     await FirebaseFirestore.instance.collection("PersonalMessageNotify").add({
//       'senderName': senderName,
//       'message': type == 'img' ? '📷 Photo ' : message,
//       'receivers': receivers,
//       'senderID': senderID
//     });
//   }

//   Future sendPhotoMessage(
//       BuildContext context,
//       String receiverID,
//       String message,
//       String receiverName,
//       String receiverImg,
//       bool isGallery,
//       String receiverToken) async {
//     //final photos = await Permission.photos.request();
//     final storageStatus = await Permission.storage.request();

  
//     if (!isGallery) {
//       final camera = await Permission.camera.request();

//       if (camera != PermissionStatus.granted ||
//           storageStatus != PermissionStatus.granted) {
//         isGallery == false
//             ? showDialog(
//                 context: context,
//                 builder: (_) => CupertinoAlertDialog(
//                       title: Text(
//                           "You must enable camera access permission to use this feature."),
//                       actions: [
//                         CupertinoDialogAction(
//                             child: Text("Cancel"),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             }),
//                         CupertinoDialogAction(
//                             child: Text("Settings"),
//                             onPressed: () async {
//                               await OpenAppSettings.openAppSettings();
//                             }),
//                       ],
//                     ))
//             : "";
//         return null;
//       }
//     }

//     final file = await Utils().pickMedia(
//       isGallery: isGallery,
//       cropImage: cropSquareImage,
//     );

//     if (file == null) return null;

//     showLoadingDialog(context, "Gönderiliyor..");

//     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     String _uid = firebaseAuth.currentUser!.uid.toString();
//     String time = DateTime.now().millisecondsSinceEpoch.toString();
//     final _storage = FirebaseStorage.instance;
//     await _storage
//         .ref('chats/$_uid/$receiverID/$time')
//         .putFile(file)
//         .then((p0) async {
//       String downloadURL = await p0.ref.getDownloadURL();
//       await sendMessage(context, receiverID, _uid, message, receiverName,
//           receiverImg, "img", downloadURL, receiverToken);
//       Navigator.pop(context);
//     });
//   }

//   Future<File?> cropSquareImage(File imageFile) async =>
//       await ImageCropper().cropImage(
//           sourcePath: imageFile.path,
//           aspectRatioPresets: [CropAspectRatioPreset.square],
//           compressQuality: 50,
//           compressFormat: ImageCompressFormat.jpg,
//           androidUiSettings: androidUiSettingsLocked(),
//           iosUiSettings: iosUiSettingsLocked());

//   IOSUiSettings iosUiSettingsLocked() => IOSUiSettings();

//   AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
//       toolbarTitle: 'Düzenle', toolbarWidgetColor: Colors.blue);
// }
