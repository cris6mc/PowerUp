// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';

class TitleDisplay extends StatelessWidget {
  const TitleDisplay(
      {super.key,
      required this.value,
      required this.title,
      this.isLight = false});

  final String value;
  final bool isLight;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title: $value',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
