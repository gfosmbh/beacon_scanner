package com.lukangagames.plugins.beaconscanner

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.RemoteException
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener
import org.altbeacon.beacon.BeaconManager
import org.altbeacon.beacon.BeaconParser

class BeaconScannerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener,
    ActivityResultListener {

    companion object {
        const val REQUEST_CODE_LOCATION = 1234
        const val REQUEST_CODE_BLUETOOTH = 5678
    }

    private val iBeaconLayout = BeaconParser()
        .setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24")

    private var flutterPluginBinding: FlutterPluginBinding? = null
    private var activityPluginBinding: ActivityPluginBinding? = null

    private var beaconScanner: BeaconScannerService? = null

    private var platform: FlutterPlatform? = null

    private var beaconManager: BeaconManager? = null
    var flutterResult: Result? = null
    private var flutterResultBluetooth: Result? = null
    private var eventSinkLocationAuthorizationStatus: EventSink? = null

    private var channel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventChannelMonitoring: EventChannel? = null
    private var eventChannelBluetoothState: EventChannel? = null
    private var eventChannelAuthorizationStatus: EventChannel? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = binding
        setupPluginMethods(binding.binaryMessenger, binding.applicationContext)
    }

    private fun setupPluginMethods(messenger: BinaryMessenger, context: Context) {
        if (activityPluginBinding != null) {
            activityPluginBinding?.addActivityResultListener(this)
            activityPluginBinding?.addRequestPermissionsResultListener(this)
        }
        beaconManager = BeaconManager.getInstanceForApplication(context)
        if (!beaconManager!!.beaconParsers.contains(iBeaconLayout)) {
            beaconManager?.beaconParsers?.clear()
            beaconManager?.beaconParsers?.add(iBeaconLayout)
        }
        platform = FlutterPlatform(context)
        beaconScanner = BeaconScannerService(this, context)
        channel = MethodChannel(messenger, "plugins.lukangagames.com/beacon_scanner_android")
        channel?.setMethodCallHandler(this)
        eventChannel = EventChannel(messenger, "beacon_scanner_event_ranging")
        eventChannel?.setStreamHandler(beaconScanner!!.rangingStreamHandler)
        eventChannelMonitoring = EventChannel(messenger, "beacon_scanner_event_monitoring")
        eventChannelMonitoring?.setStreamHandler(beaconScanner!!.monitoringStreamHandler)
        eventChannelBluetoothState = EventChannel(messenger, "beacon_scanner_bluetooth_state_changed")
        eventChannelBluetoothState?.setStreamHandler(FlutterBluetoothStateReceiver(context))
        eventChannelAuthorizationStatus = EventChannel(messenger, "beacon_scanner_authorization_status_changed")
        eventChannelAuthorizationStatus?.setStreamHandler(locationAuthorizationStatusStreamHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = null
        teardownChannels()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        activityPluginBinding!!.addActivityResultListener(this)
        activityPluginBinding!!.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {}

    fun getBeaconManager(): BeaconManager? {
        return beaconManager
    }

    private fun teardownChannels() {
        if (activityPluginBinding != null) {
            activityPluginBinding!!.removeActivityResultListener(this)
            activityPluginBinding!!.removeRequestPermissionsResultListener(this)
        }
        platform = null
        channel!!.setMethodCallHandler(null)
        eventChannel!!.setStreamHandler(null)
        eventChannelMonitoring!!.setStreamHandler(null)
        eventChannelBluetoothState!!.setStreamHandler(null)
        eventChannelAuthorizationStatus!!.setStreamHandler(null)
        channel = null
        eventChannel = null
        eventChannelMonitoring = null
        eventChannelBluetoothState = null
        eventChannelAuthorizationStatus = null
        activityPluginBinding = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                if (beaconManager != null && !beaconManager!!.isBound(beaconScanner!!.beaconConsumer)) {
                    flutterResult = result
                    beaconManager!!.bind(beaconScanner!!.beaconConsumer)
                } else {
                    result.success(true)
                }
            }

            "initializeAndCheckScanning" -> initializeAndCheck(result)

            "close" -> {
                if (beaconManager != null) {
                    beaconScanner!!.stopRanging()
                    beaconManager!!.removeAllRangeNotifiers()
                    beaconScanner!!.stopMonitoring()
                    beaconManager!!.removeAllMonitorNotifiers()
                    if (beaconManager!!.isBound(beaconScanner!!.beaconConsumer)) {
                        beaconManager!!.unbind(beaconScanner!!.beaconConsumer)
                    }
                }
                result.success(true)
            }

            "setScanPeriod" -> {
                val scanPeriod = call.argument<Int>("scanPeriod")!!
                beaconManager!!.foregroundScanPeriod = scanPeriod.toLong()
                try {
                    beaconManager!!.updateScanPeriods()
                    result.success(true)
                } catch (e: RemoteException) {
                    result.success(false)
                }
            }

            "setScanDuration" -> {
                val betweenScanPeriod = call.argument<Int>("scanDuration")!!
                beaconManager!!.foregroundBetweenScanPeriod = betweenScanPeriod.toLong()
                try {
                    beaconManager!!.updateScanPeriods()
                    result.success(true)
                } catch (e: RemoteException) {
                    result.success(false)
                }
            }

            "authorizationStatus" -> result.success(if (platform!!.checkLocationServicesPermission()) "ALLOWED" else "NOT_DETERMINED")

            "checkLocationServicesIfEnabled" -> result.success(platform!!.checkLocationServicesIfEnabled())

            "bluetoothState" -> {
                try {
                    val flag = platform!!.checkBluetoothIfEnabled()
                    result.success(if (flag) "STATE_ON" else "STATE_OFF")
                } catch (ignored: RuntimeException) {
                }
                result.success("STATE_UNSUPPORTED")
            }

            "requestAuthorization" -> {
                if (activityPluginBinding == null) {
                    result.success(false)
                    return
                }

                if (!platform!!.checkLocationServicesPermission()) {
                    flutterResult = result
                    platform!!.requestAuthorization(activityPluginBinding!!.activity)
                    return
                }

                // Here, location services permission is granted.
                //
                // It's possible location permission was granted without going through
                // our onRequestPermissionsResult() - for example if a different flutter plugin
                // also requested location permissions, we could end up here with
                // checkLocationServicesPermission() returning true before we ever called requestAuthorization().
                //
                // In that case, we'll never get a notification posted to eventSinkLocationAuthorizationStatus
                //
                // So we could could have flutter code calling requestAuthorization here and expecting to see
                // a change in eventSinkLocationAuthorizationStatus but never receiving it.
                //
                // Ensure an ALLOWED status (possibly duplicate) is posted back.
                if (eventSinkLocationAuthorizationStatus != null) {
                    eventSinkLocationAuthorizationStatus!!.success("ALLOWED")
                }
                result.success(true)
            }

            "openBluetoothSettings" -> {
                if (activityPluginBinding == null) {
                    result.success(false)
                    return
                }

                if (!platform!!.checkBluetoothIfEnabled()) {
                    flutterResultBluetooth = result
                    platform!!.openBluetoothSettings(activityPluginBinding!!.activity)
                    return
                }
                result.success(true)
            }

            "openLocationSettings" -> {
                platform!!.openLocationSettings()
                result.success(true)
            }

            "isBroadcastSupported" -> result.success(platform!!.isBroadcastSupported)

            else -> result.notImplemented()
        }
    }

    private fun initializeAndCheck(result: Result) {
        if (platform!!.checkLocationServicesPermission()
            && platform!!.checkBluetoothIfEnabled()
            && platform!!.checkLocationServicesIfEnabled()
        ) {
            result.success(true)
            return
        }
        flutterResult = result
        if (!platform!!.checkBluetoothIfEnabled() && activityPluginBinding != null) {
            platform!!.openBluetoothSettings(activityPluginBinding!!.activity)
            return
        }
        if (!platform!!.checkLocationServicesPermission() && activityPluginBinding != null) {
            platform!!.requestAuthorization(activityPluginBinding!!.activity)
            return
        }
        if (!platform!!.checkLocationServicesIfEnabled()) {
            platform!!.openLocationSettings()
            return
        }
        if (beaconManager != null && !beaconManager!!.isBound(beaconScanner!!.beaconConsumer)) {
            flutterResult = result
            beaconManager!!.bind(beaconScanner!!.beaconConsumer)
            return
        }
        result.success(true)
    }

    private val locationAuthorizationStatusStreamHandler: EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventSink) {
            eventSinkLocationAuthorizationStatus = events
        }

        override fun onCancel(arguments: Any?) {
            eventSinkLocationAuthorizationStatus = null
        }
    }

    // region ACTIVITY CALLBACK
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String?>, grantResults: IntArray): Boolean {
        if (requestCode != REQUEST_CODE_LOCATION) {
            return false
        }
        var locationServiceAllowed = false
        if (permissions.isNotEmpty() && grantResults.isNotEmpty()) {
            val permission = permissions[0]
            if (activityPluginBinding != null && !platform!!.shouldShowRequestPermissionRationale(permission, activityPluginBinding!!.activity)) {
                val grantResult = grantResults[0]
                if (grantResult == PackageManager.PERMISSION_GRANTED) {
                    //allowed
                    locationServiceAllowed = true
                }
                if (eventSinkLocationAuthorizationStatus != null) {
                    // shouldShowRequestPermissionRationale = false, so if access wasn't granted, the user clicked DENY and checked DON'T SHOW AGAIN
                    eventSinkLocationAuthorizationStatus!!.success(if (locationServiceAllowed) "ALLOWED" else "DENIED")
                }
            } else {
                // shouldShowRequestPermissionRationale = true, so the user has clicked DENY but not DON'T SHOW AGAIN, we can possibly prompt again
                if (eventSinkLocationAuthorizationStatus != null) {
                    eventSinkLocationAuthorizationStatus!!.success("NOT_DETERMINED")
                }
            }
        } else {
            // Permission request was cancelled (another requestPermission active, other interruptions), we can possibly prompt again
            if (eventSinkLocationAuthorizationStatus != null) {
                eventSinkLocationAuthorizationStatus!!.success("NOT_DETERMINED")
            }
        }
        if (flutterResult != null) {
            if (locationServiceAllowed) {
                flutterResult!!.success(true)
            } else {
                flutterResult!!.error("Beacon", "location services not allowed", null)
            }
            flutterResult = null
        }
        return locationServiceAllowed
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
        val bluetoothEnabled = requestCode == REQUEST_CODE_BLUETOOTH && resultCode == Activity.RESULT_OK
        if (bluetoothEnabled) {
            if (!platform!!.checkLocationServicesPermission() && activityPluginBinding != null) {
                platform!!.requestAuthorization(activityPluginBinding!!.activity)
            } else {
                if (flutterResultBluetooth != null) {
                    flutterResultBluetooth!!.success(true)
                    flutterResultBluetooth = null
                } else if (flutterResult != null) {
                    flutterResult!!.success(true)
                    flutterResult = null
                }
            }
        } else {
            if (flutterResultBluetooth != null) {
                flutterResultBluetooth!!.error("Beacon", "bluetooth disabled", null)
                flutterResultBluetooth = null
            } else if (flutterResult != null) {
                flutterResult!!.error("Beacon", "bluetooth disabled", null)
                flutterResult = null
            }
        }
        return bluetoothEnabled
    }

}
