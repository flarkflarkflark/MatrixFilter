#pragma once

#include <clap/clap.h>

#ifdef __cplusplus
extern "C" {
#endif

// Plugin descriptor
extern const clap_plugin_descriptor_t s_plugin_desc;

// Plugin factory
clap_plugin_t *audio_filter_plugin_create(const clap_host_t *host);

#ifdef __cplusplus
}
#endif
