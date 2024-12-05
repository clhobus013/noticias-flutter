import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KeywordSuggestionWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final Function() onPress;

  const KeywordSuggestionWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.selected,
      required this.onPress});

  @override
  State<KeywordSuggestionWidget> createState() =>
      _KeywordSuggestionWidgetState();
}

class _KeywordSuggestionWidgetState extends State<KeywordSuggestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                WidgetStateColor.resolveWith((Set<WidgetState> states) {
              if (widget.selected) {
                return const Color.fromARGB(255, 101, 120, 150);
              }
              return const Color.fromARGB(255, 255, 255, 255);
            }),
            iconColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
              if (widget.selected) {
                return const Color.fromARGB(255, 255, 255, 255);
              }
              return const Color.fromARGB(255, 101, 120, 150);
            }),
            fixedSize: const WidgetStatePropertyAll(Size.square(90)),
            padding: WidgetStatePropertyAll(
                EdgeInsetsGeometry.lerp(EdgeInsets.zero, EdgeInsets.zero, 0))),
        onPressed: widget.onPress,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FaIcon(
              widget.icon,
              size: 30,
            ),
            Text(
              widget.title,
              style: TextStyle(
                  color: widget.selected
                      ? const Color(0xffbcd3cd)
                      : const Color(0xff6f627e)),
            )
          ]),
        ),
      ),
    );
  }
}
