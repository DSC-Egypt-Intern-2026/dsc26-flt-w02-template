# dsc26-flt-w02 · Nour Shelf: the branch alerts screen, layered

DSC Summer Internship 2026 · Flutter track · Week 2 · **Flutter 3.47.6, Dart 3.13** · expected time 2.5–3.5 hours

## Scenario

Nour's branch pharmacists open the app at the start of a shift and see the stock alerts for their branch: which chronic medicines are about to run out, how urgent each one is, and which ones they have already looked at. Head office sends alerts as a JSON feed. You build the alerts screen in proper layers, so that the sorting and search rules (which Dr. Mona's team will certainly change) live in one tested place.

## Getting started

1. Click **Use this template** and create a **public** repository in your own account named exactly **`dsc26-flt-w02`**.
2. Clone it, then:

```bash
flutter --version      # 3.47.x, Dart 3.13.x
flutter pub get
flutter test           # the public tests run; they fail until you implement the task
```

Do **not** rename the package in `pubspec.yaml` (`name: dsc26_flt_w02`): the grader's tests import `package:dsc26_flt_w02/...`, and a renamed package scores 0.

## File layout (keep it)

```text
lib/
  main.dart                                   NourShelfApp (you write it)
  domain/models/stock_alert.dart              Severity, StockAlert (you finish it)
  data/repositories/alert_repository.dart     AlertRepository + InMemoryAlertRepository (given, do not change the interface)
  data/services/alerts_api_service.dart       unused stub, it shows where network code would live
  ui/alerts/view_models/alerts_view_model.dart  AlertsViewModel (you write it)
  ui/alerts/widgets/alerts_screen.dart        AlertsScreen (you write it)
test/public_test.dart                         public tests
AI_USAGE.md                                   fill it in
```

You may add files (for example more widgets under `lib/ui/alerts/widgets/` or `lib/ui/core/`). Keep the files above at these paths.

## What to build

### 1. The model: `lib/domain/models/stock_alert.dart`

Keep the constructor and fields. Implement:

- `factory StockAlert.fromJson(Map<String, Object?> json)`
  - `id`, `medicineNameEn`, `medicineNameAr`, `branchCode`: non-empty strings, otherwise `FormatException`.
  - `severity`: one of `critical`, `high`, `medium`, `low`, case-insensitive (`"Critical"`, `"LOW"` are fine), otherwise `FormatException`. A non-string severity is invalid.
  - `daysOfCover`: a JSON number (`int` or `double`) ≥ 0, stored as `double`, otherwise `FormatException`.
  - `acknowledged`: optional `bool`, default `false` when the key is missing.
  - Unknown extra fields are ignored.
  - **Any invalid input throws `FormatException`, never `TypeError`.** (So no bare `as String` on unchecked values.)
- `StockAlert copyWith({String? id, String? medicineNameEn, String? medicineNameAr, Severity? severity, double? daysOfCover, String? branchCode, bool? acknowledged})`: a new object; fields you do not pass keep their value.
- `operator ==` and `hashCode`: value equality over **all seven fields**, with a matching `hashCode`.

Nothing under `lib/domain/` may import Flutter.

### 2. The view model: `lib/ui/alerts/view_models/alerts_view_model.dart`

`class AlertsViewModel extends ChangeNotifier`, constructor `AlertsViewModel({required AlertRepository repository})`. Keep these public members exactly:

| Member | Behaviour |
|---|---|
| `Future<void> load()` | Fetches from the repository. `loading` is `true` while it runs. |
| `bool get loading` | |
| `List<StockAlert> get visibleAlerts` | **Unmodifiable** (`add` / `removeAt` throw `UnsupportedError`). Filtered by severity and search, then sorted (rule below). |
| `Set<Severity> get activeFilters` | The selected severities. **Empty means "show all".** |
| `void toggleFilter(Severity s)` | Adds `s` if absent, removes it if present. Several can be active at once. |
| `void setQuery(String q)` | Search (rule below). |
| `Future<void> acknowledge(String id)` | Calls `repository.acknowledge(id)` **once**, then replaces that alert with `copyWith(acknowledged: true)` before the returned future completes. Never modifies the original object. Unknown id: no repository call, no change. |
| `int get unacknowledgedCriticalCount` | Critical alerts not yet acknowledged, counted over **all loaded alerts**, whatever the current filters and search. |

**Sorting rule**, in this order:

1. unacknowledged before acknowledged;
2. severity: critical, high, medium, low;
3. `daysOfCover` ascending;
4. `medicineNameEn` A–Z ignoring case (compare the `toLowerCase()` strings).

**Search rule.** An alert matches if the normalised query is a substring of the normalised English name **or** the normalised Arabic name. Normalise **both the query and the names** the same way: trim, lower-case, and for Arabic:

- `أ` `إ` `آ` become `ا`
- `ة` becomes `ه`
- `ى` becomes `ي`
- remove tatweel `ـ` (U+0640) and the Arabic diacritics (harakat, tanween, shadda, sukun), U+064B to U+0652

An empty query (after normalising) matches everything. Filters and search combine: an alert is visible only if it passes both.

**Listeners.** `toggleFilter` and `setQuery` call `notifyListeners()` **exactly once** when something changes, and `setQuery` does **not** notify at all when the normalised query is unchanged (for example `"amlo"` then `"  AMLO "`, or `"انسولين"` then `"أنسولين"`).

### 3. The screen and the app

- `AlertsScreen` in `lib/ui/alerts/widgets/alerts_screen.dart`: shows what the view model exposes and forwards taps to it. No sorting or filtering in the widget.
- `NourShelfApp({Key? key, required AlertRepository repository})` in `lib/main.dart`: creates the view model **once**, calls `load()` itself, shows `AlertsScreen`, and disposes the view model when it is removed. The tests only ever do `tester.pumpWidget(NourShelfApp(repository: ...))`.

**Keys the tests use** (use `Key('...')` with exactly these strings):

| Key | Widget |
|---|---|
| `alerts-loading` | Shown while `load()` is in progress (visible after `pumpWidget` and one `pump`) |
| `alerts-list` | The scrollable list (absent when nothing is visible) |
| `alert-<id>` | One row per visible alert, e.g. `alert-insulin` |
| `ack-<id>` | The acknowledge button in that row, **only for unacknowledged alerts**; tapping it acknowledges |
| `filter-<severity>` | A toggle per severity: `filter-critical`, `filter-high`, `filter-medium`, `filter-low` |
| `search-field` | The search `TextField`; typing in it calls `setQuery` |
| `alerts-count` | A `Text` reading exactly `1 alert` or `N alerts` for the visible list (`0 alerts` when empty) |
| `alerts-empty` | Shown **instead of** the list when nothing is visible |

The widget tests run on the default 800×600 test screen and never show more than four alerts. Keep the search field, the filters and the count above the list so they are on screen without scrolling.

## Architecture rules (checked automatically)

- The five files in the layout above exist.
- Nothing under `lib/ui/` imports `package:http`, `dart:io`, or anything under `lib/data/services/` (relative imports count too).
- Nothing under `lib/domain/` imports `package:flutter/...`, `package:material_ui/...`, `package:cupertino_ui/...` or `dart:ui`.
- Only the packages already in `pubspec.yaml` are available to the grader. Use `package:flutter/material.dart` (the starter does) or `package:material_ui/material_ui.dart`, never both.

## How grading works

1. Push, then press **Submit for grading** on DSC Hex (5 attempts per task per day).
2. The grader pins your latest commit, copies your `lib/` into a clean project with the pinned packages (your `pubspec.yaml` is ignored apart from the package name), adds DSC's hidden tests and runs `flutter test` on Flutter 3.47.6 with the network off: 10 minutes for the run, 30 seconds per test.
3. You get a score from 0 to 100 and one feedback line per row below, with `passed / total` cases and a hint. Hidden inputs and expected values are never shown.
4. If `lib/` does not compile, the score is 0 and the feedback shows the first compiler errors in your files.

| Row | Public name | Weight |
|---|---|---|
| H01 | fromJson: valid input | 8 |
| H02 | fromJson: invalid input | 10 |
| H03 | model: equality and copyWith | 8 |
| H04 | sorting: full rule | 12 |
| H05 | filters | 8 |
| H06 | search: basics | 8 |
| H07 | search: Arabic normalisation | 8 |
| H08 | filters and search together (random lists from a per-submission seed, compared with DSC's reference) | 10 |
| H09 | listeners | 6 |
| H10 | acknowledge | 8 |
| H11 | screen states | 8 |
| H12 | architecture | 6 |

A row with several cases gives partial credit: weight × passed ÷ total. Late policy: ×1.0 within 72 hours of the session starting, ×0.6 for the following 7 days, ×0.5 after that until Thu 3 Dec 23:59; W5 reopens W2–W4 at ×1.0. Your best attempt counts.

Hard-coding the public examples scores nothing on H08, and a working app that ignores the layering loses H12. Copying a classmate's repository shows up in the similarity report your mentors see.

## Running the public tests

```bash
flutter test test/public_test.dart
```

They cover a small part of each area. Passing them is necessary, not sufficient: write your own tests for the edge cases above (the README is the spec).

## `AI_USAGE.md` (required)

AI tools are allowed. Fill in `AI_USAGE.md`: the tools you used; the two or three most useful prompts (paraphrased is fine); one thing the AI got wrong or left out, and how you found it (a test, the docs, running it); and, in two sentences of your own, why `visibleAlerts` lives in the view model and not in the screen.
