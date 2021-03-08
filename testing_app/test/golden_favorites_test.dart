// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/screens/favorites.dart';

Favorites favoritesList;

Widget createFavoritesScreenGolden() => ChangeNotifierProvider<Favorites>(
      create: (context) {
        favoritesList = Favorites();
        return favoritesList;
      },
      child: MaterialApp(
        home: FavoritesPage(),
      ),
    );

void addItems() {
  for (var i = 0; i < 5; i++) {
    favoritesList.add(i);
  }
}

void main() {
  group('Favorites Page Widget Tests', () {
    testWidgets('Golden Test to see if FavoritesPage has correct UI',
        (tester) async {
      await tester.pumpWidget(createFavoritesScreenGolden());
      await expectLater(find.byType(FavoritesPage),
          matchesGoldenFile('goldens/favorites/FavoritesPage.png'));
    });

    testWidgets('Golden Test to see if Placeholder shows in case of empty list',
        (tester) async {
      await tester.pumpWidget(createFavoritesScreenGolden());

      await expectLater(find.text('No favorites added.'),
          matchesGoldenFile('goldens/favorites/PlaceHolder.png'));
    });

    testWidgets('Golden Test to see if ListView shows up and has correct UI',
        (tester) async {
      await tester.pumpWidget(createFavoritesScreenGolden());

      addItems();
      await tester.pumpAndSettle();

      // Verify if ListView shows up.
      await expectLater(find.byType(ListView),
          matchesGoldenFile('goldens/favorites/ListView.png'));
    });

    testWidgets('Testing Remove Button', (tester) async {
      await tester.pumpWidget(createFavoritesScreenGolden());

      addItems();
      await tester.pumpAndSettle();

      // Get the total number of items available.
      var totalItems = tester.widgetList(find.byIcon(Icons.close)).length;

      // Remove one item.
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      // Check if removed properly.
      expect(tester.widgetList(find.byIcon(Icons.close)).length,
          lessThan(totalItems));

      // Verify if the appropriate message is shown.
      await expectLater(find.text('Removed from favorites.'),
          matchesGoldenFile('goldens/favorites/RemovedMessage.png'));
    });
  });
}
