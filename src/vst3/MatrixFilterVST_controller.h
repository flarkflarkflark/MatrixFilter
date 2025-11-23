#pragma once

#include "public.sdk/source/vst/vsteditcontroller.h"
#include "MatrixFilterVST_cids.h"

namespace Steinberg {
namespace MatrixFilterVST {

class MatrixFilterController : public Vst::EditController {
public:
    MatrixFilterController();
    ~MatrixFilterController() SMTG_OVERRIDE;

    // Create function
    static FUnknown* createInstance(void* /*context*/) {
        return (Vst::IEditController*)new MatrixFilterController;
    }

    // IPluginBase
    tresult PLUGIN_API initialize(FUnknown* context) SMTG_OVERRIDE;
    tresult PLUGIN_API terminate() SMTG_OVERRIDE;

    // EditController
    tresult PLUGIN_API setComponentState(IBStream* state) SMTG_OVERRIDE;
};

} // namespace MatrixFilterVST
} // namespace Steinberg
