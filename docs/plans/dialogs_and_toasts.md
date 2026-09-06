# Dialogs and toasts

## Problem

- Apps repeat dialog and toast behavior from an app-specific utility.
- That utility depends on routing, error parsing, and a toast package.
- Reusable feedback should work without those app dependencies.

## Goal

- Provide themed dialog and toast APIs for Thanks Flutter applications.
- Place transient feedback at the top center with a clear top margin.
- Confirm behavior with widget tests and static checks.

## Steps

1. **Add dialog APIs** — Verified.

   ### Outcome

   - Add action, display, confirmation, and bottom-sheet dialog helpers.

   ### Actions

   1. Add a context-driven dialog presenter and action model.
   2. Use existing Material controls and Thanks spacing tokens.
   3. Add widget tests for dialog actions and confirmation results.

   ### Verification

   - Dialog actions dismiss with their expected result.
   - Confirmation returns true or false.

2. **Add top-centered toast APIs** — Verified.

   ### Outcome

   - Add success, error, and info overlay toasts.

   ### Actions

   1. Use the root overlay rather than a bottom `ScaffoldMessenger` snackbar.
   2. Provide a default top margin and short dismissal duration.
   3. Replace any visible toast before showing another.
   4. Add widget tests for placement and replacement behavior.

   ### Verification

   - Toasts appear at the top center and disappear automatically.
   - A second toast replaces the first.

3. **Export and verify** — Verified.

   ### Outcome

   - Expose the new APIs and record complete local verification.

   ### Actions

   1. Export public files from the package entry point.

   ### Verification

   - Run formatter, analyzer, and the package test suite.

4. **Add notice dialog helper** — Verified.

   ### Outcome

   - Add a one-button dialog for acknowledgement messages.

   ### Actions

   1. Add `ThanksDialog.notice` with an `OK` action by default.
   2. Add a widget test for dismissing the notice.

   ### Verification

   - The helper shows one action and completes when it is tapped.

5. **Add dialog action factories** — Verified.

   ### Outcome

   - Add concise constructors for primary, destructive, and secondary actions.

   ### Actions

   1. Require a label and callback for each factory.
   2. Apply action style and focus defaults inside each factory.
   3. Add tests for the factory defaults.

   ### Verification

   - Only primary actions receive autofocus by default.

6. **Add dialog keyboard behavior** — Verified.

   ### Outcome

   - Escape respects dismissal policy and focused buttons handle Enter.

   ### Actions

   1. Map Escape to dialog dismissal only when the barrier is dismissible.
   2. Consume Escape when dismissal is disabled.
   3. Test Escape for both dismissal modes and Enter for primary actions.

   ### Verification

   - Escape cannot close a non-dismissible dialog.
   - Enter activates the autofocus primary action.

7. **Make dialog sizing content-responsive** — Verified.

   ### Outcome

   - Dialogs use a `fit_it` width cap and intrinsic content height.

   ### Actions

   1. Replace the fixed width parameter with a `FitSize` maximum.
   2. Remove manual content width and height constraints.
   3. Rely on `AlertDialog.scrollable` for overflowing content.
   4. Add tests for the default cap and compact content height.

   ### Verification

   - A short dialog does not occupy a large portion of the viewport.
   - The default width cap uses `FitSize.mobile`.

## Scope

- Include context-driven dialogs, confirmations, bottom sheets, and toasts.
- Exclude app routing, failure parsing, color picking, and new dependencies.

## Requirements

- Callers provide a mounted `BuildContext`.
- Dialogs use active theme values and Thanks spacing tokens.
- Toasts are accessible and default to a three-second duration.
- Existing components remain unchanged.

## Migrations

- None.

## Observe

- Validate the APIs in a consuming app before replacing its old utility.
- Consider a third-party toast package only if app integration exposes a gap.
- Focused tests, static analysis, and whitespace checks passed.
- The full package suite has existing `ThanksScaffold` test failures.
