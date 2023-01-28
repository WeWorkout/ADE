import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AlertDialogTimer extends StatefulWidget {
  Map<String, double> timeData;

  AlertDialogTimer(this.timeData);

  @override
  State<AlertDialogTimer> createState() => _AlertDialogTimerState();
}

class _AlertDialogTimerState extends State<AlertDialogTimer> {
  late double time;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight * 0.3,
      width: screenWidth * 0.55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SleekCircularSlider(
            initialValue: widget.timeData["time"]!,
            min: 0,
            max: 60,
            appearance: circularSliderAppearance,
            onChange: (double newTime) {
              widget.timeData["time"] = newTime;
              time = newTime;
              setState(() {});
            },
            innerWidget: innerWidget,
          ),
          _timerPresets()
        ],
      ),
    );
  }

  CircularSliderAppearance get circularSliderAppearance =>
      CircularSliderAppearance(
        customWidths: CustomSliderWidths(
            trackWidth: 20, progressBarWidth: 15, handlerSize: 5),
        customColors: CustomSliderColors(
            trackColor: Colors.grey,
            dotColor: Colors.white,
            progressBarColor: Theme.of(context).primaryColor),
        size: MediaQuery.of(context).size.height * 0.2,
        startAngle: 270,
        angleRange: 360,
      );

  Widget innerWidget(double time) {
    double fontScale = MediaQuery.of(context).size.height * 0.03;
    return Material(
      type: MaterialType.transparency,
      child: Align(
          alignment: Alignment.center,
          child: Text(
            "${time.toInt().toString()}m",
            style: TextStyle(fontSize: fontScale),
          )),
    );
  }

  Widget _timerPresets() {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 5.0,
          children: List<Widget>.generate(
            11,
            growable: false,
            (int index) {
              return ChoiceChip(
                selectedColor: Theme.of(context).primaryColor,
                label: Text(
                    '${(index + 1) * 5}m',
                  style: TextStyle(color: widget.timeData["time"] == (index + 1) * 5 ? Colors.white : Colors.black),
                ),
                selected: widget.timeData["time"] == (index + 1) * 5,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      widget.timeData["time"] = (index + 1) * 5;
                      time = (index + 1) * 5;
                    }
                  });
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
