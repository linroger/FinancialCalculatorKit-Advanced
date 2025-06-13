---
url: "https://developer.apple.com/design/human-interface-guidelines/sliders"
title: "Sliders | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/sliders#app-main)

# Sliders

A slider is a horizontal track with a control, called a thumb, that people can adjust between a minimum and maximum value.

![A stylized representation of a brightness slider. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://developer.apple.com/design/human-interface-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AAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAICM2Wz2v+IVUHgRXiHNAAAAAElFTkSuQmCC)

As a slider’s value changes, the portion of track between the minimum value and the thumb fills with color. A slider can optionally display left and right icons that illustrate the meaning of the minimum and maximum values.

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/sliders\#Best-practices)

**Customize a slider’s appearance if it adds value.** You can adjust a slider’s appearance — including track color, thumb image and tint color, and left and right icons — to blend with your app’s design and communicate intent. A slider that adjusts image size, for example, could show a small image icon on the left and a large image icon on the right.

**Use familiar slider directions.** People expect the minimum and maximum sides of sliders to be consistent in all apps, with minimum values on the leading side and maximum values on the trailing side (for horizontal sliders) and minimum values at the bottom and maximum values at the top (for vertical sliders). For example, people expect to be able to move a horizontal slider that represents a percentage from 0 percent on the leading side to 100 percent on the trailing side.

**Consider supplementing a slider with a corresponding text field and stepper.** Especially when a slider represents a wide range of values, people may appreciate seeing the exact slider value and having the ability to enter a specific value in a text field. Adding a stepper provides a convenient way for people to increment in whole values. For related guidance, see [Text fields](https://developer.apple.com/design/human-interface-guidelines/text-fields) and [Steppers](https://developer.apple.com/design/human-interface-guidelines/steppers).

![A partial screenshot of a horizontal linear slider without tick marks, followed by a text field and a stepper. The thumb is in the center of the slider and the text field displays 50%.](https://docs-assets.developer.apple.com/published/7b81536dca93efcad895b4967d8c4031/sliders-text-field%402x.png)

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/sliders\#Platform-considerations)

_Not supported in tvOS._

### [iOS, iPadOS](https://developer.apple.com/design/human-interface-guidelines/sliders\#iOS-iPadOS)

**Don’t use a slider to adjust audio volume.** If you need to provide volume control in your app, use a volume view, which is customizable and includes a volume-level slider and a control for changing the active audio output device. For guidance, see [Playing audio](https://developer.apple.com/design/human-interface-guidelines/playing-audio).

### [macOS](https://developer.apple.com/design/human-interface-guidelines/sliders\#macOS)

Sliders in macOS can also include tick marks, making it easier for people to pinpoint a specific value within the range.

In a linear slider without tick marks, the thumb is round, and the portion of track between the minimum value and the thumb is filled with color. In a linear slider with tick marks, the thumb is directional — pointing toward the tick marks — and the track isn’t tinted. A linear slider often includes supplementary icons that illustrate the meaning of the minimum and maximum values.

In a circular slider, the thumb appears as a small circle. Tick marks, when present, appear as evenly spaced dots around the circumference of the slider.

![A partial screenshot of a horizontal slider with the circular thumb in the middle.](https://docs-assets.developer.apple.com/published/65b348fd67b2f68951a8baba7a92f616/sliders-no-tick-marks%402x.png)Linear slider without tick marks

![A partial screenshot of a horizontal slider with the narrow lozenge-shape thumb between two tick marks in the middle of the slider.](https://docs-assets.developer.apple.com/published/d3518d708f370868b90e917f751b9577/sliders-tick-marks%402x.png)Linear slider with tick marks

![A partial screenshot of a circular slider with the thumb at the 12 o'clock position.](https://docs-assets.developer.apple.com/published/3f253ed199e7e92b6124e6161dd79152/sliders-circular%402x.png)Circular slider

**Consider giving live feedback as the value of a slider changes.** Live feedback shows people results in real time. For example, your Dock icons are dynamically scaled when adjusting the Size slider in Dock settings.

**Choose a slider style that matches peoples’ expectations.** A horizontal slider is ideal when moving between a fixed starting and ending point. For example, a graphics app might offer a horizontal slider for setting the opacity level of an object between 0 and 100 percent. Use circular sliders when values repeat or continue indefinitely. For example, a graphics app might use a circular slider to adjust the rotation of an object between 0 and 360 degrees. An animation app might use a circular slider to adjust how many times an object spins when animated — four complete rotations equals four spins, or 1440 degrees of rotation.

**Consider using a label to introduce a slider.** Labels generally use [sentence-style capitalization](https://help.apple.com/applestyleguide/#/apsgb744e4a3?sub=apdca93e113f1d64) and end with a colon. For guidance, see [Labels](https://developer.apple.com/design/human-interface-guidelines/labels).

**Use tick marks to increase clarity and accuracy.** Tick marks help people understand the scale of measurements and make it easier to locate specific values.

![A partial screenshot of the Energy Saver settings pane in macOS, cropped to show the slider that controls how long the display remains on after inactivity.](https://docs-assets.developer.apple.com/published/ea283c6d5a597b731b1c6fbacffe73d2/sliders-labels%402x.png)

**Consider adding labels to tick marks for even greater clarity.** Labels can be numbers or words, depending on the slider’s values. It’s unnecessary to label every tick mark unless doing so is needed to reduce confusion. In many cases, labeling only the minimum and maximum values is sufficient. When the values of the slider are nonlinear, like in the Energy Saver settings pane, periodic labels provide context. It’s also a good idea to provide a [tooltip](https://developer.apple.com/design/human-interface-guidelines/offering-help#macOS-visionOS) that displays the value of the thumb when people hold their pointer over it.

### [visionOS](https://developer.apple.com/design/human-interface-guidelines/sliders\#visionOS)

**Prefer horizontal sliders.** It’s generally easier for people to gesture from side to side than up and down.

### [watchOS](https://developer.apple.com/design/human-interface-guidelines/sliders\#watchOS)

A slider is a horizontal track — appearing as a set of discrete steps or as a continuous bar — that represents a finite range of values. People can tap buttons on the sides of the slider to increase or decrease its value by a predefined amount.

![An illustration that represents a watchOS screen with a brightness slider.](https://docs-assets.developer.apple.com/published/9b2bead664b38a208db844c2f30b4ed2/sliders-watchos%402x.png)

**If necessary, create custom glyphs to communicate what the slider does.** The system displays plus and minus signs by default.

## [Resources](https://developer.apple.com/design/human-interface-guidelines/sliders\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/sliders\#Related)

[Steppers](https://developer.apple.com/design/human-interface-guidelines/steppers)

[Pickers](https://developer.apple.com/design/human-interface-guidelines/pickers)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/sliders\#Developer-documentation)

[`Slider`](https://developer.apple.com/documentation/SwiftUI/Slider) — SwiftUI

[`UISlider`](https://developer.apple.com/documentation/UIKit/UISlider) — UIKit

[`NSSlider`](https://developer.apple.com/documentation/AppKit/NSSlider) — AppKit

## [Change log](https://developer.apple.com/design/human-interface-guidelines/sliders\#Change-log)

| Date | Changes |
| --- | --- |
| June 21, 2023 | Updated to include guidance for visionOS. |

Current page is Sliders

##### Supported platforms

- [Sliders](https://developer.apple.com/design/human-interface-guidelines/sliders#app-top)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/sliders#Best-practices)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/sliders#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/sliders#Resources)
- [Change log](https://developer.apple.com/design/human-interface-guidelines/sliders#Change-log)