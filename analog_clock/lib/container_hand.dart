// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class ContainerHand extends StatelessWidget {

  /// All of the parameters are required and must not be null.
  const ContainerHand({
    this.angleRadians,
    this.duration,
    this.child,
  })  : assert(angleRadians != null);

  /// The child widget used as the clock hand and rotated by [angleRadians].
  final Widget child;
  final double angleRadians;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Animator(
      tween: Tween<double>(begin: angleRadians, end: angleRadians + (2 * pi)),
      duration: Duration(minutes: duration),
      repeats: 0,
      builder: (anim) => Center(
        child: SizedBox.expand(
          child: Transform.rotate(
            angle: anim.value,
            child: Container(
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
