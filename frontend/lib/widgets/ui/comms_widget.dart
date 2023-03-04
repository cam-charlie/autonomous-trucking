import 'package:flutter/material.dart';
import 'package:frontend/state/communication/comm_log.dart';
import 'dart:async';


void main(List<String> args) {
  runApp(_TestApp());
}

class _TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CommsWidget(),
      ),
    );
  }
}

class CommsWidget extends StatefulWidget {
  const CommsWidget({super.key});

  @override
  State<CommsWidget> createState() => _CommsWidgetState();
}

class _CommsWidgetState extends State<CommsWidget> {
  //_CommsWidgetState();

  bool small = true;
  bool textVisible = false;
  String logs = "";
  late CommunicationLog _comms;
  late Timer timer;

  @override
  void initState() {
    // Update Logs every 0.5 seconds
    _comms = CommunicationLog();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        logs = _comms.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: AnimatedContainer(
        alignment: AlignmentDirectional.center,
        duration: const Duration(milliseconds: 500),
        curve: !small ? Curves.elasticOut : Curves.elasticIn,
        width: small ? 60 : 278,
        height: small ? 60 : 686,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        //color: Colors.black,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0x66000000)),
        child: small
            ? TextButton(
                onPressed: () => {
                      setState(() => {small = false}),
                      Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          textVisible = true;
                        });
                      })
                    },
                child: const Text("➕",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    )))
            : AnimatedOpacity(
                opacity: textVisible ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: 200,
                          height: 60,
                          child: const Text("Communication Log",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                        ),
                        TextButton(
                          onPressed: () => {
                            setState(() => {
                                  Timer(const Duration(milliseconds: 100), () {
                                    setState(() => small = true);
                                  }),
                                  textVisible = false
                                })
                          },
                          child: const Text("✖",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              )),
                        )
                      ]),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        logs,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 6),
                      ),
                    ),
                  )
                ]),
              ),
      ),
    );
  }
}
