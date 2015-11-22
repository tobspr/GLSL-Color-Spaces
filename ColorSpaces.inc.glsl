
/*

GLSL Color Space Utility Functions
(c) 2015 tobspr

-------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2015 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

-------------------------------------------------------------------------------

Most formulars / matrices are from:
https://en.wikipedia.org/wiki/SRGB

Some are from:
http://www.chilliant.com/rgb2hsv.html

*/


// Define saturation macro, if not already user-defined
#ifndef saturate
#define saturate(v) clamp(v, 0, 1)
#endif

// Constants
const float HCV_EPSILON = 1e-10;
const float HSL_EPSILON = 1e-10;
const float HCY_EPSILON = 1e-10;

// Used to convert from linear RGB to XYZ space
const mat3 RGB_2_XYZ = (mat3(
    0.4124564, 0.3575761, 0.1804375,
    0.2126729, 0.7151522, 0.0721750,
    0.0193339, 0.1191920, 0.9503041
));

// Used to convert from XYZ to linear RGB space
const mat3 XYZ_2_RGB = (mat3(
     3.2404542,-1.5371385,-0.4985314,
    -0.9692660, 1.8760108, 0.0415560,
     0.0556434,-0.2040259, 1.0572252
));


// Returns the luminance of a !! linear !! rgb color
float get_luminance(vec3 rgb) {
    return 0.2126 * rgb.r + 0.7152 * rgb.g + 0.0722 * rgb.b;    
}

// Converts a linear rgb to a srgb color (approximated, but fast)
vec3 rgb_to_srgb_approx(vec3 rgb) {
    return pow(rgb, vec3(1.0 / 2.2));
}

// Converts a single linear channel to srgb
float linear_to_srgb(float channel) {

    // Definition by the sRGB format, see wikipedia
    const float a = 0.055;
    if(channel <= 0.0031308)
        return 12.92 * channel;
    else
        return (1.0 + a) * pow(channel, 1.0/2.4) - a;
} 

// Converts a linear rgb color to a srgb color (exact, not approximated)
vec3 rgb_to_srgb(vec3 rgb) {
    return vec3(
        linear_to_srgb(rgb.r),
        linear_to_srgb(rgb.g),
        linear_to_srgb(rgb.b)
    );
}

// Converts a color from linear RGB to XYZ space
vec3 rgb_to_xyz(vec3 rgb) {
    return RGB_2_XYZ * rgb;
}

// Converts a color from XYZ to linear RGB space
vec3 xyz_to_rgb(vec3 xyz) {
    return XYZ_2_RGB * xyz;
}

// Converts a color from XYZ to xyY space (Y is luminosity)
vec3 xyz_to_xyY(vec3 xyz) {
    float Y = xyz.y;
    float x = xyz.x / (xyz.x + xyz.y + xyz.z);
    float y = xyz.y / (xyz.x + xyz.y + xyz.z);
    return vec3(x, y, Y);
}

// Converts a color from xyY space to XYZ space
vec3 xyY_to_xyz(vec3 xyY) {
    float Y = xyY.z;
    float x = Y * xyY.x / xyY.y;
    float z = Y * (1.0 - xyY.x - xyY.y) / xyY.y;
    return vec3(x, Y, z);
}

// Converts a color from linear RGB to xyY space
vec3 rgb_to_xyY(vec3 rgb) {
    vec3 xyz = rgb_to_xyz(rgb);
    return xyz_to_xyY(xyz);
}

// Converts a color from xyY space to linear RGB
vec3 xyY_to_rgb(vec3 xyY) {
    vec3 xyz = xyY_to_xyz(xyY);
    return xyz_to_rgb(xyz);
}

// Converts a value from linear RGB to HCV (Hue, Chroma, Value)
vec3 rgb_to_hcv(vec3 rgb)
{
    // Based on work by Sam Hocevar and Emil Persson
    vec4 P = (rgb.g < rgb.b) ? vec4(rgb.bg, -1.0, 2.0/3.0) : vec4(rgb.gb, 0.0, -1.0/3.0);
    vec4 Q = (rgb.r < P.x) ? vec4(P.xyw, rgb.r) : vec4(rgb.r, P.yzx);
    float C = Q.x - min(Q.w, Q.y);
    float H = abs((Q.w - Q.y) / (6 * C + HCV_EPSILON) + Q.z);
    return vec3(H, C, Q.x);
}

// Converts from pure Hue to linear RGB
vec3 hue_to_rgb(float hue)
{
    float R = abs(hue * 6 - 3) - 1;
    float G = 2 - abs(hue * 6 - 2);
    float B = 2 - abs(hue * 6 - 4);
    return saturate(vec3(R,G,B));
}

// Converts from HSV to linear RGB
vec3 hsv_to_rgb(vec3 hsv)
{
    vec3 rgb = hue_to_rgb(hsv.x);
    return ((rgb - 1.0) * hsv.y + 1.0) * hsv.z;
}

// Converts from HSL to linear RGB
vec3 hsl_to_rgb(vec3 hsl)
{
    vec3 rgb = hue_to_rgb(hsl.x);
    float C = (1 - abs(2 * hsl.z - 1)) * hsl.y;
    return (rgb - 0.5) * C + hsl.z;
}

// Converts from HCY to linear RGB
vec3 hcy_to_rgb(vec3 hcy)
{
    const vec3 HCYwts = vec3(0.299, 0.587, 0.114);
    vec3 RGB = hue_to_rgb(hcy.x);
    float Z = dot(RGB, HCYwts);
    if (hcy.z < Z) {
        hcy.y *= hcy.z / Z;
    } else if (Z < 1) {
        hcy.y *= (1 - hcy.z) / (1 - Z);
    }
    return (RGB - Z) * hcy.y + hcy.z;
}


// Converts from linear RGB to HSV
vec3 rgb_to_hsv(vec3 rgb)
{
    vec3 HCV = rgb_to_hcv(rgb);
    float S = HCV.y / (HCV.z + HCV_EPSILON);
    return vec3(HCV.x, S, HCV.z);
}

// Converts from linear rgb to HSL
vec3 rgb_to_hsl(vec3 rgb)
{
    vec3 HCV = rgb_to_hcv(rgb);
    float L = HCV.z - HCV.y * 0.5;
    float S = HCV.y / (1 - abs(L * 2 - 1) + HSL_EPSILON);
    return vec3(HCV.x, S, L);
}


vec3 rgb_to_hcy(vec3 rgb)
{
    const vec3 HCYwts = vec3(0.299, 0.587, 0.114);
    // Corrected by David Schaeffer
    vec3 HCV = rgb_to_hcv(rgb);
    float Y = dot(rgb, HCYwts);
    float Z = dot(hue_to_rgb(HCV.x), HCYwts);
    if (Y < Z) {
      HCV.y *= Z / (HCY_EPSILON + Y);
    } else {
      HCV.y *= (1 - Z) / (HCY_EPSILON + 1 - Y);
    }
    return vec3(HCV.x, HCV.y, Y);
}

