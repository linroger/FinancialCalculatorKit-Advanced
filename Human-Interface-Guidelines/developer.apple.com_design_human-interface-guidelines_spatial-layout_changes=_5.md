---
url: "https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5"
title: "Spatial layout | Apple Developer Documentation"
---

[Skip Navigation](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#app-main)

# Spatial layout

Spatial layout techniques help you take advantage of the infinite canvas of Apple Vision Pro and present your content in engaging, comfortable ways.

![A sketch of axes in the X, Y, and Z dimensions, suggesting three-dimensional layout. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://developer.apple.com/design/human-interface-guidelines/iVBORw0KGgoAAAANSUhEUgAAAyAAAAJYCAYAAACadoJwAAAACXBIWXMAABYlAAAWJQFJUiTwAAAYpUlEQVR4nO3df2sU6Z7G4d5VDGkmICgRBSGgRBDm/b+J+W9gBgOBQMBMNI46SkIkuss3O32Oc1bNU0nV3VXd1wVh2J1MUt1dcOqT59d//fLLL/8zAwAACPhvbzIAAJAiQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIi57a0GYIrevXs3Oz09vbzy+Xw+u3v3rs8RYAIECACTUtGxv78/+/Tp0z8u+86dO7MnT55cxggA42UKFgCT8fnz59ne3t7/i49S/7/v/TsAxkOAADAZh4eHlxHyPfXvXr586QMFGDEBAsBk1LqPq7R8DwDLI0AAmIQ3b978cPRjoeV7AFgeAQLAJLSObNy6dcsHCjBiAgSA0atRjdYAsR0vwLgJEABGr6ZftRIgAOMmQAAYvZOTk6ZLrOlXAgRg3AQIAKNWBw+enZ01XeK9e/d8mAAjJ0AAGLUu068ECMD4CRAARq118fnm5uZsPp/7MAFGToAAMFoVH58+fWq6vPv37/sgASZAgAAwWl1ONTf9CmAaBAgAo1Rnf7Su/6idrxxACDANAgSAUeoy+mHrXYDpECAAjNLx8XHTZdXIh+lXANMhQAAYnVp43nr2h9EPgGkRIACMTuvJ52V7e9sHCDAhAgSA0WldfH7nzh1nfwBMzG0fGEB/auem09PT2YcPHy6nEbWeYbEOaq3GkydPrnyli/eu1d7eXu/vXoVNfW1tbV0Gjh22APojQABuqKKjdmyqRdOt6xbWUetC8devXze/O0NH3tHR0eU/65T1Bw8e2O4XoAcCBOAGXr58OXv16tVlhPBjrWs13r9/P7p3ssLy4ODgMj7qdTx69GgEVwUwTQIE4BpqmlU9kBrxaNO6VqPWfnz58mUcF/0NFZo1KlIjXjs7O9afAFyDRegAHVV81LoD8dGudfpV6+LzZavPvu6BuhcA6EaAAHSwiA9Trrq5f//+ld9fazlqAfpU1D0gQgC6EyAAjeqBc39/X3x0VDtJ1RSsq9S0pqlxTwB0J0AAGh0eHtpW9xpap1/VLmJTVPdEbUYAQBsBAtCgHjKnsj5hbGrr2qvUNKYpx13thCZOAdoIEIAG/sJ9PTX60XJuxirEnXsEoI1teAEaXGd9Qq19qAfw1jUQ66w1QOpAwOfPnw/2Ti0Wwtf1dF0QP8U1LADLIEAArlAPol0WGddD8uPHjy/Dg6vVg3vr+9uym9ZNVChWNNZXfe511kvr1Kp6DfXf+NwBfswULIArdPlLeMXHs2fPPIR20GXkoHVBex/qM6zRlvpMW01pG2GAZREgAFf4+PFj81v09OnTpjUP/J8aNWidflWL2dPvbf2+OvG8VZd7BWBdCRCAK5yfnze9RfXXeWs9uhnr6MfX5vN58+9uvVcA1pkAAbhC6xqA7e1tb2VHrWd/1EhEy3a+Q2n9bG3FC3A1AQLQk/pLOe3qYf3s7Kzp+5cZHzOfLUCvBAhADyw6767LyedjGF3yGQP0Q4AA/IApNcNpXf9R62qMQACsDgEC8AMWlQ+jtqttjbsHDx5M7wUC8F0CBIC41q13ZyNY/wFAvwQIAFF19kfr9Ktad2EUCmC1CBAAoio+KkJaLOvsDwCGI0AAiGod/Vj22R8ADEOAABBTC89bA6TioyIEgNUiQACIaY2PmcXnACtLgAAQ03r4YC08FyAAq+m2zxVg2k5PT2cfP36cXVxcXP5z9vcD/OIAv9pJagxTmeo6W8/+EB8Aq0uAAExQ7SJVowl1nkbLQ3090G9vb1/GyLJ0OfvD4YMAq0uAAEzMq1evZi9fvmzeynb299qL+qoQ2dnZWcqISGuAbG5uOvsDYIVZAwIwERUc+/v7s8PDw07x8bWKkF9//fVyOlRSl7M/jH4ArDYBAjAB9fD+4sWLTrtIfU/9rL29vWiEdJl+Zf0HwGoTIAATcHBwMDs7O+vtQpMRUr/L2R8ALAgQgJGr9R59jHz8pwqDCpvrTudq1WX04969e4NeCwDLJ0AARqx2uDo6OhrsAmtUpfVsjus6OTlp+i9r5MP0K4DVJ0AARqxGP4ZWu2oNNQpSAdU6dczoB8B6ECAAI1VR0GX60nUN+Xu6jK4IEID1IEAARmqIdR/f0zpNqqvW17A4tR2A1SdAAEbqw4cPsQvrc4ethYqPllPaZ87+AFgrAgRgpFof3vvSd/B0GcGx+BxgfQgQgJE6Pz+f7EfT9eyPmoIFwHoQIAAjlR4B6VPFR+vOWkY/ANaLAAEYqSmPCrTuquXsD4D1I0AARmpjY2OSH02N3LSuJ6n4qAgBYH0IEICRSo+AbG1t9fJzuiw+d/YHwPoRIAAj1VcQtNjc3OztZ7UePliBlXyNAIyDAAEYqeTaiPv37/fyc05PT5sXz1v7AbCeBAjASNXaiMQUpT5/z6tXr5q/1+GDAOtJgACM2KNHjwZfpL29vd3b72hd/1FTvpz9AbCeBAjAiNVDegXCUCoEKnL60OXsD6MfAOtLgACMXAXCEOslatRjZ2ent5/XevbHzPoPgLV2e93fAIApqFB48eLF7OzsrJerrfjY3d2dzefzXn5ejXy0Tr+q9Sa1WL2+v17P+fn55cL1uqa6nhr1qUARKQCrSYAATEA9nD979mx2eHjYaaThW/qOj1nH0Y/3799/8/srYhYHGNa/r+us6Wc1XcthhQCrQ4AATMRiylSNDBwcHDSvt/hajT48fvy49wf6k5OT5u+9uLho+r56fUdHR5cxUq/bmSEAq8EaEICJqQD5+eefL0OidSepCo8a9agH+b7jo6ZT9TU17Ftqetbe3t6NR34AGAcjIAATtJieVF/1gF5Tl2otxX+qUYOhRw5SYVCjPvU6+1w4D0CeAAGYuBoFSRxY+D2ti8/7sIgdEQIwXaZgAXBtFR81ApNUEVKjIQBMkxEQAK4tOfrxtcVIyBAL6gEYlhEQAK6ldqla5sLw+t11Nsp1dgMDYHkECADXsqzRj6/V7lsiBGBaBAgA1zKWbXFFCMC0CBAAOlts/TsWiwhJL4gHoDsBAkBnXU4+T6kI+e233y4PRgRgvAQIAJ29fv16lG9aTcOqU9NFCMB42YYXYMQWU53qgbr+wl9++umn2cbGxuzu3btL2YK2ruXi4mK0b9oiQnZ3d2fz+XwEVwTA1wQIwAhVeLx8+fKbC72/XntRJ6A/evTo8jT0lOPj49HfMosIqRPTK9QAGA8BAjAyFR5HR0dNF1WBUl8PHz68DJGEMWy/26IiZH9//zJCKtQAGAdrQABG5ODgoDk+vlb/Tf3Ff+itaCt2vnz5Mujv6Fu9p2PZMhgAAQIwChUOtYPTTR6Ua2rW0OdhTPVBXoQAjIcAAViyCoYKh8Ui85sYcivaus4xnf3RVUVITW8DYLkECMASVShUMPQRHwu1gH2IrWhXYQShpqpViACwPAIEYEkqECoUhji9e7ELVJ8Lxqew+1WLCikRArA8AgRgCSoMhl40vtgFqo+Ri4qlIUJpWUQIwPIIEICwevitMBh6x6qFetB+9erVjX7GyclJn5c0CvU5JHYOA+CfBAhA0LL+8n54eHij37uqO0gldg4D4J8ECEBIBcAyp/1cN35qutjUzv7oojYAECEAOQIEIGAs51BcZ9rRn3/+Oeg1jYEIAcgRIAADWuxGNaYpTItpRy3q+t++fbvsS44Y8gwVAP5NgAAMZHHA4JQP7+tzG98pGOoMFQD+TYAADKAeYPs63XwI9+/fb/qpdXDfulmMWokQgGEIEICeLQ4YHGt8lHv37l35PTUacH5+HrmesREhAMMRIAA9qulWYz9b4u7du7Nbt25d+X2rePZHF/UZ/v777yu7BTHAstz2zgP0Yyqna1eAtHj9+vWyL3UUnJgO0C8BAtCDmqozhcXmNfLRMv2qXsvFxUXkmqagIqRl1AiAq5mCBdCDqZwfYfTj+pwRAtAPAQKwRra3t5te7Pv3790WAAxCgACsiTt37szm8/mVL7bWsnz58sVtAcAgBAjAmmhZ+zH7O0AAYCgCBGBNtBw+WGd/TPnkdgDGT4AArIGtra3LKVhXeffundsBgEEJEIA10Dr96vj42O0AwKAECMAaaNl+t84yqSlYADAkAQKw4mr0o+UQvZOTE7cCAIMTIAArrvXwQbtfAZAgQACusLm5Odm3qBaetwRILT539sfNTfleAUgRIABX2NjYmOxb1Dr68fr168GvZR1M+V4BSBEgAFeY8l+1Hzx4cOX3fP78efbXX39FrmfVGQEBuJoAAbhC6yjC2NTDsLM/sqZ6rwAkCRCAK8zn86YH+bFpOfm8HB0duQV6UPdI3SsA/JgAAWjQepDfmLRcc537cX5+7hbowRTvEYBlECAADWotRctZGmNRU4FarvePP/7w8fekdcQJYN0JEIAG9TC/vb09mbeq9a/xb9++Hfxa1sHDhw8nOU0PYBkECECjR48eTWKXo4qllsXQHz58mF1cXESuaZXVPVH3BgBtBAhAB0+fPh39VCxnf+TUvVD3BADtBAhABzXNZnd3d9TTbVqmitXZH+/fv49cz6qawr0AMEYCBKCj2mr1+fPnozzzoXUr2Dr748uXL5FrWkVbW1uX94BtdwG6u+09A+iupt48efLkch3F4eHh7OzsbBTvYsvJ5+XNmzeDX8sqqsB7/PixAwcBbkCAANzA4i/hp6enlw/1NbJQZ2ssS8uDcV1fhRNtKjrqc66dxeqfANyMAAHoQU3Fqa/66/jicL/FQ37934koqQfllvUIFUmtaoen27fX538qamRrsdNZxcbGxoY1HgA9EyAAPVuEwFj/Wn58fNz0ffUaanQHAPpkETrAGqmpYq2jMdY5ADAEAQKwRrosPm9d0A4AXQgQgDXSGiC1DsLaBwCGIEAA1kQtPq8DCFsY/QBgKAIEYE10mX5l/QcAQxEgAGugRj5at9+t+KjtaAFgCAIEYA10Gf2oA/cAYCgCBGANnJycNL3IGvkw/QqAIQkQgBVX536cnZ01vUijHwAMTYAArLjWk89nAgSAAAECsOJaF5/XuR/z+dztAMCgBAjACqv4qClYLZz9AUCCAAFYYa2jHzNnfwAQIkAAVlTXsz9qChYADE2AAKyoio+KkBZGPwBIESAAK6p19MPZHwAkCRCAFdVl9KMiBAASBAjAimqNCmd/AJAkQABWVMu0qlp4vrW15RYAIEaAAKyoGtnY3Nz84Yt7/Pixjx+AKAECsMKePXv2zRGOmp61s7Nj8TkAcbe95QCrq0Jjd3d3dnp6+q9dsTY2Niw8B2BpBAjAGpjP55dfALBspmABAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAIAYAQIAAMQIEAAAIEaAAAAAMQIEAACIESAAAECMAAEAAGIECAAAECNAAACAGAECAADECBAAACBGgAAAADECBAAAiBEgAABAjAABAABiBAgAABAjQAAAgBgBAgAAxAgQAAAgRoAAAAAxAgQAAIgRIAAAQIwAAQAAYgQIAAAQI0AAAICM2Wz2v+IVUHgRXiHNAAAAAElFTkSuQmCC)

## [Field of view](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Field-of-view)

A person’s _field of view_ is the space they can see without moving their head. The dimensions of an individual’s field of view while wearing Apple Vision Pro vary based on factors like the way people configure the Light Seal and the extent of their peripheral acuity.

![A screenshot of a blank app window in visionOS. A series of concentric circles overlay the image, conveying 30-, 60-, and 90-degree fields of view.](https://docs-assets.developer.apple.com/published/7663aca2a6536f50be95399596fc71da/visionos-field-of-view-layout%402x.png)

**Center important content within the field of view.** By default, visionOS launches an app directly in front of people, placing it within their field of view. In an immersive experience, you can help people keep their attention on important content by keeping it centered and not displaying distracting motion or bright, high-contrast objects in the periphery.

Video with custom controls.

Content description: An animation of a person wearing Apple Vision Pro and sitting upright in a chair. The person is directly facing a square that represents an app window in visionOS that's centered in the person's field of view. A dotted line animates from the person's eyes to the center of the window.

[Play](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#)

Video with custom controls.

Content description: An animation of a person wearing Apple Vision Pro and reclining in a chair. The person is looking at a square that represents an app window in visionOS. The app window is positioned a short distance from the person, is raised in the air, and is tilted toward the person so it's centered within the person's field of view. A dotted line animates from the person's eyes to the center of the window.

[Play](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#)

**Avoid anchoring content to the wearer’s head.** Although you generally want your app to stay within the field of view, anchoring content so that it remains statically in front of someone can make them feel stuck, confined, and uncomfortable, especially if the content obscures a lot of passthrough and decreases the apparent stability of their surroundings. Instead, anchor content in people’s space, giving them the freedom to look around naturally and view different objects in different locations.

## [Depth](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Depth)

People rely on visual cues like distance, occlusion, and shadow to perceive depth and make sense of their surroundings. On Apple Vision Pro, the system automatically uses visual effects like color temperature, reflections, and shadow to help people perceive the depth of virtual content. When people move a virtual object in space — or when they change their position relative to that object — the visual effects change the object’s apparent depth, making the experience feel more lifelike.

Because people can view your content from any angle, incorporating small amounts of depth throughout your interface — even in standard windows — can help it look more natural. When you use SwiftUI, the system adds visual effects to views in a 2D window, making them appear to have depth. For developer guidance, see [Adding 3D content to your app](https://developer.apple.com/documentation/visionOS/adding-3d-content-to-your-app?changes=_5).

![A screenshot of a 2D Keynote presentation window in visionOS. The presentation is in edit mode, and the active slide displays a conceptual diagram of a proposed construction project named Athena Park.](https://docs-assets.developer.apple.com/published/131e52e3f4eb1eaa01f62138b5449ce5/visionos-spatial-layout-2d-window%402x.png)

If you need to present content with additional depth, you use RealityKit to create a 3D object (for developer guidance, see [RealityKit](https://developer.apple.com/documentation/RealityKit?changes=_5)). You can display the 3D object anywhere, or you can use a _volume_, which is a component that displays 3D content. A volume is similar to a window, but without a visible frame. For guidance, see [visionOS volumes](https://developer.apple.com/design/human-interface-guidelines/windows?changes=_5#visionOS-volumes).

Video with custom controls.

Content description: A recording showing a 3D model of a satellite within a visionOS volume. As the viewer approaches the satellite and manipulates its orientation, light reflections adjust based on the position of the viewer and angle of the satellite.

[Play](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#)

**Provide visual cues that accurately communicate the depth of your content.** If visual cues are missing or they conflict with a person’s real-world experience, people can experience visual discomfort.

**Use depth to communicate hierarchy.** Depth helps an object appear to stand out from surrounding content, making it more noticeable. People also tend to notice changes in depth: for example, when a sheet appears over a window, the window recedes along the z-axis, allowing the sheet to come forward and become visually prominent.

**In general, avoid adding depth to text.** Text that appears to hover above its background is difficult to read, which slows people down and can sometimes cause vision discomfort.

**Make sure depth adds value.** In general, you want to use depth to clarify and delight — you don’t need to use it everywhere. As you add depth to your design, think about the size and relative importance of objects. Depth is great for visually separating large, important elements in your app, like making a tab bar or toolbar stand out from a window, but it may not work as well on small objects. For example, using depth to make a button’s symbol stand out from its background can make the button less legible and harder to use. Also review how often you use different depths throughout your app. People need to refocus their eyes to perceive each difference in depth, and doing so too often or quickly can be tiring.

## [Scale](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Scale)

visionOS defines two types of scale to preserve the appearance of depth while optimizing usability.

_Dynamic scale_ helps content remain comfortably legible and interactive regardless of its proximity to people. Specifically, visionOS automatically increases a window’s scale as it moves away from the wearer and decreases it as the window moves closer, making the window appear to maintain the same size at all distances.

Video with custom controls.

Content description: An animation that shows a square representing an app window in a 3D space. The square animates to move back along its plane from its initial position. As it moves, it dynamically grows in size. A frame representing the original position remains visible for comparison. After the movement is complete, the entire environment rotates to convey that, from the viewer's angle, the window always remains the same size.

[Play](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#)

_Fixed scale_ means that an object maintains the same scale regardless of its proximity to people. A fixed-scale object appears smaller when it moves farther from the viewer along the z-axis, similar to the way an object in a person’s physical surroundings looks smaller when it’s far away than it does when it’s close up.

Video with custom controls.

Content description: An animation that shows a square representing an app window in a 3D space. The square animates to move back along its plane from its initial position. As it moves, it becomes smaller. A frame representing the original position remains visible for comparison. After the movement is complete, the entire environment rotates to convey that, from the viewer's angle, the window appears to have receded into the distance.

[Play](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#)

To support dynamic scaling and the appearance of depth, visionOS defines a point as an angle, in contrast to other platforms, which define a point as a number of pixels that can vary with the [resolution](https://developer.apple.com/design/human-interface-guidelines/images?changes=_5#Resolution) of a 2D display.

**Consider using fixed scale when you want a virtual object to look exactly like a physical object.** For example, you might want to maintain the life-size scale of a product you offer so it can look more realistic when people view it in their space. Because interactive content needs to scale to maintain usability as it gets closer or farther away, prefer applying fixed scale sparingly, reserving it for noninteractive objects that need it.

## [Best practices](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Best-practices)

**Avoid displaying too many windows.** Too many windows can obscure people’s surroundings, making them feel overwhelmed, constricted, and even uncomfortable. It can also make it cumbersome for people to relocate an app because it means moving a lot of windows.

**Prioritize standard, indirect gestures.** People can make an _indirect_ gesture without moving their hand into their field of view. In contrast, making a _direct_ gesture requires people to touch the virtual object with their finger, which can be tiring, especially when the object is positioned at or above their line of sight. In visionOS, people use indirect gestures to perform the standard gestures they already know. When you prioritize indirect gestures, people can use them to interact with any object they look at, whatever its distance. If you support direct gestures, consider reserving them for nearby objects that invite close inspection or manipulation for short periods of time. For guidance, see [Gestures > visionOS](https://developer.apple.com/design/human-interface-guidelines/gestures?changes=_5#visionOS).

**Rely on the Digital Crown to help people recenter windows in their field of view.** When people move or turn their head, content might no longer appear where they want it to. If this happens, people can press the [Digital Crown](https://developer.apple.com/design/human-interface-guidelines/digital-crown?changes=_5) when they want to recenter content in front of them. Your app doesn’t need to do anything to support this action.

**Include enough space around interactive components to make them easy for people to look at.** When people look at an interactive element, visionOS displays a visual hover effect that helps them confirm the element is the one they want. It’s crucial to include enough space around an interactive component so that looking at it is easy and comfortable, while preventing the hover effect from crowding other content. For example, place multiple, regular-size [buttons](https://developer.apple.com/design/human-interface-guidelines/buttons?changes=_5#visionOS) so their centers are at least 60 points apart, leaving 16 points or more of space between them. Also, don’t let controls overlap other interactive elements or views, because doing so can make selecting a single element difficult.

**Let people use your app with minimal or no physical movement.** Unless some physical movement is essential to your experience, help everyone enjoy it while remaining stationary.

**Use the floor to help you place a large immersive experience.** If your immersive experience includes content that extends up from the floor, place it using a flat horizontal plane. Aligning this plane with the floor can help it blend seamlessly with people’s surroundings and provide a more intuitive experience.

To learn more about windows and volumes in visionOS, see [Windows > visionOS](https://developer.apple.com/design/human-interface-guidelines/windows?changes=_5#visionOS); for guidance on laying content within a window, see [Layout > visionOS](https://developer.apple.com/design/human-interface-guidelines/layout?changes=_5#visionOS).

## [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Platform-considerations)

_Not supported in iOS, iPadOS, macOS, tvOS, or watchOS._

## [Resources](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Resources)

#### [Related](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Related)

[Eyes](https://developer.apple.com/design/human-interface-guidelines/eyes?changes=_5)

[Layout](https://developer.apple.com/design/human-interface-guidelines/layout?changes=_5)

[Immersive experiences](https://developer.apple.com/design/human-interface-guidelines/immersive-experiences?changes=_5)

#### [Developer documentation](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Developer-documentation)

[Presenting windows and spaces](https://developer.apple.com/documentation/visionOS/presenting-windows-and-spaces?changes=_5) — visionOS

[Positioning and sizing windows](https://developer.apple.com/documentation/visionOS/positioning-and-sizing-windows?changes=_5) — visionOS

[Adding 3D content to your app](https://developer.apple.com/documentation/visionOS/adding-3d-content-to-your-app?changes=_5) — visionOS

#### [Videos](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Videos)

[![](https://devimages-cdn.apple.com/wwdc-services/images/3055294D-836B-4513-B7B0-0BC5666246B0/2EFC2AAC-0656-4A18-B4C9-8E23CCD81E90/9989_wide_250x141_3x.jpg)\\
\\
Meet SwiftUI spatial layout](https://developer.apple.com/videos/play/wwdc2025/273)

[![](https://devimages-cdn.apple.com/wwdc-services/images/D35E0E85-CCB6-41A1-B227-7995ECD83ED5/15489B11-8744-483D-AD38-EF78D8962FF4/8126_wide_250x141_3x.jpg)\\
\\
Principles of spatial design](https://developer.apple.com/videos/play/wwdc2023/10072)

[![](https://devimages-cdn.apple.com/wwdc-services/images/D35E0E85-CCB6-41A1-B227-7995ECD83ED5/38E4EE32-29B5-4478-B8B6-35B8ACA67B16/8130_wide_250x141_3x.jpg)\\
\\
Design for spatial user interfaces](https://developer.apple.com/videos/play/wwdc2023/10076)

## [Change log](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5\#Change-log)

| Date | Changes |
| --- | --- |
| March 29, 2024 | Emphasized the importance of keeping interactive elements from overlapping each other. |
| June 21, 2023 | New page. |

Current page is Spatial layout

##### Supported platforms

- [Spatial layout](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#app-top)
- [Field of view](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Field-of-view)
- [Depth](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Depth)
- [Scale](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Scale)
- [Best practices](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Best-practices)
- [Platform considerations](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Platform-considerations)
- [Resources](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Resources)
- [Change log](https://developer.apple.com/design/human-interface-guidelines/spatial-layout?changes=_5#Change-log)