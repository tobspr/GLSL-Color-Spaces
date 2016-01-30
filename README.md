# GLSL-Color-Spaces
Utility functions to convert between various color spaces in GLSL


## Supported conversions

**X** = Directly implemented

**x** = Implemented using two or more direct implementions

 From / To | RGB | sRGB | XYZ | xyY | HCV | HUE | HSV | HSL | HCY
|---       |-----|------|-----|-----|-----|-----|-----|-----|-----|
| **RGB**  |  X  |  X   |  X  |  X  |  X  |     |  X  |  X  |  X  |
| **sRGB** |  X  |  X   |  x  |  x  |  x  |     |  x  |  x  |  x  |
| **XYZ**  |  X  |  x   |  X  |  X  |  x  |     |  x  |  x  |  x  |
| **xyY**  |  X  |  x   |  X  |  X  |  x  |     |  x  |  x  |  x  |
| **HCV**  |     |      |     |     |  X  |     |     |     |     |
| **HUE**  |  X  |  x   |  x  |  x  |  x  |  X  |  x  |  x  |  x  |
| **HSV**  |  X  |  x   |  x  |  x  |  x  |     |  X  |  x  |  x  |
| **HSL**  |  X  |  x   |  x  |  x  |  x  |     |  x  |  X  |  x  |
| **HCY**  |  X  |  x   |  x  |  x  |  x  |     |  x  |  x  |  X  |
