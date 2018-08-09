//
//  BluetoothRelay.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation
import CoreBluetooth
import SimpleDatagramProtocol

protocol BluetoothRelayDelegate: class {
    func processRelayData(_ data: Data)
    func bluetoothStateDidUpdate(oldState: BluetoothRelay.State?, newState: BluetoothRelay.State?)
    func didConnect()
    func didDisconnect()
    func failedToConnect()
    func didDiscoverCharacteristics()
}

enum PeripheralConnectionError: Error {
    case invalidPeripheral
}

fileprivate var key: UInt8 = 255
func nextKey() -> UInt8 {
    key = key &+ 1
    return key
}

final class BluetoothRelay: NSObject {

    struct State {
        fileprivate(set) var peripheral: CBPeripheral?
        fileprivate(set) var peripherals: [CBPeripheral] = []

        fileprivate mutating func insert(peripheral: CBPeripheral) {
            guard !self.peripherals.contains(peripheral) else { return }
            self.peripherals.append(peripheral)
        }
    }

    enum ConnectionError: Swift.Error {
        case notConnected
    }

    weak var delegate: BluetoothRelayDelegate?

    /// Should connect automatically at startup.
    /// Set to false to be able to choose another from a list.
    var connectAutomatically = true

    fileprivate let centralManager: CBCentralManager
    fileprivate private(set) lazy var sdpMessageManager: MessageManager = {
        MessageManager { [weak self] message in
            self?.delegate?.processRelayData(message.data)
        }
    }()

    fileprivate(set) var state: State? {
        didSet {
            self.delegate?.bluetoothStateDidUpdate(oldState: oldValue, newState: self.state)
        }
    }

    var peripheral: CBPeripheral? {
        return self.state?.peripheral
    }

    fileprivate var service: CBService?
    fileprivate var characteristic: CBCharacteristic?

    override init() {
        let queue = DispatchQueue(label: "com.bobbycom.bluetooth", attributes: [])
        self.centralManager = CBCentralManager(delegate: nil, queue: queue)
        super.init()
        self.centralManager.delegate = self
    }

    fileprivate func startScan() {
        print(#function)
        self.centralManager.scanForPeripherals(withServices: [CBUUID.serviceID], options: nil)
    }

    func restartScan() {
        print(#function)
        self.centralManager.stopScan()
        if let state = state, let peripheral = state.peripheral {
            self.state?.peripherals = [peripheral]
        }
        self.startScan()
    }

    func connect(to peripheral: CBPeripheral) {
        print("RELAY: Connecting to \(peripheral.name ?? "NO_NAME")")
        //        disconnectPeripheral()
        self.centralManager.connect(peripheral, options: nil)
    }

    func disconnectPeripheral() {
        print("RELAY: Disconnecting from peripheral")
        guard let peripheral = self.peripheral else { return }
        self.centralManager.cancelPeripheralConnection(peripheral)
    }

    func send(_ data: Data) throws {
        print(#function)
        guard
            let peripheral = self.peripheral,
            let characteristic = self.characteristic
        else { throw ConnectionError.notConnected }

        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    func sendSDP(_ data: Data) throws {
        print(#function)
        let message = Message(key: nextKey(), data: data)

        for datagram in message.datagrams(datagramMaxSize: 182) {
            try send(datagram.encoded)
        }
    }
}

extension CBManagerState: CustomStringConvertible {

    public var description: String {
        switch self {
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        }
    }
}

private extension CBUUID {
    static let serviceID = CBUUID(string: "13EA4259-9D9E-42D1-A78B-638ED22CC768")
    static let characteristicID = CBUUID(string: "81D97A06-7A2D-4A98-A2E2-41688E3D8283")
}

extension BluetoothRelay: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("RELAY: Discovered \(peripheral.name ?? "NO_NAME")")
        self.state?.insert(peripheral: peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("RELAY: Did connect to \(peripheral.name ?? "NO_NAME")")
        self.state?.peripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.serviceID])
        self.delegate?.didConnect()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Swift.Error?) {
        print("RELAY: Did disconnect from \(peripheral.name ?? "NO_NAME")")
        peripheral.delegate = nil
        self.state?.peripheral = nil
        self.service = nil
        self.characteristic = nil
        self.delegate?.didDisconnect()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // Basically this shouldn't ever happen
        // There is no timeout on peripheral connection so this method should not be relied on
        print("Failed to connect to Bluetooth Device")
        self.delegate?.failedToConnect()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("RELAY: Updated Central Manager State: \(central.state.rawValue)")

        // print("centralManagerDidUpdateState \(central.state)")
        switch central.state {
        case .poweredOff, .resetting, .unauthorized, .unknown, .unsupported:
            self.state = nil
            self.delegate?.didDisconnect()
        case .poweredOn:
            self.startScan()
            self.state = State()
        }
    }
}

extension BluetoothRelay: CBPeripheralDelegate {

    // Mark: - CBPeripheralDelegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Swift.Error?) {
        print(#function)
        guard
            peripheral == self.peripheral,
            error == nil,
            let services = peripheral.services,
            !services.isEmpty
        else { return }

        for service in peripheral.services! where service.uuid == .serviceID {
            peripheral.discoverCharacteristics([CBUUID.characteristicID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Swift.Error?) {
        print(#function)
        guard
            peripheral == self.peripheral,
            error == nil,
            let characteristics = service.characteristics
        else { return }

        for characteristic in characteristics {
            if characteristic.uuid == CBUUID.characteristicID {
                self.service = service
                self.characteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                self.state?.peripheral = peripheral
            }
        }
        self.delegate?.didDiscoverCharacteristics()
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Swift.Error?) {
        print(#function)
        guard let data = characteristic.value else {
            return
        }
        do {
            try sdpMessageManager.process(datagramData: data)
        } catch {}
    }

    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print(#function)
        guard
            peripheral == self.peripheral,
            let service = self.service,
            invalidatedServices.contains(service)
        else { return }

        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}
