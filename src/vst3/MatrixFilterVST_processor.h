#pragma once

#include "public.sdk/source/vst/vstaudioeffect.h"
#include "MatrixFilterVST_cids.h"

extern "C" {
#include "dsp.h"
}

namespace Steinberg {
namespace MatrixFilterVST {

class MatrixFilterProcessor : public Vst::AudioEffect {
public:
    MatrixFilterProcessor();
    ~MatrixFilterProcessor() SMTG_OVERRIDE;

    // Create function
    static FUnknown* createInstance(void* /*context*/) {
        return (Vst::IAudioProcessor*)new MatrixFilterProcessor;
    }

    // AudioEffect overrides
    tresult PLUGIN_API initialize(FUnknown* context) SMTG_OVERRIDE;
    tresult PLUGIN_API terminate() SMTG_OVERRIDE;
    tresult PLUGIN_API setActive(TBool state) SMTG_OVERRIDE;
    tresult PLUGIN_API process(Vst::ProcessData& data) SMTG_OVERRIDE;
    tresult PLUGIN_API setupProcessing(Vst::ProcessSetup& newSetup) SMTG_OVERRIDE;
    tresult PLUGIN_API canProcessSampleSize(int32 symbolicSampleSize) SMTG_OVERRIDE;
    tresult PLUGIN_API setState(IBStream* state) SMTG_OVERRIDE;
    tresult PLUGIN_API getState(IBStream* state) SMTG_OVERRIDE;

protected:
    // Filter instances for stereo processing
    filter_t filterL;  // Left channel
    filter_t filterR;  // Right channel

    // Current parameter values
    filter_type_t currentFilterType;
    float currentCutoff;
    float currentResonance;
    float currentGain;
};

} // namespace MatrixFilterVST
} // namespace Steinberg
