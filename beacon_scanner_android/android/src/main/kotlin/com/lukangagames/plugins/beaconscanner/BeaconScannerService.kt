package com.lukangagames.plugins.beaconscanner

import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Handler
import android.os.Looper
import android.os.RemoteException
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import org.altbeacon.beacon.BeaconConsumer
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.RangeNotifier
import org.altbeacon.beacon.Region

internal class BeaconScannerService(plugin: BeaconScannerPlugin, context: Context) {
    private val plugin: BeaconScannerPlugin
    private val context: Context
    private var eventSinkRanging: MainThreadEventSink? = null
    private var eventSinkMonitoring: MainThreadEventSink? = null
    private var regionRanging: MutableList<Region>? = null
    private var regionMonitoring: MutableList<Region?>? = null

    // Fixes: https://github.com/flutter/flutter/issues/34993
    private class MainThreadEventSink internal constructor(private val eventSink: EventSink) : EventSink {
        private val handler: Handler = Handler(Looper.getMainLooper())

        override fun success(o: Any?) {
            handler.post { eventSink.success(o) }
        }

        override fun error(s: String, s1: String, o: Any) {
            handler.post { eventSink.error(s, s1, o) }
        }

        override fun endOfStream() {}
    }

    val rangingStreamHandler: EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(o: Any?, eventSink: EventSink) {
            Log.d("RANGING", "Start ranging = $o")
            startRanging(o, eventSink)
        }

        override fun onCancel(o: Any?) {
            Log.d("RANGING", "Stop ranging = $o")
            stopRanging()
        }
    }

    private fun startRanging(o: Any?, eventSink: EventSink) {
        if (o is List<*>) {
            if (regionRanging == null) {
                regionRanging = ArrayList()
            } else {
                regionRanging!!.clear()
            }
            for (`object` in o) {
                if (`object` is Map<*, *>) {
                    val region = BeaconScannerUtils.regionFromMap(`object`)
                    if (region != null) {
                        regionRanging!!.add(region)
                    }
                }
            }
        } else {
            eventSink.error("Beacon", "invalid region for ranging", null)
            return
        }
        eventSinkRanging = MainThreadEventSink(eventSink)
        if (plugin.getBeaconManager() != null && !plugin.getBeaconManager()!!.isBound(beaconConsumer)) {
            plugin.getBeaconManager()!!.bind(beaconConsumer)
        } else {
            startRanging()
        }
    }

    fun startRanging() {
        if (regionRanging == null || regionRanging!!.isEmpty()) {
            Log.e("RANGING", "Region ranging is null or empty. Ranging not started.")
            return
        }
        try {
            if (plugin.getBeaconManager() != null) {
                plugin.getBeaconManager()!!.removeAllRangeNotifiers()
                plugin.getBeaconManager()!!.addRangeNotifier(rangeNotifier)
                for (region in regionRanging!!) {
                    plugin.getBeaconManager()!!.startRangingBeaconsInRegion(region)
                }
            }
        } catch (e: RemoteException) {
            if (eventSinkRanging != null) {
                eventSinkRanging!!.error("Beacon", e.localizedMessage ?: "null", "Dummy")
            }
        }
    }

    fun stopRanging() {
        if (regionRanging != null && regionRanging!!.isNotEmpty()) {
            try {
                for (region in regionRanging!!) {
                    plugin.getBeaconManager()!!.stopRangingBeaconsInRegion(region)
                }
                plugin.getBeaconManager()!!.removeRangeNotifier(rangeNotifier)
            } catch (ignored: RemoteException) {
            }
        }
        eventSinkRanging = null
    }

    private val rangeNotifier = RangeNotifier { collection, region ->
        if (eventSinkRanging != null) {
            val map: MutableMap<String, Any?> = HashMap()
            map["region"] = BeaconScannerUtils.regionToMap(region)
            map["beacons"] = BeaconScannerUtils.beaconsToArray(ArrayList(collection))
            eventSinkRanging!!.success(map)
        }
    }
    val monitoringStreamHandler: EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(o: Any?, eventSink: EventSink) {
            startMonitoring(o, eventSink)
        }

        override fun onCancel(o: Any?) {
            stopMonitoring()
        }
    }

    private fun startMonitoring(o: Any?, eventSink: EventSink) {
        Log.d(TAG, "START MONITORING=$o")
        if (o is List<*>) {
            if (regionMonitoring == null) {
                regionMonitoring = ArrayList()
            } else {
                regionMonitoring!!.clear()
            }
            for (`object` in o) {
                if (`object` is Map<*, *>) {
                    val region = BeaconScannerUtils.regionFromMap(`object`)
                    regionMonitoring!!.add(region)
                }
            }
        } else {
            eventSink.error("Beacon", "invalid region for monitoring", null)
            return
        }
        eventSinkMonitoring = MainThreadEventSink(eventSink)
        if (plugin.getBeaconManager() != null && !plugin.getBeaconManager()!!.isBound(beaconConsumer)) {
            plugin.getBeaconManager()!!.bind(beaconConsumer)
        } else {
            startMonitoring()
        }
    }

    fun startMonitoring() {
        if (regionMonitoring == null || regionMonitoring!!.isEmpty()) {
            Log.e("MONITORING", "Region monitoring is null or empty. Monitoring not started.")
            return
        }
        try {
            plugin.getBeaconManager()!!.removeAllMonitorNotifiers()
            plugin.getBeaconManager()!!.addMonitorNotifier(monitorNotifier)
            for (region in regionMonitoring!!) {
                if(region != null) {
                    plugin.getBeaconManager()!!.startMonitoringBeaconsInRegion(region)
                }
            }
        } catch (e: RemoteException) {
            if (eventSinkMonitoring != null) {
                eventSinkMonitoring!!.error("Beacon", e.localizedMessage ?: "null", "Dummy")
            }
        }
    }

    fun stopMonitoring() {
        if (regionMonitoring != null && regionMonitoring!!.isNotEmpty()) {
            try {
                for (region in regionMonitoring!!) {
                    if(region != null) {
                        plugin.getBeaconManager()!!.stopMonitoringBeaconsInRegion(region)
                    }
                }
                plugin.getBeaconManager()!!.removeMonitorNotifier(monitorNotifier)
            } catch (ignored: RemoteException) {
            }
        }
        eventSinkMonitoring = null
    }

    private val monitorNotifier: MonitorNotifier = object : MonitorNotifier {
        override fun didEnterRegion(region: Region) {
            if (eventSinkMonitoring != null) {
                val map: MutableMap<String, Any?> = HashMap()
                map["event"] = "didEnterRegion"
                map["region"] = BeaconScannerUtils.regionToMap(region)
                eventSinkMonitoring!!.success(map)
            }
        }

        override fun didExitRegion(region: Region) {
            if (eventSinkMonitoring != null) {
                val map: MutableMap<String, Any?> = HashMap()
                map["event"] = "didExitRegion"
                map["region"] = BeaconScannerUtils.regionToMap(region)
                eventSinkMonitoring!!.success(map)
            }
        }

        override fun didDetermineStateForRegion(state: Int, region: Region) {
            if (eventSinkMonitoring != null) {
                val map: MutableMap<String, Any?> = HashMap()
                map["event"] = "didDetermineStateForRegion"
                map["state"] = BeaconScannerUtils.parseState(state)
                map["region"] = BeaconScannerUtils.regionToMap(region)
                eventSinkMonitoring!!.success(map)
            }
        }
    }
    val beaconConsumer: BeaconConsumer = object : BeaconConsumer {
        override fun onBeaconServiceConnect() {
            if (plugin.flutterResult != null) {
                plugin.flutterResult!!.success(true)
                plugin.flutterResult = null
            } else {
                startRanging()
                startMonitoring()
            }
        }

        override fun getApplicationContext(): Context {
            return context
        }

        override fun unbindService(serviceConnection: ServiceConnection) {
            applicationContext.unbindService(serviceConnection)
        }

        override fun bindService(intent: Intent, serviceConnection: ServiceConnection, i: Int): Boolean {
            return applicationContext.bindService(intent, serviceConnection, i)
        }
    }

    init {
        this.plugin = plugin
        this.context = context
    }

    companion object {
        private val TAG = BeaconScannerService::class.java.simpleName
    }
}