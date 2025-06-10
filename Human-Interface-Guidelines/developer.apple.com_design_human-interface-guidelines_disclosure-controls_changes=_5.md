---
url: "https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5"
title: "Disclosure controls | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#app-main)

# Disclosure controls

Disclosure controls reveal and hide information and functionality related to specific controls or views.

![A stylized representation of collapsed and expanded disclosure buttons. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/d9f8c2e1696219ad884582186a447524/components-disclosure-control-intro%402x.png)

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Best-practices)

**Use a disclosure control to hide details until they’re relevant.** Place controls that people are most likely to use at the top of the disclosure hierarchy so they’re always visible, with more advanced functionality hidden by default. This organization helps people quickly find the most essential information without overwhelming them with too many detailed options.

## [Disclosure triangles](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Disclosure-triangles)

A disclosure triangle shows and hides information and functionality associated with a view or a list of items. For example, Keynote uses a disclosure triangle to show advanced options when exporting a presentation, and the Finder uses disclosure triangles to progressively reveal hierarchy when navigating a folder structure in list view.

![A screenshot of the Keynote app's export to PDF dialog in macOS. The dialog includes a closed disclosure triangle that expands to reveal a set of advanced options.](https://docs-assets.developer.apple.com/published/940fe48b19aaa4a4e76e704e9f506576/disclosure-triangle-before%402x.png)

![A screenshot of the Keynote app's export to PDF dialog in macOS. The dialog includes an expanded disclosure triangle that collapses to hide a set of advanced options.](https://docs-assets.developer.apple.com/published/1b10c2e496c8d0dca74d85d841d67e35/disclosure-triangle-after%402x.png)

A disclosure triangle points inward from the leading edge when its content is hidden and down when its content is visible. Clicking or tapping the disclosure triangle switches between these two states, and the view expands or collapses accordingly to accommodate the content.

**Provide a descriptive label when using a disclosure triangle.** Make sure your labels indicate what is disclosed or hidden, like “Advanced Options.”

For developer guidance, see [`NSButton.BezelStyle.disclosure`](https://developer.apple.com/documentation/AppKit/NSButton/BezelStyle-swift.enum/disclosure?changes=_5).

## [Disclosure buttons](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Disclosure-buttons)

A disclosure button shows and hides functionality associated with a specific control. For example, the macOS Save sheet shows a disclosure button next to the Save As text field. When people click or tap this button, the Save dialog expands to give advanced navigation options for selecting an output location for their document.

![A screenshot of a collapsed save dialog in macOS. The dialog includes a closed disclosure button that expands the dialog to reveal additional options.](https://docs-assets.developer.apple.com/published/41fe1293ec292d9ad86a405eea10ec9f/disclosure-button-before%402x.png)

![A screenshot of an expanded save dialog in macOS. The dialog includes an open disclosure button that collapses the dialog to hide some options.](https://docs-assets.developer.apple.com/published/4a9d1b5b20d1802f6dff607c63997899/disclosure-button-after%402x.png)

A disclosure button points down when its content is hidden and up when its content is visible. Clicking or tapping the disclosure button switches between these two states, and the view expands or collapses accordingly to accommodate the content.

**Place a disclosure button near the content that it shows and hides.** Establish a clear relationship between the control and the expanded choices that appear when a person clicks or taps a button.

**Use no more than one disclosure button in a single view.** Multiple disclosure buttons add complexity and can be confusing.

For developer guidance, see [`NSButton.BezelStyle.pushDisclosure`](https://developer.apple.com/documentation/AppKit/NSButton/BezelStyle-swift.enum/pushDisclosure?changes=_5).

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Platform-considerations)

_No additional considerations for macOS. Not supported in tvOS or watchOS._

### [iOS, iPadOS, visionOS](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#iOS-iPadOS-visionOS)

Disclosure controls are available in iOS, iPadOS, and visionOS with the SwiftUI [`DisclosureGroup`](https://developer.apple.com/documentation/SwiftUI/DisclosureGroup?changes=_5) view.

## [Resources](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Related)

[Outline views](https://developer.apple.com/design/human-interface-guidelines/outline-views?changes=_5)

[Lists and tables](https://developer.apple.com/design/human-interface-guidelines/lists-and-tables?changes=_5)

[Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons?changes=_5)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Developer-documentation)

[`DisclosureGroup`](https://developer.apple.com/documentation/SwiftUI/DisclosureGroup?changes=_5) — SwiftUI

[`NSButton.BezelStyle.disclosure`](https://developer.apple.com/documentation/AppKit/NSButton/BezelStyle-swift.enum/disclosure?changes=_5) — AppKit

[`NSButton.BezelStyle.pushDisclosure`](https://developer.apple.com/documentation/AppKit/NSButton/BezelStyle-swift.enum/pushDisclosure?changes=_5) — AppKit

#### [Videos](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5\#Videos)

[![](https://devimages-cdn.apple.com/wwdc-services/images/49/1636D358-5C36-4027-B204-81FFE4D05B7D/3455_wide_250x141_3x.jpg)\\
\\
Stacks, Grids, and Outlines in SwiftUI](https://developer.apple.com/videos/play/wwdc2020/10031)

Current page is Disclosure controls

##### Supported platforms

- [Disclosure controls](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#app-top)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#Best-practices)
- [Disclosure triangles](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#Disclosure-triangles)
- [Disclosure buttons](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#Disclosure-buttons)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/disclosure-controls?changes=_5#Resources)