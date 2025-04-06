
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jewellery/Themes/colors.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Function(int) onBarTap;
  int selectedBarIndex;

  AnimatedBottomBar({
    required this.barItems,
    required this.onBarTap,
    this.selectedBarIndex = 0,
  });

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  Duration duration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Material(
      // elevation: 10.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: TextColorPurple)
          // border: Border.symmetric(vertical: BorderSide.non)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = widget.selectedBarIndex == i;

      barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            widget.selectedBarIndex = i;
            widget.onBarTap(i);
          });
        },
        child: AnimatedContainer(
          duration: duration,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                item.image!,
                height: 24,
                width: 24,
                // color: isSelected ? Colors.purple : Colors.grey,
              ),
              const SizedBox(height: 5),
              Text(
                item.text!,
                style: TextStyle(
                  color: isSelected ? Colors.purple : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return barItems;
  }
}

class BarItem {
  String? text;
  String? image;

  BarItem({this.text, this.image});
}