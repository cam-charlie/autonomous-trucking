import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend/constants.dart' as constants;
import 'package:frontend/widgets/ui/control_button.dart';



abstract class ControlItem extends Widget {}

class ControlUI extends StatefulWidget {
  ControlUI({required this.children, this.visible = true, super.key});

  final List<Widget> children;
  final bool visible;

  @override
  State<ControlUI> createState() => _ControlUIState();
}

class _ControlUIState extends State<ControlUI> {
  _ControlUIState();

  bool get visible => widget.visible;
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform:
          visible ? Matrix4.identity() : Matrix4.translationValues(0, 200, 0),
      duration: const Duration(milliseconds: 500),
      curve: !visible ? Curves.easeInBack : Curves.easeOutBack,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: visible ? 1.0 : 0.7,
        curve: visible ? Curves.easeInBack : Curves.easeOutBack,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 20,
                        offset: Offset(10, 15)),
                  ],
                  color: constants.opaqueUIColour,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                // children: widget.children,
                mainAxisSize: MainAxisSize.min,

                children: [
                  ControlButton(icon: FontAwesomeIcons.backward,
                    align: FractionalOffset(0.4, 0.5),),
                  SizedBox(width: 15),
                  ControlButton(
                    icon: playing ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                    onTap: () => setState(() => playing = !playing),
                    align: playing ? Alignment.center : FractionalOffset(0.6, 0.5),
                  ),
                  SizedBox(width: 15),
                  ControlButton(icon: FontAwesomeIcons.forward, align: FractionalOffset(0.6, 0.5),),
                ],
              )),
        ),
      ),
    );
  }
}
