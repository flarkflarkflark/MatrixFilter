#include "MatrixFilterVST_controller.h"
#include "base/source/fstreamer.h"
#include "pluginterfaces/base/ibstream.h"
#include <cmath>

namespace Steinberg {
namespace MatrixFilterVST {

//------------------------------------------------------------------------
// MatrixFilterController
//------------------------------------------------------------------------
MatrixFilterController::MatrixFilterController()
{
}

//------------------------------------------------------------------------
MatrixFilterController::~MatrixFilterController()
{
}

//------------------------------------------------------------------------
tresult PLUGIN_API MatrixFilterController::initialize(FUnknown* context)
{
    tresult result = EditController::initialize(context);
    if (result != kResultOk) {
        return result;
    }

    // Add parameters

    // Filter Type parameter (discrete: 0=Lowpass, 1=Highpass, 2=Bandpass, 3=Notch, 4=Peaking, 5=LowShelf, 6=HighShelf)
    Vst::StringListParameter* filterTypeParam = new Vst::StringListParameter(
        STR16("Filter Type"),
        kParamFilterType,
        nullptr,
        Vst::ParameterInfo::kIsList
    );
    filterTypeParam->appendString(STR16("Lowpass"));
    filterTypeParam->appendString(STR16("Highpass"));
    filterTypeParam->appendString(STR16("Bandpass"));
    filterTypeParam->appendString(STR16("Notch"));
    filterTypeParam->appendString(STR16("Peaking"));
    filterTypeParam->appendString(STR16("Low Shelf"));
    filterTypeParam->appendString(STR16("High Shelf"));
    parameters.addParameter(filterTypeParam);

    // Cutoff Frequency parameter (20Hz - 20kHz, logarithmic)
    parameters.addParameter(STR16("Cutoff Freq"),
                          STR16("Hz"),
                          0,
                          0.5,  // Default to ~1kHz
                          Vst::ParameterInfo::kCanAutomate,
                          kParamCutoffFreq);

    // Resonance parameter (Q: 0.1 - 10.0)
    parameters.addParameter(STR16("Resonance"),
                          STR16("Q"),
                          0,
                          0.071,  // Default to Q=0.707 (Butterworth)
                          Vst::ParameterInfo::kCanAutomate,
                          kParamResonance);

    // Gain parameter (-24dB to +24dB)
    parameters.addParameter(STR16("Gain"),
                          STR16("dB"),
                          0,
                          0.5,  // Default to 0dB (center)
                          Vst::ParameterInfo::kCanAutomate,
                          kParamGain);

    return kResultOk;
}

//------------------------------------------------------------------------
tresult PLUGIN_API MatrixFilterController::terminate()
{
    return EditController::terminate();
}

//------------------------------------------------------------------------
tresult PLUGIN_API MatrixFilterController::setComponentState(IBStream* state)
{
    if (!state) {
        return kResultFalse;
    }

    IBStreamer streamer(state, kLittleEndian);

    int32 savedFilterType = 0;
    if (!streamer.readInt32(savedFilterType)) {
        return kResultFalse;
    }

    float savedCutoff = 0.f;
    if (!streamer.readFloat(savedCutoff)) {
        return kResultFalse;
    }

    float savedResonance = 0.f;
    if (!streamer.readFloat(savedResonance)) {
        return kResultFalse;
    }

    float savedGain = 0.f;
    if (!streamer.readFloat(savedGain)) {
        return kResultFalse;
    }

    // Convert back to normalized parameter values
    setParamNormalized(kParamFilterType, (float)savedFilterType / 6.999f);

    // Cutoff: convert from Hz to normalized (logarithmic)
    float normalizedCutoff = logf(savedCutoff / 20.0f) / logf(1000.0f);
    setParamNormalized(kParamCutoffFreq, normalizedCutoff);

    // Resonance: convert from Q to normalized
    float normalizedResonance = (savedResonance - 0.1f) / 9.9f;
    setParamNormalized(kParamResonance, normalizedResonance);

    // Gain: convert from linear gain to normalized dB
    float gainDb = 20.0f * log10f(savedGain);
    float normalizedGain = (gainDb + 24.0f) / 48.0f;
    setParamNormalized(kParamGain, normalizedGain);

    return kResultOk;
}

} // namespace MatrixFilterVST
} // namespace Steinberg
