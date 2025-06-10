---
url: "https://developer.apple.com/design/human-interface-guidelines/segmented-controls"
title: "Segmented controls | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#app-main)

# Segmented controls

A segmented control is a linear set of two or more segments, each of which functions as a button.

![A stylized representation of a selected segment in a segmented control. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://developer.apple.com/design/human-interface-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AAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAICM2Wz2v+IVUHgRXiHNAAAAAElFTkSuQmCC)

Within a segmented control, all segments are usually equal in width. Like buttons, segments can contain text or images. Segments can also have text labels beneath them (or beneath the control as a whole).

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Best-practices)

A segmented control can offer a single choice or multiple choices. For example, in Keynote people can select only one segment in the alignment options control to align selected text. In contrast, people can choose multiple segments in the font attributes control to combine styles like bold, italics, and underline. The toolbar of a Keynote window also uses a segmented control to let people show and hide various editing panes within the main window area.

![A partial screenshot of a segmented control that consists of four text-alignment options. The center alignment option is selected.](https://docs-assets.developer.apple.com/published/8c06202270aa61dbeb3f3f76525c2cf2/segmented-control-one-choice%402x.png)Single choice

![A partial screenshot of a segmented control that consists of four font types. Three of the four options are selected.](https://docs-assets.developer.apple.com/published/2da0fa7f757bf9a6332fa69b4c4f8514/segmented-control-multiple-choices%402x.png)Multiple choices

**Use a segmented control to provide closely related choices that affect an object, state, or view.** For example, a segmented control can help people switch between views in a toolbar. Avoid using a segmented control to offer actions, such as adding, removing, or editing content.

**Avoid crowding the control with too many segments.** Too many segments can be hard to parse and time-consuming to navigate. Aim for no more than about five to seven segments in a wide interface and no more than about five segments on iPhone.

**In general, keep segment size consistent.** When all segments have equal width, a segmented control feels balanced. To the extent possible, it’s best to keep icon and title widths consistent too.

## [Content](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Content)

**Prefer using either text or images — not a mix of both — in a single segmented control.** Although individual segments can contain text labels or images, mixing the two in a single control can lead to a disconnected and confusing interface.

**As much as possible, use content with a similar size in each segment.** Because all segments typically have equal width, it doesn’t look good if content fills some segments but not others.

**Use nouns or noun phrases for segment labels.** Write text that describes each segment and uses [title-style capitalization](https://support.apple.com/guide/applestyleguide/c-apsgb744e4a3/web#apdca93e113f1d64). A segmented control that displays text labels doesn’t need introductory text.

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Platform-considerations)

_Not supported in watchOS._

### [iOS, iPadOS](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#iOS-iPadOS)

**Avoid using a segmented control in a toolbar.** [Toolbar](https://developer.apple.com/design/human-interface-guidelines/toolbars) items act on the current screen — they don’t let people switch contexts like segmented controls do.

![A partial screenshot of the Recents list in the Phone app, which displays a segmented control in the top toolbar that contains two segments: All and Missed.](https://docs-assets.developer.apple.com/published/7e73d6b155162202f8d031a2182dfdf9/segmented-controls-phone-recents%402x.png)

### [macOS](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#macOS)

**Consider using introductory text to clarify the purpose of a segmented control.** When the control uses symbols or interface icons, you could also add a label below each segment to clarify its meaning. If your app includes tooltips, provide one for each segment in a segmented control.

**Use a tab view in the main window area — instead of a segmented control — for view switching.** A [tab view](https://developer.apple.com/design/human-interface-guidelines/tab-views) supports efficient view switching and is similar in appearance to a [box](https://developer.apple.com/design/human-interface-guidelines/boxes) combined with a segmented control. Consider using a segmented control to help people switch views in a toolbar or inspector pane.

![A screenshot of the macOS Calendar app, which displays a segmented control in the toolbar that contains four segments: Day, Week, Month, and Year.](https://docs-assets.developer.apple.com/published/bdd3f3a87456d2e7cf735edab19353ea/segmented-controls-mac-calendar%402x.png)

**Size custom interface icons appropriately based on the size of the control.** Use the following values for guidance.

![A partial screenshot of three regular-size icons in a regular-size segmented control.](https://docs-assets.developer.apple.com/published/983e3ff02ca8019fbdc26f270c729144/segmented-control-icons-regular%402x.png)Regular

![A partial screenshot of three small-size icons in a small-size segmented control.](https://docs-assets.developer.apple.com/published/1d88d2369778727e3f09396ed8646280/segmented-control-icons-small%402x.png)Small

![A partial screenshot of three mini-size icons in a mini-size segmented control.](https://docs-assets.developer.apple.com/published/7ad3599ca30edc73780b2dbea74821ba/segmented-control-icons-mini%402x.png)Mini

| Control size | Icon size |
| --- | --- |
| Regular | 17x17 px @1x (34x34 px @2x) |
| Small | 14x13 px @1x (28x26 px @2x) |
| Mini | 12x11 px @1x (24x22 px @2x) |

**Consider supporting spring loading.** On a Mac equipped with a Magic Trackpad, spring loading lets people activate a segment by dragging selected items over it and force clicking without dropping the selected items. People can also continue dragging the items after a segment activates.

### [tvOS](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#tvOS)

**Consider using a split view instead of a segmented control on screens that perform content filtering.** People generally find it easy to navigate back and forth between content and filtering options using a split view. Depending on its placement, a segmented control may not be as easy to access.

**Avoid putting other focusable elements close to segmented controls.** Segments become selected when focus moves to them, not when people click them. Carefully consider where you position a segmented control relative to other interface elements. If other focusable elements are too close, people might accidentally focus on them when attempting to switch between segments.

### [visionOS](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#visionOS)

When people look at a segmented control that uses icons, the system displays a tooltip that contains the descriptive text you supply.

## [Resources](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Related)

[Split views](https://developer.apple.com/design/human-interface-guidelines/split-views)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Developer-documentation)

[`segmented`](https://developer.apple.com/documentation/SwiftUI/PickerStyle/segmented) — SwiftUI

[`UISegmentedControl`](https://developer.apple.com/documentation/UIKit/UISegmentedControl) — UIKit

[`NSSegmentedControl`](https://developer.apple.com/documentation/AppKit/NSSegmentedControl) — AppKit

## [Change log](https://developer.apple.com/design/human-interface-guidelines/segmented-controls\#Change-log)

| Date | Changes |
| --- | --- |
| June 21, 2023 | Updated to include guidance for visionOS. |

Current page is Segmented controls

##### Supported platforms

- [Segmented controls](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#app-top)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#Best-practices)
- [Content](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#Content)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#Resources)
- [Change log](https://developer.apple.com/design/human-interface-guidelines/segmented-controls#Change-log)