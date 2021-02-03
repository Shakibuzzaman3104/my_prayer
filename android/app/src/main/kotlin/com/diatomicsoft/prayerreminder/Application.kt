package com.diatomicsoft.prayerreminder

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;

class Application:FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        AlarmService.setPluginRegistrant(this)
    }
    override fun registerWith(registry:PluginRegistry?) {
        registry?.registrarFor("io.flutter.plugins.androidalarmmanager.AlarmService");
    }
}