//
//  AudioViewController+BluetoothRelayDelegate.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation
import Material
import MBProgressHUD
import DefaultsKit

extension AudioViewController: BluetoothRelayDelegate {
    func processRelayData(_ data: Data) {
        var isFinal = false
        var asrText = ""

        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]] else { return }

            print("BLE JSON: \(json)")

            if let text = json["text"],
                let message = text["message"] as? String,
                let final = text["final"] as? Bool {
                print("BLE: \(message), final: \(final)")
                asrText = message
                isFinal = final
            }

        } catch {
            print("Did not parse message")
        }

        if asrText.isEmpty { return }
        var cleanedTranscript = self.setHighlightColorForKeyword(text: asrText)

        // Prefix with name associated with keyword
        if !self.namePrefix.isEmpty { cleanedTranscript = "\(self.namePrefix.uppercased()): \(cleanedTranscript)" }

        DispatchQueue.main.async {
            if let currentAttrText = self.textView.attributedText {

                let copy = currentAttrText.attributedSubstring(from: NSMakeRange(0, self.finalTextEndRangeMarker))

                if isFinal {

                    let attrString = NSMutableAttributedString(string: cleanedTranscript.capitalizingFirstLetter.trim,
                                                               attributes: self.currentTextAttributes)

                    let newLineAttrString = NSMutableAttributedString(string: "\n\n")

                    let finalString = copy + attrString + newLineAttrString

                    self.textView.attributedText = finalString
                    self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.count, 0))
                    self.finalTextEndRangeMarker = self.textView.text.count
                } else {

                    if !self.shouldShowHypothesis { return }

                    let attrString = NSMutableAttributedString(string: cleanedTranscript.capitalizingFirstLetter.trim,
                                                               attributes: self.currentTempTextAttributes)
                    self.textView.attributedText = copy + attrString
                    self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.count, 0))
                }
            }
        }
    }

    func bluetoothStateDidUpdate(oldState: BluetoothRelay.State?, newState: BluetoothRelay.State?) {
        print(#function)
        guard let peripherals = newState?.peripherals, peripherals.count > 0 else { return }
        if newState?.peripheral == nil {
            self.bluetoothRelay?.connect(to: peripherals.first!)
        }
    }

    func didDiscoverCharacteristics() {
        let langID = Defaults.shared.get(for: Keys.Language) ?? Keys.DefaultLanguage
        self.sendLanguage(language: langID)

        // Send common phrases on connection
        var commonPhrases = Defaults.shared.get(for: Keys.CommonPhrases) ?? [String]()
        if let keywords = Defaults.shared.get(for: Keys.KeywordsAndColours) {
            commonPhrases.append(contentsOf: Array(keywords.keys))
        }
        self.sendCommonPhrases(commonPhrases: commonPhrases)
    }

    func didConnect() {
        print(#function)
        self.bluetoothConnectTimer.invalidate()
        DispatchQueue.main.async {
            self.hud.setHUDToComplete(message: "Audio.BluetoothMicrophone.Connected".localized, detailsMessage: nil, delay: 2.0)
        }
    }

    func didDisconnect() {
        print(#function)
        DispatchQueue.main.async {
            self.mode = .mic
            self.startMic()
            self.hud = MBProgressHUD.createFailedHUD(view: self.view, message: "Audio.BluetoothMicrophone.LostConnection".localized)
        }
    }

    func failedToConnect() {
        print(#function)
        DispatchQueue.main.async {
            self.mode = .mic
            self.startMic()
            self.hud.setHUDToFailed(message: "Audio.BluetoothMicrophone.Failed.Title".localized,
                                    detailsMessage: "Audio.BluetoothMicrophone.Failed.Message".localized,
                                    delay: 4.0)
        }
    }

    func sendKeyword(colour: String) {
        do {
            let json: [String: Any] = ["message": "keyword", "data": colour]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            try self.bluetoothRelay?.sendSDP(data)
        } catch {
            print("ERROR: Unable to send keyword colour")
        }
    }

    func sendLanguage(language: String) {
        do {
            let json: [String: Any] = ["message": "language", "data": language]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            try self.bluetoothRelay?.sendSDP(data)
        } catch {
            print("ERROR: Unable to send language identifier")
        }
    }

    func sendCommonPhrases(commonPhrases: [String]) {
        do {
            let json: [String: Any] = ["message": "phrases", "data": commonPhrases]
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            try self.bluetoothRelay?.sendSDP(data)
        } catch {
            print("ERROR: Unable to send common phrases")
        }
    }
}
