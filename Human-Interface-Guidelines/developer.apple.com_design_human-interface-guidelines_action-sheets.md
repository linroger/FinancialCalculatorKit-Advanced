---
url: "https://developer.apple.com/design/human-interface-guidelines/action-sheets"
title: "Action sheets | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/action-sheets#app-main)

# Action sheets

An action sheet is a modal view that presents choices related to an action people initiate.

![A stylized representation of a set of action sheet buttons at the bottom of an iPhone. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/6102d0ab9e98aa9149e6a929f0576d75/components-action-sheet-intro%402x.png)

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#Best-practices)

**Use an action sheet — not an alert — to offer choices related to an intentional action.** For example, when people cancel the Mail message they’re editing, an action sheet provides three choices: delete the edits (or the entire draft), save the draft, or return to editing. Although an alert can also help people confirm or cancel an action that has destructive consequences, it doesn’t provide additional choices related to the action. More importantly, an alert is usually unexpected, generally telling people about a problem or a change in the current situation that might require them to act. For guidance, see [Alerts](https://developer.apple.com/design/human-interface-guidelines/alerts).

**Use action sheets sparingly.** Action sheets give people important information and choices, but they interrupt the current task to do so. To encourage people to pay attention to action sheets, avoid using them more than necessary.

**Aim to keep titles short enough to display on a single line.** A long title is difficult to read quickly and might get truncated or require people to scroll.

**Provide a message only if necessary.** In general, the title — combined with the context of the current action — provides enough information to help people understand their choices.

**If necessary, provide a Cancel button that lets people reject an action that might destroy data.** Place the Cancel button at the bottom of the action sheet (or in the upper-left corner of the sheet in watchOS). A SwiftUI confirmation dialog includes a Cancel button by default.

**Make destructive choices visually prominent.** Use the destructive style for buttons that perform destructive actions, and place these buttons at the top of the action sheet where they tend to be most noticeable. For developer guidance, see [`destructive`](https://developer.apple.com/documentation/SwiftUI/ButtonRole/destructive) (SwiftUI) or [`UIAlertAction.Style.destructive`](https://developer.apple.com/documentation/UIKit/UIAlertAction/Style-swift.enum/destructive) (UIKit)

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#Platform-considerations)

_No additional considerations for macOS or tvOS. Not supported in visionOS._

### [iOS, iPadOS](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#iOS-iPadOS)

**Use an action sheet — not a menu — to provide choices related to an action.** People are accustomed to having an action sheet appear when they perform an action that might require clarifying choices. In contrast, people expect a menu to appear when they choose to reveal it.

**Avoid letting an action sheet scroll.** The more buttons an action sheet has, the more time and effort it takes for people to make a choice. Also, scrolling an action sheet can be hard to do without inadvertently tapping a button.

### [watchOS](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#watchOS)

The system-defined style for action sheets includes a title, an optional message, a Cancel button, and one or more additional buttons. The appearance of this interface is different depending on the device.

![An illustration of an action sheet on Apple Watch, showing content that represents text in the top half of the watch screen and two stacked buttons in the bottom half. Both buttons use the 22-point corner radius.](https://docs-assets.developer.apple.com/published/e0d8c87ceb6d9d6b67491d212d276920/action-sheet-series-8%402x.png)

Each button has an associated style that conveys information about the button’s effect. There are three system-defined button styles:

| Style | Meaning |
| --- | --- |
| Default | The button has no special meaning. |
| Destructive | The button destroys user data or performs a destructive action in the app. |
| Cancel | The button dismisses the view without taking any action. |

**Avoid displaying more than four buttons in an action sheet, including the Cancel button.** When there are fewer buttons onscreen, it’s easier for people to view all their options at once. Because the Cancel button is required, aim to provide no more than three additional choices.

## [Resources](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#Related)

[Modality](https://developer.apple.com/design/human-interface-guidelines/modality)

[Sheets](https://developer.apple.com/design/human-interface-guidelines/sheets)

[Alerts](https://developer.apple.com/design/human-interface-guidelines/alerts)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/action-sheets\#Developer-documentation)

[`confirmationDialog(_:isPresented:titleVisibility:actions:)`](https://developer.apple.com/documentation/SwiftUI/View/confirmationDialog(_:isPresented:titleVisibility:actions:)-46zbb) — SwiftUI

[`UIAlertController.Style.actionSheet`](https://developer.apple.com/documentation/UIKit/UIAlertController/Style/actionSheet) — UIKit

Current page is Action sheets

##### Supported platforms

- [Action sheets](https://developer.apple.com/design/human-interface-guidelines/action-sheets#app-top)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/action-sheets#Best-practices)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/action-sheets#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/action-sheets#Resources)