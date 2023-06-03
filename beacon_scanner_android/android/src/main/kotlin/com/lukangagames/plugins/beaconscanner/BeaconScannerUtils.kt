package com.lukangagames.plugins.beaconscanner

import android.util.Log
import org.altbeacon.beacon.Beacon
import org.altbeacon.beacon.Identifier
import org.altbeacon.beacon.MonitorNotifier
import org.altbeacon.beacon.Region
import java.util.Locale

internal object BeaconScannerUtils {
    fun parseState(state: Int): String {
        return if (state == MonitorNotifier.INSIDE) "INSIDE" else if (state == MonitorNotifier.OUTSIDE) "OUTSIDE" else "UNKNOWN"
    }

    fun beaconsToArray(beacons: List<Beacon>?): List<Map<String, Any>> {
        if (beacons == null) {
            return ArrayList()
        }
        val list: MutableList<Map<String, Any>> = ArrayList()
        for (beacon in beacons) {
            val map = beaconToMap(beacon)
            list.add(map)
        }
        return list
    }

    private fun beaconToMap(beacon: Beacon): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()
        map["proximityUUID"] = beacon.id1.toString().uppercase(Locale.getDefault())
        map["major"] = beacon.id2.toInt()
        map["minor"] = beacon.id3.toInt()
        map["rssi"] = beacon.rssi
        map["txPower"] = beacon.txPower
        map["accuracy"] = beacon.distance
        map["macAddress"] = beacon.bluetoothAddress
        map["proximity"] = rssiToProximity(beacon.rssi)
        return map
    }

    private fun rssiToProximity(rssi: Int): String {
        if (rssi <= 55) {
            return "near"
        }

        if (rssi <= 75) {
           return "immediate"
        }

        if(rssi <= 100) {
            return "far"
        }

        return "undefined"
    }

    fun regionToMap(region: Region): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()
        map["identifier"] = region.uniqueId
        if (region.id1 != null) {
            map["proximityUUID"] = region.id1.toString()
        }
        if (region.id2 != null) {
            map["major"] = region.id2.toInt()
        }
        if (region.id3 != null) {
            map["minor"] = region.id3.toInt()
        }
        return map
    }

    fun regionFromMap(map: Map<*, *>): Region? {
        return try {
            var identifier = ""
            val identifiers: MutableList<Identifier> = ArrayList()
            val objectIdentifier = map["identifier"]
            if (objectIdentifier is String) {
                identifier = objectIdentifier.toString()
            }
            val proximityUUID = map["proximityUUID"]
            if (proximityUUID is String) {
                identifiers.add(Identifier.parse(proximityUUID as String?))
            }
            val major = map["major"]
            if (major is Int) {
                identifiers.add(Identifier.fromInt((major as Int?)!!))
            }
            val minor = map["minor"]
            if (minor is Int) {
                identifiers.add(Identifier.fromInt((minor as Int?)!!))
            }
            Region(identifier, identifiers)
        } catch (e: IllegalArgumentException) {
            Log.e("REGION", "Error : $e")
            null
        }
    }

    fun beaconFromMap(map: Map<*, *>): Beacon {
        val builder = Beacon.Builder()
        val proximityUUID = map["proximityUUID"]
        if (proximityUUID is String) {
            builder.setId1(proximityUUID as String?)
        }
        val major = map["major"]
        if (major is Int) {
            builder.setId2(major.toString())
        }
        val minor = map["minor"]
        if (minor is Int) {
            builder.setId3(minor.toString())
        }
        val txPower = map["txPower"]
        if (txPower is Int) {
            builder.setTxPower((txPower as Int?)!!)
        } else {
            builder.setTxPower(-59)
        }
        builder.setDataFields(listOf(0L))
        builder.setManufacturer(0x004c)
        return builder.build()
    }
}