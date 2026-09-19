// Minimal local ReShadeUI.fxh for personal vkBasalt use.
// Covers only the uniform annotation macros referenced by local shaders.
// (Upstream ReShade distributes the full file with its installer.)
#pragma once

#define __UNIFORM_SLIDER_FLOAT1 ui_type = "slider";
#define __UNIFORM_DRAG_FLOAT3 ui_type = "drag";
#define __UNIFORM_COMBO_INT1 ui_type = "combo";
#define __UNIFORM_INPUT_FLOAT1 ui_type = "input";
#define __UNIFORM_COLOR_FLOAT3 ui_type = "color";
