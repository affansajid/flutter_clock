// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'container_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> with WidgetsBindingObserver {
  var _now = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set the initial values for the time.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) - Duration(seconds: _now.second),
        _updateTime,
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    bool isResuming = state == AppLifecycleState.resumed;
    if (isResuming) {
      _updateTime();
    }
  }

  // Scale the size of the clock based on container size
  double _scaleRatio(constraints) {
    // Get shortSide from the BoxConstraints
    final shortSide = constraints.maxHeight <= constraints.maxWidth
        ? constraints.maxHeight
        : constraints.maxWidth;

    return shortSide / 200;
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFF3C3A3A),
            highlightColor: Color(0xFFF3E7D7),
            accentColor: Color(0xFF9F2C2C),
            backgroundColor: Color(0xFFFFFFFF),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFF3C3A3A),
            highlightColor: Color(0xFFC7AEAE),
            accentColor: Color(0xFFFFFFFF),
            backgroundColor: Color(0xFFC7AEAE),
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final _ratio = _scaleRatio(constraints);

            return Stack(
              children: [
                Container(
                  child: Transform.scale(
                    scale: _ratio,
                    child: Transform.translate(
                        offset: Offset(0, 0),
                        child: Center(
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              color: customTheme.highlightColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        )),
                  ),
                ),
                Transform.scale(
                  scale: _ratio,
                  child: ContainerHand(
                    angleRadians: _now.second * radiansPerTick,
                    duration: 1,
                    width: 8,
                    height: 8,
                    color: customTheme.accentColor,
                    borderRadius: 100,
                    offset: Offset(0.0, -78),
                  ),
                ),
                Transform.scale(
                  scale: _ratio,
                  child: ContainerHand(
                    angleRadians: _now.minute * radiansPerTick +
                        (_now.second / 60) * radiansPerTick,
                    duration: 60,
                    width: 6,
                    height: 80,
                    color: customTheme.primaryColor,
                    borderRadius: 0,
                    offset: Offset(0.0, -30),
                  ),
                ),
                Transform.scale(
                  scale: _ratio,
                  child: ContainerHand(
                    angleRadians: _now.hour * radiansPerHour +
                        (_now.minute / 60) * radiansPerHour,
                    duration: 720,
                    width: 6,
                    height: 40,
                    color: customTheme.primaryColor,
                    borderRadius: 0,
                    offset: Offset(0.0, -10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
