# GLSL-Color-Spaces
Utility functions to convert between various color spaces in GLSL


## Supported conversions

**d** = directly implemented

**x** = Implemented using two or more direct implementions

 From / To  | RGB | sRGB | XYZ | xyY | HCV | HUE | HSV | HSL | HCY | YCbCr |
|---        |-----|------|-----|-----|-----|-----|-----|-----|-----|-------|
| **RGB**   |  d  |  d   |  d  |  d  |  d  |     |  d  |  d  |  d  |   d   |
| **sRGB**  |  d  |  d   |  x  |  x  |  x  |     |  x  |  x  |  x  |   x   |
| **XYZ**   |  d  |  x   |  d  |  d  |  x  |     |  x  |  x  |  x  |   x   |
| **xyY**   |  d  |  x   |  d  |  d  |  x  |     |  x  |  x  |  x  |   x   |
| **HCV**   |     |      |     |     |  d  |     |     |     |     |       |
| **HUE**   |  d  |  x   |  x  |  x  |  x  |  d  |  x  |  x  |  x  |   x   |
| **HSV**   |  d  |  x   |  x  |  x  |  x  |     |  d  |  x  |  x  |   x   |
| **HSL**   |  d  |  x   |  x  |  x  |  x  |     |  x  |  d  |  x  |   x   |
| **HCY**   |  d  |  x   |  x  |  x  |  x  |     |  x  |  x  |  d  |   x   |
| **YCbCr** |  d  |  x   |  x  |  x  |  x  |     |  x  |  x  |  x  |   d   |

