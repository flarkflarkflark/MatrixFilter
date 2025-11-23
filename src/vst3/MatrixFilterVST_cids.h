#pragma once

#include "pluginterfaces/base/funknown.h"
#include "pluginterfaces/vst/vsttypes.h"

namespace Steinberg {
namespace MatrixFilterVST {

// Processor UID: {A1B2C3D4-E5F6-4A5B-9C8D-7E6F5A4B3C2D}
static const FUID ProcessorUID(0xA1B2C3D4, 0xE5F64A5B, 0x9C8D7E6F, 0x5A4B3C2D);

// Controller UID: {B2C3D4E5-F6A7-5B6C-AD9E-8F7A6B5C4D3E}
static const FUID ControllerUID(0xB2C3D4E5, 0xF6A75B6C, 0xAD9E8F7A, 0x6B5C4D3E);

// Parameter IDs
enum MatrixFilterParams : Vst::ParamID {
    kParamFilterType = 100,
    kParamCutoffFreq = 101,
    kParamResonance = 102,
    kParamGain = 103
};

} // namespace MatrixFilterVST
} // namespace Steinberg
