---
url: "https://developer.apple.com/design/human-interface-guidelines/tab-bars"
title: "Tab bars | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/tab-bars#app-main)

# Tab bars

A tab bar lets people navigate between top-level sections of your app.

![A stylized representation of a tab bar containing four placeholder icons with names. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/8737d6baf5cdb223521eb4dbe3cb45e5/components-tab-bar-intro%402x.png)

Tab bars help people understand the different types of information or functionality that an app provides. They also let people quickly switch between sections of the view while preserving the current navigation state within each section.

For guidance using a similar component in macOS, see [tab views](https://developer.apple.com/design/human-interface-guidelines/tab-views).

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Best-practices)

**Use a tab bar to support navigation, not to provide actions.** A tab bar lets people navigate among different sections of an app, like the Alarm, Stopwatch, and Timer tabs in the Clock app. If you need to provide controls that act on elements in the current view, use a [toolbar](https://developer.apple.com/design/human-interface-guidelines/toolbars) instead.

**Make sure the tab bar is visible when people navigate to different sections of your app.** If you hide the tab bar, people can forget which area of the app they’re in. The exception is when a modal view covers the tab bar, because a modal is temporary and self-contained.

**Use the appropriate number of tabs required to help people navigate your app.** As a representation of your app’s hierarchy, it’s important to weigh the complexity of additional tabs against the need for people to frequently access each section; keep in mind that it’s generally easier to navigate among fewer tabs. Where available, consider a sidebar or a tab bar that adapts to a sidebar as an alternative for an app with a complex information structure.

**Avoid overflow tabs whenever possible.** Depending on device size and orientation, the number of visible tabs can be smaller than the total number of tabs. If horizontal space limits the number of visible tabs, the trailing tab becomes a More tab in iOS and iPadOS, revealing the remaining items in a separate list. The More tab makes it harder for people to reach and notice content on tabs that are hidden, so try to limit scenarios in your app where this can happen.

**Don’t disable or hide tab bar buttons, even when their content is unavailable.** Having tab bar buttons available in some cases but not others makes your app’s interface appear unstable and unpredictable. If a section is empty, explain why its content is unavailable.

**Use a succinct term for each tab title.** A useful tab title aids navigation by clearly describing the type of content or functionality the tab contains. Use single words whenever possible.

**Use a badge to unobtrusively communicate that information is available.** You can display a badge — a red oval containing white text and either a number or an exclamation point — on a tab to indicate that there’s new or updated information in the section that may warrant a person’s attention. For guidance, see [Notifications](https://developer.apple.com/design/human-interface-guidelines/notifications).

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Platform-considerations)

_No additional considerations for macOS. Not supported in watchOS._

### [iOS](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#iOS)

By default, a tab bar is translucent: It uses a background material only when content appears behind it, removing the material when the view scrolls to the bottom. A keyboard covers the tab bar when it’s onscreen.

**Consider using SF Symbols to provide scalable, visually consistent tab bar icons.** When you use [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols), tab bar icons automatically adapt to different contexts. For example, the tab bar can be regular or compact, depending on the current device and orientation. Also, tab bar icons can appear above tab titles in portrait orientation, whereas in landscape, the icons and titles can appear side by side. Prefer filled symbols or icons for consistency with the platform.

![An illustration that represents two versions of the Photos app on iPhone, one in landscape and the other in portrait orientation.](https://docs-assets.developer.apple.com/published/073de700f9e4471c237135b4e5d2e2a4/tab-bar-landscape%402x.png)

If you need to create custom tab bar icons using bitmaps, create each icon in two sizes so that the tab bar looks good in both regular and compact environments. Use the following metrics when creating tab bar icons in different shapes. For guidance, see [Icons](https://developer.apple.com/design/human-interface-guidelines/icons).

### [Target dimensions](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Target-dimensions)

| Icon Shape | Regular tab bars | Compact tab bars |
| --- | --- | --- |
| Circle ![An illustration of a solid blue circle, which represents the target, centered inside the outlines of two squares. All three shapes are contained within the outline of a rectangle. The width of the inner square is slightly smaller than the diameter of the circle. The width of the outer square is the same as the diameter of the circle. The width of the rectangle is slightly larger than its height. A vertical line, extending to the top and bottom edges of the outer square, indicates the target’s height. A horizontal line, extending to left and right edges of the outer square, represents the target’s width.](https://docs-assets.developer.apple.com/published/26b47205d9825c5404ea773ed6729b94/tab-bars-max-width-height%402x.png) | 25x25 pt | 18x18 pt |
| 50x50 px @2x | 36x36 px @2x |
| 75x75 px @3x | 54x54 px @3x |
| Square ![An illustration of a solid blue square, which represents the target, centered inside the outline of a slightly larger square. Both shapes are contained within the outline of a rectangle. The solid blue square is slightly smaller than the outlined square. The width of the rectangle is slightly larger than its height. A vertical line, extending to the top and bottom edges of the blue square, represents the square’s height. A horizontal line, extending to left and right edges of the blue square, indicates the target’s width.](https://docs-assets.developer.apple.com/published/dcc8daa9fb52d000d4310f6608a421c4/tab-bars-target-width%402x.png) | 23x23 pt | 17x17 pt |
| 46x46 px @2x | 34x34 px @2x |
| 69x69 px @3x | 51x51 px @3x |
| Wide ![An illustration of a solid blue rectangle, which represents the target, vertically centered inside the outline of a larger rectangle. The height of the blue rectangle is approximately half the height of the outlined rectangle. The outlines of two squares are horizontally centered within the outlined rectangle. The width of the outlined rectangle is slightly larger than its height. A horizontal line, extending to left and right edges of the outlined rectangle, represents the target’s width.](https://docs-assets.developer.apple.com/published/c6f2110e4f7da04a8edb66fd2c5f2871/tab-bars-target-width-height%402x.png) | 31 pt | 23 pt |
| 62 px @2x | 46 px @2x |
| 93 px @3x | 69 px @3x |
| Tall ![An illustration of a solid blue rectangle, which represents the target, horizontally centered inside the outline of a larger rectangle. The width of the blue rectangle is approximately half the width of the outlined rectangle. The outlines of two squares are horizontally centered within the outlined rectangle. The width of the outlined rectangle is slightly larger than its height. A vertical line, extending to top and bottom edges of the outlined rectangle, represents the target’s height.](https://docs-assets.developer.apple.com/published/c3f7f2f71d93e46207f7cba13747b529/tab-bars-target-height%402x.png) | 28 pt | 20 pt |
| 56 px @2x | 40 px @2x |
| 84 px @3x | 60 px @3x |

### [iPadOS](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#iPadOS)

Starting with iPadOS 18, the system displays a tab bar near the top of the screen. You can choose to have the tab bar appear as a fixed element, or include a button that converts it to a sidebar. For developer guidance, see [`tabBarOnly`](https://developer.apple.com/documentation/SwiftUI/TabViewStyle/tabBarOnly) and [`sidebarAdaptable`](https://developer.apple.com/documentation/SwiftUI/TabViewStyle/sidebarAdaptable).

![A screenshot showing the Music app on iPad with the tab bar near the top of the screen.](https://docs-assets.developer.apple.com/published/9b9a89b3054e378850b30d58483e6169/ipad-tab-bar-music-app%402x.png)

![A screenshot showing the Music app on iPad with the tab bar converted to a sidebar on the leading edge of the screen.](https://docs-assets.developer.apple.com/published/c4b4962c5db1ab54e229a67afd5f065a/ipad-sidebar-music-app%402x.png)

**Prefer a tab bar for navigation.** A tab bar provides access to the sections of your app that people use most. If your app is more complex, you can provide the option to convert the tab bar to a sidebar so people can access a wider set of navigation options.

**Let people customize the tab bar.** In apps with a lot of sections that people might want to access, it can be useful to let people select items that they use frequently and add them to the tab bar, or remove items that they use less frequently. For example, in the Music app, a person can choose a favorite playlist to display in the tab bar. For developer guidance, see [`TabViewCustomization`](https://developer.apple.com/documentation/SwiftUI/TabViewCustomization) and [`UITab.Placement`](https://developer.apple.com/documentation/UIKit/UITab/Placement).

### [tvOS](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#tvOS)

A tab bar is highly customizable. For example, you can:

- Specify a tint, color, or image for the tab bar background

- Choose a font for tab items, including a different font for the selected item

- Specify tints for selected and unselected items

- Add button icons, like settings and search


By default, a tab bar is translucent, and only the selected tab is opaque. When people use the remote to focus on the tab bar, the selected tab includes a drop shadow that emphasizes its selected state. The height of a tab bar is 68 points, and its top edge is 46 points from the top of the screen; you can’t change either of these values.

If there are more items than can fit in the tab bar, the system truncates the rightmost item by applying a fade effect that begins at the right side of the tab bar. If there are enough items to cause scrolling, the system also applies a truncating fade effect that starts from the left side.

**If you use an icon for a tab title, make sure it’s familiar.** You can use icons as tab titles to help save space, but only for universally recognized symbols like search or settings. Using an unfamiliar symbol without a descriptive title can confuse people. For guidance, see [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols).

**Be aware of tab bar scrolling behaviors.** By default, people can scroll the tab bar offscreen when the current tab contains a single main view. You can see examples of this behavior in the Watch Now, Movies, TV Show, Sports, and Kids tabs in the TV app. The exception is when a screen contains a split view, such as the TV app’s Library tab or an app’s Settings screen. In this case, the tab bar remains pinned at the top of the view while people scroll the content within the primary and secondary panes of the split view. Regardless of a tab’s contents, focus always returns to the tab bar at the top of the page when people press Menu on the remote.

**In a live-viewing app, organize tabs in a consistent way.** For the best experience, organize content in live-streaming apps with tabs in the following order:

- Live content

- Cloud DVR or other recorded content

- Other content


For additional guidance, see [Live-viewing apps](https://developer.apple.com/design/human-interface-guidelines/live-viewing-apps).

**Create a branded logo image to display next to the leading or trailing end of the tab bar, if it makes sense in your app.** To ensure enough room between the branded logo image and the edge of the tab bar, place the image within the safe margin. Use the following image size values for guidance:

| Maximum width | Maximum height |
| --- | --- |
| 200 pt | 68 pt |

### [visionOS](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#visionOS)

In visionOS, a tab bar is always vertical, floating in a position that’s fixed relative to the window’s leading side. When people look at a tab bar, it automatically expands; to open a specific tab, people look at the tab and tap. While a tab bar is expanded, it can temporarily obscure the content behind it.

Video with custom controls.

Content description: A recording showing a closeup of a tab bar along the side of an app's window in visionOS. The tab bar includes only symbols. The currently selected tab receives the hover effect, showing that someone is looking at it, and the bar expands to display both symbols and titles.

[Play](https://developer.apple.com/design/human-interface-guidelines/tab-bars#)

**Supply a symbol and a text title for each tab.** A tab’s symbol is always visible in the tab bar. When people look at the tab bar, the system reveals tab titles, too. Even though the tab bar expands, you need to keep tab titles short so people can read them at a glance.

![A screenshot showing a collapsed tab bar containing only symbols.](https://docs-assets.developer.apple.com/published/71541ceda25ac9006d5546e5f8db7543/visionos-tab-bar-collapsed%402x.png)Collapsed

![A screenshot showing an expanded tab bar containing both symbols and titles.](https://docs-assets.developer.apple.com/published/9bd2d4bd920f88ad71d5b586bfa7ad6d/visionos-tab-bar-expanded%402x.png)Expanded

**If it makes sense in your app, consider using a sidebar within a tab.** If your app’s hierarchy is deep, you might want to use a [sidebar](https://developer.apple.com/design/human-interface-guidelines/sidebars) to support secondary navigation within a tab. If you do this, be sure to prevent selections in the sidebar from changing which tab is currently open.

## [Resources](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Related)

[Tab views](https://developer.apple.com/design/human-interface-guidelines/tab-views)

[Toolbars](https://developer.apple.com/design/human-interface-guidelines/toolbars)

[Sidebars](https://developer.apple.com/design/human-interface-guidelines/sidebars)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Developer-documentation)

[`TabView`](https://developer.apple.com/documentation/SwiftUI/TabView) — SwiftUI

[Enhancing your app’s content with tab navigation](https://developer.apple.com/documentation/SwiftUI/Enhancing-your-app-content-with-tab-navigation) — SwiftUI

[`UITabBar`](https://developer.apple.com/documentation/UIKit/UITabBar) — UIKit

[Elevating your iPad app with a tab bar and sidebar](https://developer.apple.com/documentation/UIKit/elevating-your-ipad-app-with-a-tab-bar-and-sidebar) — UIKit

#### [Videos](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Videos)

[![](https://devimages-cdn.apple.com/wwdc-services/images/3055294D-836B-4513-B7B0-0BC5666246B0/1AAA030E-2ECA-47D8-AE09-6D7B72A840F6/10044_wide_250x141_3x.jpg)\\
\\
Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356)

[![](https://devimages-cdn.apple.com/wwdc-services/images/3055294D-836B-4513-B7B0-0BC5666246B0/873F40BE-101A-4C0D-99F0-F5C7CE7B47A3/10046_wide_250x141_3x.jpg)\\
\\
Elevate the design of your iPad app](https://developer.apple.com/videos/play/wwdc2025/208)

## [Change log](https://developer.apple.com/design/human-interface-guidelines/tab-bars\#Change-log)

| Date | Changes |
| --- | --- |
| September 9, 2024 | Added art representing the tab bar in iPadOS 18. |
| August 6, 2024 | Updated with guidance for the tab bar in iPadOS 18. |
| June 21, 2023 | Updated to include guidance for visionOS. |

Current page is Tab bars

##### Supported platforms

- [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars#app-top)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/tab-bars#Best-practices)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/tab-bars#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/tab-bars#Resources)
- [Change log](https://developer.apple.com/design/human-interface-guidelines/tab-bars#Change-log)