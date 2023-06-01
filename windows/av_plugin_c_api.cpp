#include "include/av/av_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "av_plugin.h"

void AvPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  av::AvPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
