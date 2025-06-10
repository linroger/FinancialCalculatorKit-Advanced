---
url: "https://developer.apple.com/design/human-interface-guidelines/images?changes=_5"
title: "Images | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#app-main)

# Images

To make sure your artwork looks great on all devices you support, learn how the system displays content and how to deliver art at the appropriate scale factors.

![A sketch of a photo, suggesting imagery. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/b0a68ac859ddb098858e92609997d307/foundations-images-intro%402x.png)

## [Resolution](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Resolution)

Different devices can display images at different resolutions. For example, a 2D device displays images according to the resolution of its screen.

A _point_ is an abstract unit of measurement that helps visual content remain consistent regardless of how it’s displayed. In 2D platforms, a point maps to a number of pixels that can vary according to the resolution of the display; in visionOS, a point is an angular value that allows visual content to scale according to its distance from the viewer.

When creating bitmap images, you specify a _scale factor_ which determines the resolution of an image. You can visualize scale factor by considering the density of pixels per point in 2D displays of various resolutions. For example, a scale factor of 1 (also called @1x) describes a 1:1 pixel density, where one pixel is equal to one point. High-resolution 2D displays have higher pixel densities, such as 2:1 or 3:1. A 2:1 density (called @2x) has a scale factor of 2, and a 3:1 density (called @3x) has a scale factor of 3. Because of higher pixel densities, high-resolution displays demand images with more pixels.

![Image of a circle that's in standard resolution at scale factor of @1x, and is 10 by 10 pixels.](https://docs-assets.developer.apple.com/published/a9b04545f30aff45ca503e263c02d464/image-resolution-1x%402x.png)1x (10x10 px)

![Image of a circle that's in high resolution at a scale factor of @2x, and is 20 by 20 pixels.](https://docs-assets.developer.apple.com/published/cf203acc0ee6299833fb2e5b5c4a7348/image-resolution-2x%402x.png)2x (20x20 px)

![Image of a circle that's in high resolution at a scale factor of @3x, and is 30 by 30 pixels.](https://docs-assets.developer.apple.com/published/0de9ee5144fc2278682eb211ac8f571d/image-resolution-3x%402x.png)3x (30x30 px)

**Provide high-resolution assets for all bitmap images in your app, for every device you support.** As you add each image to your project’s asset catalog, identify its scale factor by appending “@1x,” “@2x,” or “@3x” to its filename. Use the following values for guidance; for additional scale factors, see [Layout](https://developer.apple.com/design/human-interface-guidelines/layout?changes=_5).

| Platform | Scale factors |
| --- | --- |
| iPadOS, watchOS | @2x |
| iOS | @2x and @3x |
| visionOS | @2x or higher (see [visionOS](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#visionOS)) |
| macOS, tvOS | @1x and @2x |

**In general, design images at the lowest resolution and scale them up to create high-resolution assets.** When you use resizable vectorized shapes, you might want to position control points at whole values so that they’re cleanly aligned at 1x. This positioning allows the points to remain cleanly aligned to the raster grid at higher resolutions, because 2x and 3x are multiples of 1x.

## [Formats](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Formats)

As you create different types of images, consider the following recommendations.

| Image type | Format |
| --- | --- |
| Bitmap or raster work | De-interlaced PNG files |
| PNG graphics that don’t require full 24-bit color | An 8-bit color palette |
| Photos | JPEG files, optimized as necessary, or HEIC files |
| Flat icons, interface icons, and other flat artwork that requires high-resolution scaling | PDF or SVG files |

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Best-practices)

**Include a color profile with each image.** Color profiles help ensure that your app’s colors appear as intended on different displays. For guidance, see [Color management](https://developer.apple.com/design/human-interface-guidelines/color?changes=_5#Color-management).

**Always test images on a range of actual devices.** An image that looks great at design time may appear pixelated, stretched, or compressed when viewed on various devices.

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Platform-considerations)

_No additional considerations for iOS, iPadOS, or macOS._

### [tvOS](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#tvOS)

Layered images are at the heart of the Apple TV user experience. The system combines layered images, transparency, scaling, and motion to produce a sense of realism and vigor that evokes a personal connection as people interact with onscreen content.

#### [Parallax effect](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Parallax-effect)

_Parallax_ is a subtle visual effect the system uses to convey depth and dynamism when an element is in focus. As an element comes into focus, the system elevates it to the foreground, gently swaying it while applying illumination that makes the element’s surface appear to shine. After a period of inactivity, out-of-focus content dims and the focused element expands.

Layered images are required to support the parallax effect.

Video with custom controls.

Content description: An animation of a tvOS app icon moving to show the parallax effect.

[Play](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#)

#### [Layered images](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Layered-images)

A _layered image_ consists of two to five distinct layers that come together to form a single image. The separation between layers, along with use of transparency, creates a feeling of depth. As someone interacts with an image, layers closer to the surface elevate and scale, overlapping lower layers farther back and producing a 3D effect.

You can embed layered images in your app or retrieve them from a content server at runtime. For guidance on adding layered images to your app, see the [Parallax Previewer User Guide](https://help.apple.com/itc/parallaxpreviewer/).

**Use standard interface elements to display layered images.** If you use standard views and system-provided focus APIs — such as [`FocusState`](https://developer.apple.com/documentation/SwiftUI/FocusState?changes=_5) — layered images automatically get the parallax treatment when people bring them into focus.

**Identify logical foreground, middle, and background elements.** In foreground layers, display prominent elements like a character in a game, or text on an album cover or movie poster. Middle layers are perfect for secondary content and effects like shadows. Background layers are opaque backdrops that showcase the foreground and middle layers without upstaging them.

**Generally, keep text in the foreground.** Unless you want to obscure text, bring it to the foreground layer for clarity.

**Keep the background layer opaque.** Using varying levels of opacity to let content shine through higher layers is fine, but your background layer must be opaque — you’ll get an error if it’s not. An opaque background layer ensures your artwork looks great with parallax, drop shadows, and system backgrounds.

**Keep layering simple and subtle.** Parallax is designed to be almost unnoticeable. Excessive 3D effects can appear unrealistic and jarring. Keep depth simple to bring your content to life and add delight.

**Leave a safe zone around the foreground layers of your image.** When focused, content on some layers may be cropped as the layered image scales and moves. To ensure that essential content is always visible, keep it within a safe zone. For guidance, see [App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons?changes=_5).

**Always preview layered images.** To ensure your layered images look great on Apple TV, preview them throughout your design process using Xcode, the Parallax Previewer app for macOS, or the Parallax Exporter plug-in for Adobe Photoshop. Pay special attention as scaling and clipping occur, and readjust your images as needed to keep important content safe. After your layered images are final, preview them on an actual TV for the most accurate representation of what people will see. To download Parallax Previewer and Parallax Exporter, see [Resources](https://developer.apple.com/design/resources/#parallax-previewer).

### [visionOS](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#visionOS)

In visionOS, the area an image occupies typically varies when the system dynamically scales it according to the distance and angle at which people view it. This means that an image doesn’t line up 1:1 with screen pixels as it can in other platforms.

**Create a layered app icon.** App icons in visionOS are composed of two to three layers that provide the appearance of depth by moving at subtly different rates when the icon is in focus. For guidance, see visionOS [app icons](https://developer.apple.com/design/human-interface-guidelines/app-icons?changes=_5#visionOS).

**Prefer vector-based art.** Avoid bitmap content because it might not look good when the system scales it up. If you use Core Animation layers, see [Drawing sharp layer-based content in visionOS](https://developer.apple.com/documentation/visionOS/drawing-sharp-layer-based-content?changes=_5) for developer guidance.

**If you need to use rasterized images, balance quality with performance as you choose a resolution.** Although a @2x image looks fine at common viewing distances, its fixed resolution means that the system doesn’t dynamically scale it and it might not look sharp from close up. To help a rasterized image look sharp when people view it from a wide range of distances, you can use a higher resolution, but each increase in resolution results in a larger file size and may impact your app’s runtime performance, especially for resolutions over @6x. If you use images that have resolutions higher than @2x, be sure to also apply high-quality image filtering to help balance quality and performance (for developer guidance, see [`filters`](https://developer.apple.com/documentation/QuartzCore/CALayer/filters?changes=_5)).

### [watchOS](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#watchOS)

**In general, avoid transparency to keep image files small.** If you always composite an image on the same solid background color, it’s more efficient to include the background in the image. However, transparency is necessary in complication images, menu icons, and other interface icons that serve as template images, because the system uses it to determine where to apply color.

**Use autoscaling PDFs to let you provide a single asset for all screen sizes.** Design your image for the 40mm and 42mm screens at 2x. When you load the PDF, WatchKit automatically scales the image based on the device’s screen size, using the values shown below:

| Screen size | Image scale |
| --- | --- |
| 38mm | 90% |
| 40mm | 100% |
| 41mm | 106% |
| 42mm | 100% |
| 44mm | 110% |
| 45mm | 119% |
| 49mm | 119% |

## [Resources](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Related)

[Apple Design Resources](https://developer.apple.com/design/resources/)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Developer-documentation)

[Drawing sharp layer-based content in visionOS](https://developer.apple.com/documentation/visionOS/drawing-sharp-layer-based-content?changes=_5) — visionOS

[Images](https://developer.apple.com/documentation/SwiftUI/Images?changes=_5) — SwiftUI

[`UIImageView`](https://developer.apple.com/documentation/UIKit/UIImageView?changes=_5) — UIKit

[`NSImageView`](https://developer.apple.com/documentation/AppKit/NSImageView?changes=_5) — AppKit

#### [Videos](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Videos)

[![](https://devimages-cdn.apple.com/wwdc-services/images/D35E0E85-CCB6-41A1-B227-7995ECD83ED5/8226C70F-64DC-4FF1-9956-2DC0751A2143/8241_wide_250x141_3x.jpg)\\
\\
Support HDR images in your app](https://developer.apple.com/videos/play/wwdc2023/10181)

[![](https://devimages-cdn.apple.com/wwdc-services/images/7/09438FDD-3E8B-42A3-A364-78E1A7F2CE6B/1915_wide_250x141_3x.jpg)\\
\\
Get Started with Display P3](https://developer.apple.com/videos/play/wwdc2017/821)

## [Change log](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5\#Change-log)

| Date | Changes |
| --- | --- |
| December 5, 2023 | Clarified guidance on choosing a resolution for a rasterized image in a visionOS app. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| September 14, 2022 | Added specifications for Apple Watch Ultra. |

Current page is Images

##### Supported platforms

- [Images](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#app-top)
- [Resolution](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Resolution)
- [Formats](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Formats)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Best-practices)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Resources)
- [Change log](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Change-log)