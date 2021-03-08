// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/screens/home.dart';
import 'package:flutter/material.dart';

Widget createHomeScreenGolden() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );

void main() {
  group('HomePage Golden Tests', () {
    testWidgets('Golden Test to see if HomePage has correct UI',
        (tester) async {
      await tester.pumpWidget(createHomeScreenGolden());
      await expectLater(find.byType(HomePage),
          matchesGoldenFile('goldens/home/HomePage.png'));
    }, skip: !Platform.isWindows);

    testWidgets('Golden Test to see if ListView has correct UI',
        (tester) async {
      await tester.pumpWidget(createHomeScreenGolden());
      await expectLater(find.byType(ListView),
          matchesGoldenFile('goldens/home/ListView.png'));
      // Verify if ListView shows up.
    }, skip: !Platform.isWindows);

    testWidgets('Golden Test to see if an item in ListView has correct UI',
        (tester) async {
      await tester.pumpWidget(createHomeScreenGolden());

      await expectLater(
          find.text('Item 0'), matchesGoldenFile('goldens/home/ListItem.png'));
    }, skip: !Platform.isWindows);

    testWidgets('Golden Test to verify correct behaviour of IconButtons',
        (tester) async {
      await tester.pumpWidget(createHomeScreenGolden());

      // Tap the first item's icon to add it to favorites.
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Verify if the appropriate message is shown.
      await expectLater(find.text('Added to favorites.'),
          matchesGoldenFile('goldens/home/AddedMessage.png'));

      // Check if any solid favorite icon shows up.
      await expectLater(find.byIcon(Icons.favorite),
          matchesGoldenFile('goldens/home/SolidIcon.png'));
      // Tap the first item's icon which has filled icon to
      // remove it from favorites.
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle(Duration(seconds: 1));

      // Verify if the appropriate message is shown.
      await expectLater(find.text('Removed from favorites.'),
          matchesGoldenFile('goldens/home/RemovedMessages.png'));
    }, skip: !Platform.isWindows);
  });
}
