package com.lukangagames.plugins.beaconscanner

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import org.altbeacon.beacon.BeaconTransmitter

internal class FlutterPlatform(private val context: Context) {
    fun openLocationSettings() {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }

    fun openBluetoothSettings() {
        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        // TODO: Do not cast context to Activity
        (context as Activity).startActivityForResult(intent, BeaconScannerPlugin.REQUEST_CODE_BLUETOOTH)
    }

    fun requestAuthorization() {
        // TODO: Do not cast context to Activity
        ActivityCompat.requestPermissions(
            (context as Activity), arrayOf<String>(
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION
            ), BeaconScannerPlugin.REQUEST_CODE_LOCATION
        )
    }

    fun checkLocationServicesPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        } else true
    }

    fun checkLocationServicesIfEnabled(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager?
            return locationManager != null && locationManager.isLocationEnabled
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val mode = Settings.Secure.getInt(
                context.contentResolver, Settings.Secure.LOCATION_MODE,
                Settings.Secure.LOCATION_MODE_OFF
            )
            return mode != Settings.Secure.LOCATION_MODE_OFF
        }
        return true
    }

    fun checkBluetoothIfEnabled(): Boolean {
        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager?
            ?: throw RuntimeException("No bluetooth service")
        val adapter = bluetoothManager.adapter
        return adapter != null && adapter.isEnabled
    }

    val isBroadcastSupported: Boolean
        get() = BeaconTransmitter.checkTransmissionSupported(context) == 0

    fun shouldShowRequestPermissionRationale(permission: String?): Boolean {
        // TODO: Do not cast context to Activity
        return ActivityCompat.shouldShowRequestPermissionRationale((context as Activity), permission!!)
    }
}