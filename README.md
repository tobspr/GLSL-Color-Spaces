# GLSL-Color-Spaces
Utility functions to convert between various color spaces in GLSL


## Supported conversions

 From / To | RGB | sRGB | XYZ | xyY | HCV | HUE | HSV | HSL | HCY
|---       |-----|------|-----|-----|-----|-----|-----|-----|-----|
| **RGB**  |  X  |  X   |  X  |  X  |  X  |     |  X  |  X  |  X  |
| **sRGB** |     |  X   |     |     |     |     |     |     |     |
| **XYZ**  |  X  |      |  X  |  X  |     |     |     |     |     |
| **xyY**  |  X  |      |  X  |  X  |     |     |     |     |     |
| **HCV**  |     |      |     |     |  X  |     |     |     |     |
| **HUE**  |  X  |      |     |     |     |  X  |     |     |     |
| **HSV**  |  X  |      |     |     |     |     |  X  |     |     |
| **HSL**  |  X  |      |     |     |     |     |     |  X  |     |
| **HCY**  |  X  |      |     |     |     |     |     |     |  X  |
