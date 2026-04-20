# GCal Toggle Switcher

A pixel-faithful Flutter replica of Google Calendar's segmented Calendar / Tasks toggle button. 

This package provides a highly customizable, animated view switcher that flawlessly mimics the Google Calendar web interface, including sliding highlights, dynamic text expansion, and cross-fading page transitions.

## Features

* **Pixel-Perfect Google UI:** Matches the exact padding, colors, and behaviors of the Google Calendar segmented toggle.
* **Animated State:** Smooth sliding animations when switching between tabs.
* **Hover & Press States:** Includes desktop/web mouse-over highlights and click ripples.
* **Cross-Fading Content:** Automatically cross-fades the page content associated with each tab.
* **Standalone or Integrated:** Can be used to drive an external layout via `GCalToggleController` or manage its own page area automatically.

## Usage

Simply drop the `GCalToggleSwitcher` into your app and provide it with a list of `GCalToggleTab` items.

```dart
import 'package:flutter/material.dart';
import 'package:gcal_toggle_switcher/gcal_toggle_switcher.dart';

class MyCalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GCalToggleSwitcher(
      tabs: const [
        GCalToggleTab(
          icon: Icons.calendar_month_outlined,
          label: 'Calendar',
          tooltip: 'Calendar view',
          page: Center(child: Text('Calendar Page Active')),
        ),
        GCalToggleTab(
          icon: Icons.check_circle_outline,
          label: 'Tasks',
          tooltip: 'Tasks view',
          page: Center(child: Text('Tasks Page Active')),
        ),
      ],
    );
  }
}