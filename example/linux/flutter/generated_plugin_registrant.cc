//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <av/av_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) av_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AvPlugin");
  av_plugin_register_with_registrar(av_registrar);
}
