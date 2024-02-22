import 'package:firebase/service/TokenService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String firebaseToken;
  late SharedPreferences prefs;

  late String targetURL = "";

  void init() async {
    prefs = await SharedPreferences.getInstance();
    final String findTargetURL = prefs.getString("targetURL") ?? "";
    if (findTargetURL != "") {
      targetURL = findTargetURL;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      firebaseToken = token!;
    });
    init();
  }

  void onToken(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("토큰확인"),
            content: Text(firebaseToken),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void saveTargetURL() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("저장하시겠습니까?"),
            content: Text(targetURL),
            actions: [
              TextButton(
                onPressed: () {
                  prefs.setString("targetURL", targetURL);
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('취소'),
              ),
            ],
          );
        });
  }

  void sendToken() {
    TokenService.sendToken(targetURL, firebaseToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(targetURL),
          TextField(
            onChanged: (value) => {targetURL = value},
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: saveTargetURL,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "타겟 서버 저장",
                  style: TextStyle(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              onToken(context);
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "토큰 확인",
                  style: TextStyle(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: sendToken,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "토근 보내기",
                  style: TextStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
