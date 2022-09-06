import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickblox_chat_flutter/quickblox/video_services.dart';
import 'package:quickblox_sdk/models/qb_rtc_session.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/webrtc/constants.dart';
import 'package:quickblox_sdk/webrtc/rtc_video_view.dart';

import '../../../size_config.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/snackbar_utils.dart';
import '../../widgets/rounded_button.dart';

class VideoCallSetup extends StatefulWidget {
  final List<int> OPPONENTS_IDS;
  final int LOGGED_USER_ID;

  const VideoCallSetup(
      {Key? key, required this.OPPONENTS_IDS, required this.LOGGED_USER_ID})
      : super(key: key);

  @override
  State<VideoCallSetup> createState() => _VideoCallSetupState();
}

class _VideoCallSetupState extends State<VideoCallSetup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String parsedState = "";
  String? _sessionId;

  RTCVideoViewController? _localVideoViewController;
  RTCVideoViewController? _remoteVideoViewController;

  bool _videoCall = true;
  bool _joined = true;
  int _remoteUid = 0;
  bool _switch = false;
  bool isMicMute = false;
  bool isCameraOff = false;
  Stopwatch watch = Stopwatch();
  Timer? timer;
  String elapsedTime = '';
  bool isTimerRunning = false;

  get kBackgoundColor => null;

  StreamSubscription? _callSubscription;
  StreamSubscription? _callEndSubscription;
  StreamSubscription? _rejectSubscription;
  StreamSubscription? _acceptSubscription;
  StreamSubscription? _hangUpSubscription;
  StreamSubscription? _videoTrackSubscription;
  StreamSubscription? _notAnswerSubscription;
  StreamSubscription? _peerConnectionSubscription;

  String status = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VideoServices.init(_scaffoldKey, context);
    subscribeCall();
    subscribeCallEnd();
    subscribeReject();
    subscribeAccept();
    subscribeHangUp();
    subscribeVideoTrack();
    subscribeNotAnswer();
    subscribePeerConnection();
  }

  void setCurrentStatus(String val) {
    setState(() {
      status = val;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text"),
        actions: [
          IconButton(
              onPressed: () {
                VideoServices.releaseWebRTC(_scaffoldKey, context);
                hangUpWebRTC();
              },
              icon: Icon(Icons.close)),
          IconButton(
              onPressed: () {
                callWebRTC(QBRTCSessionTypes.VIDEO);
              },
              icon: Icon(Icons.call))
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _switch = !_switch;
                      });
                    },
                    child: Center(
                      child: _switch
                          ? _renderLocalPreview()
                          : _renderRemoteVideo(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(1),
                    Colors.transparent
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(16),
                    vertical: getProportionateScreenWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Onur Kaplan",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text("İtalyan Şef",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "elapsedTime",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Spacer()
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ClipRRect(
                      // <-- clips to the 200x200 [Container] below
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: buildBottomNavBar()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Local preview
  Widget _renderLocalPreview() {
    if (_joined) {
      return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: RTCVideoView(
            onVideoViewCreated: _onLocalVideoViewCreated,
          ));
    } else {
      return Text(
        "Bağlanılıyor...",
        textAlign: TextAlign.center,
      );
    }
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_joined) {
      return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: RTCVideoView(
            onVideoViewCreated: _onRemoteVideoViewCreated,
          ));
    } else {
      return Text(
        "Aşçı bekleniyor...",
        textAlign: TextAlign.center,
      );
    }
  }

  void switchMicrophone() {
    setState(() {
      isMicMute = !isMicMute;
    });
  }

  void switchEnableCamera() {
    setState(() {
      isCameraOff = !isCameraOff;
    });
  }

  Future<void> leaveChannel() async {}

  void switchCamera() {}

  Widget buildBottomNavBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(4)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(24)),
              child: RoundedButton(
                color: isMicMute ? Colors.white : Color(0xFF2C384D),
                iconColor: isMicMute ? Color(0xFF2C384D) : Colors.white,
                size: 48,
                iconSrc: "asset/icons/svg/Icon Close.svg",
                press: () async {
                  await leaveChannel();
                },
              ),
            ),
            RoundedButton(
              color: isMicMute ? Colors.white : Color(0xFF2C384D),
              iconColor: isMicMute ? Color(0xFF2C384D) : Colors.white,
              size: 48,
              iconSrc: "asset/icons/svg/Icon Mic.svg",
              press: () {
                switchMicrophone();
              },
            ),
            RoundedButton(
              color: isCameraOff ? Colors.white : Color(0xFF2C384D),
              iconColor: isCameraOff ? Color(0xFF2C384D) : Colors.white,
              size: 48,
              iconSrc: "asset/icons/svg/Icon Video.svg",
              press: () {
                switchEnableCamera();
              },
            ),
            RoundedButton(
              color: Color(0xFF2C384D),
              iconColor: Colors.white,
              size: 48,
              iconSrc: "asset/icons/svg/Icon Repeat.svg",
              press: () {
                switchCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> hangUpWebRTC() async {
    try {
      QBRTCSession? session = await QB.webrtc.hangUp(_sessionId!);
      String? id = session!.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $id was hang up");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> play() async {
    _localVideoViewController!.play(_sessionId!, widget.LOGGED_USER_ID);
    _remoteVideoViewController!.play(_sessionId!, widget.OPPONENTS_IDS[0]);
  }

  void _onLocalVideoViewCreated(RTCVideoViewController controller) {
    _localVideoViewController = controller;
  }

  void _onRemoteVideoViewCreated(RTCVideoViewController controller) {
    _remoteVideoViewController = controller;
  }

  Future<void> enableVideo(bool enable) async {
    try {
      await QB.webrtc.enableVideo(_sessionId!, enable: enable);
      SnackBarUtils.showResult(_scaffoldKey, "The video was enable $enable");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> callWebRTC(int sessionType) async {
    try {
      QBRTCSession? session =
          await QB.webrtc.call(widget.OPPONENTS_IDS, sessionType);
      _sessionId = session!.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "The call was initiated for session id: $_sessionId");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeCall() async {
    if (_callSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL);
      return;
    }

    try {
      _callSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        Map<dynamic, dynamic> sessionMap =
            Map<dynamic, dynamic>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];
        int initiatorId = sessionMap["initiatorId"];
        int callType = sessionMap["type"];

        setState(() {
          if (callType == QBRTCSessionTypes.AUDIO) {
            _videoCall = false;
          } else {
            _videoCall = true;
          }
        });

        _sessionId = sessionId;
        String messageCallType = _videoCall ? "Video" : "Audio";

        DialogUtils.showTwoBtn(context,
            "The INCOMING $messageCallType call from user $initiatorId",
            (accept) {
          acceptWebRTC(sessionId);
        }, (decline) {
          rejectWebRTC(sessionId);
        });
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> acceptWebRTC(String sessionId) async {
    try {
      QBRTCSession? session = await QB.webrtc.accept(sessionId);
      String? receivedSessionId = session!.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $receivedSessionId was accepted");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> rejectWebRTC(String sessionId) async {
    try {
      QBRTCSession? session = await QB.webrtc.reject(sessionId);
      String? id = session!.id;
      SnackBarUtils.showResult(
          _scaffoldKey, "Session with id: $id was rejected");
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeCallEnd() async {
    if (_callEndSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.CALL_END);
      return;
    }
    try {
      _callEndSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.CALL_END, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        Map<dynamic, dynamic> sessionMap =
            Map<dynamic, dynamic>.from(payloadMap["session"]);

        String sessionId = sessionMap["id"];

        SnackBarUtils.showResult(
            _scaffoldKey, "The call with sessionId $sessionId was ended");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.CALL_END);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeVideoTrack() async {
    if (_videoTrackSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for:" +
              QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
      return;
    }

    try {
      _videoTrackSubscription = await QB.webrtc
          .subscribeRTCEvent(QBRTCEventTypes.RECEIVED_VIDEO_TRACK, (data) {
        Map<dynamic, dynamic> payloadMap =
            Map<dynamic, dynamic>.from(data["payload"]);

        int opponentId = payloadMap["userId"];

        if (opponentId == widget.LOGGED_USER_ID) {
          print("starting local video");
          startRenderingLocal();
        } else {
          print("start remote view");
          startRenderingRemote(opponentId);
        }
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.RECEIVED_VIDEO_TRACK);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeNotAnswer() async {
    if (_notAnswerSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.NOT_ANSWER);
      return;
    }

    try {
      _notAnswerSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.NOT_ANSWER, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "The user $userId is not answer");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.NOT_ANSWER);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeReject() async {
    if (_rejectSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.REJECT);
      return;
    }

    try {
      _rejectSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.REJECT, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(
            context, "The user $userId was rejected your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.REJECT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeAccept() async {
    if (_acceptSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.ACCEPT);
      return;
    }

    try {
      _acceptSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.ACCEPT, (data) {
        int userId = data["payload"]["userId"];
        SnackBarUtils.showResult(
            _scaffoldKey, "The user $userId was accepted your call");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.ACCEPT);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribeHangUp() async {
    if (_hangUpSubscription != null) {
      SnackBarUtils.showResult(_scaffoldKey,
          "You already have a subscription for: " + QBRTCEventTypes.HANG_UP);
      return;
    }

    try {
      _hangUpSubscription =
          await QB.webrtc.subscribeRTCEvent(QBRTCEventTypes.HANG_UP, (data) {
        int userId = data["payload"]["userId"];
        DialogUtils.showOneBtn(context, "the user $userId is hang up");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(
          _scaffoldKey, "Subscribed: " + QBRTCEventTypes.HANG_UP);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> subscribePeerConnection() async {
    if (_peerConnectionSubscription != null) {
      SnackBarUtils.showResult(
          _scaffoldKey,
          "You already have a subscription for: " +
              QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
      return;
    }

    try {
      _peerConnectionSubscription = await QB.webrtc.subscribeRTCEvent(
          QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED, (data) {
        int state = data["payload"]["state"];
        String parsedState = parseState(state);
        SnackBarUtils.showResult(
            _scaffoldKey, "PeerConnection state: $parsedState");
      }, onErrorMethod: (error) {
        DialogUtils.showError(context, error);
      });
      SnackBarUtils.showResult(_scaffoldKey,
          "Subscribed: " + QBRTCEventTypes.PEER_CONNECTION_STATE_CHANGED);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> startRenderingLocal() async {
    try {
      await _localVideoViewController!.play(_sessionId!, widget.LOGGED_USER_ID);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  Future<void> startRenderingRemote(int opponentId) async {
    try {
      await _remoteVideoViewController!.play(_sessionId!, opponentId);
    } on PlatformException catch (e) {
      DialogUtils.showError(context, e);
    }
  }

  String parseState(int state) {
    switch (state) {
      case QBRTCPeerConnectionStates.NEW:
        parsedState = "NEW";
        setState(() {});

        break;
      case QBRTCPeerConnectionStates.FAILED:
        parsedState = "FAILED";
        setState(() {});

        break;
      case QBRTCPeerConnectionStates.DISCONNECTED:
        parsedState = "DISCONNECTED";
        setState(() {});

        break;
      case QBRTCPeerConnectionStates.CLOSED:
        parsedState = "CLOSED";
        setState(() {});

        break;
      case QBRTCPeerConnectionStates.CONNECTED:
        parsedState = "CONNECTED";
        setState(() {});
        break;
    }

    return parsedState;
  }
}
