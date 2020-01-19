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
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.offset,
  })  : assert(angleRadians != null),
        assert(duration != null),
        assert(color != null),
        assert(width != null),
        assert(height != null),
        assert(borderRadius != null),
        assert(offset != null);

  final double angleRadians;
  final int duration;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Animator(
      tween: Tween<double>(begin: angleRadians, end: angleRadians + (2 * pi)),
      resetAnimationOnRebuild: true,
      duration: Duration(minutes: duration),
      repeats: 0,
      builder: (anim) => Center(
        child: SizedBox.expand(
          child: Transform.rotate(
            angle: anim.value,
            child: Center(
              child: Transform.translate(
                offset: offset,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset.fromDirection(-anim.value + pi / 2, 2),
                          color: Color.fromARGB(128, 0, 0, 0))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
