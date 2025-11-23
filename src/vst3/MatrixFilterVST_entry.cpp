#include "MatrixFilterVST_processor.h"
#include "MatrixFilterVST_controller.h"
#include "MatrixFilterVST_cids.h"
#include "public.sdk/source/main/pluginfactory.h"

#define stringPluginName "MatrixFilter VST"

using namespace Steinberg::Vst;
using namespace Steinberg::MatrixFilterVST;

//------------------------------------------------------------------------
//  VST Plug-in Entry
//------------------------------------------------------------------------

BEGIN_FACTORY_DEF("MatrixFilter",
                  "https://github.com/flarkflarkflark/MatrixFilter",
                  "mailto:info@matrixfilter.com")

    //---First Plug-in included in this factory-------
    // Processor
    DEF_CLASS2(INLINE_UID_FROM_FUID(ProcessorUID),
               PClassInfo::kManyInstances,
               kVstAudioEffectClass,
               stringPluginName,
               Vst::kDistributable,
               Vst::PlugType::kFx,
               "1.1.0",
               kVstVersionString,
               MatrixFilterProcessor::createInstance)

    // Controller
    DEF_CLASS2(INLINE_UID_FROM_FUID(ControllerUID),
               PClassInfo::kManyInstances,
               kVstComponentControllerClass,
               stringPluginName " Controller",
               0,
               "",
               "1.1.0",
               kVstVersionString,
               MatrixFilterController::createInstance)

END_FACTORY
