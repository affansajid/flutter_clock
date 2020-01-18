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

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set the initial values.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(minutes: 1) - Duration(seconds: _now.second),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF3C3A3A),
            // Minute hand.
            highlightColor: Color(0xFFFFCD79),
            // Second hand.
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
        child: Stack(
          children: [
            Transform.translate(
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
            ContainerHand(
              angleRadians: _now.second * radiansPerTick,
              duration: 1,
              child: Transform.translate(
                offset: Offset(0.0, -76),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: customTheme.accentColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          color: Color.fromARGB(64, 0, 0, 0))
                    ],
                  ),
                ),
              ),
            ),
            ContainerHand(
              angleRadians: _now.minute * radiansPerTick + (_now.second / 60) * radiansPerTick,
              duration: 60,
              child: Transform.translate(
                offset: Offset(0.0, -30),
                child: Container(
                  width: 5,
                  height: 80,
                  decoration: BoxDecoration(
                    color: customTheme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          color: Color.fromARGB(64, 0, 0, 0))
                    ],
                  ),
                ),
              ),
            ),
            ContainerHand(
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
              duration: 720,
              child: Transform.translate(
                offset: Offset(0.0, -10),
                child: Container(
                  width: 5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: customTheme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          color: Color.fromARGB(64, 0, 0, 0))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
