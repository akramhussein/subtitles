//
//  AudioViewController.swift
//  Subtitles
//
//  Created by Akram Hussein on 01/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit
import Material
import googleapis
import MBProgressHUD
import DefaultsKit

final class AudioViewController: UIViewController {

    // Buttons
    var fabButton: FABButton!
    var fabMenu = FABMenu()
    var clearFABMenuItem: FABMenuItem!
    var playPauseFABMenuItem: FABMenuItem!
    var addCommonPhrasesFABMenuItem: FABMenuItem!
    var showHypothesisTextFABMenuItem: FABMenuItem!
    var changeMicrophoneFABMenuItem: FABMenuItem!
    var keywordColoursFABMenuItem: FABMenuItem!
    var optionsFABMenuItem: FABMenuItem!

    let fabMenuSize = CGSize(width: 56, height: 56)
    let rightInset: CGFloat = 24

    // Other
    var namePrefix = ""

    // Defaults
    var keywordsAndColours: [String: [String: String]] {
        return Defaults.shared.get(for: Keys.KeywordsAndColours) ?? [String: [String: String]]()
    }

    // UI
    var hud = MBProgressHUD()
    var currentHighlightColor: UIColor = Color.red.base

    var currentTextAttributes: [NSAttributedStringKey: AnyObject] {
        return [
            NSAttributedStringKey.backgroundColor: self.currentHighlightColor,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30.0)
        ]
    }

    var currentTempTextAttributes: [NSAttributedStringKey: AnyObject] {
        return [
            NSAttributedStringKey.backgroundColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: self.currentHighlightColor,
            NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 30.0)
        ]
    }

    // UI Outlets

    @IBOutlet private var amplitudeLabel: UILabel! {
        didSet {
            self.amplitudeLabel.textColor = .white
        }
    }

    @IBOutlet private var audioInputPlot: EZAudioPlotGL! {
        didSet {
            self.audioInputPlot.backgroundColor = .clear
        }
    }

    @IBOutlet weak var textView: UITextView! {
        didSet {
            self.textView.backgroundColor = .clear
            self.textView.isEditable = false
            self.textView.isScrollEnabled = true
        }
    }

    // Bluetooth
    var bluetoothRelay: BluetoothRelay?
    var bluetoothConnectTimer = Timer()

    enum Mode: String {
        case mic, bluetooth
    }

    var mode: Mode = .mic {
        didSet {
            self.changeMicrophoneFABMenuItem.fabButton.tintColor = (self.mode == .mic) ? Color.blue.base : Color.red.base
            self.changeMicrophoneFABMenuItem.title = (self.mode == .mic) ? "Switch to Bluetooth Microphone" : "Switch to iPhone Microphone"
        }
    }

    var restartInProgress = false
    var speechDetected = false
    var speechWhileEnding = false
    var endingTransaction = false
    var transactionTimer = Timer()
    var finalTimer = Timer()
    var finalTextEndRangeMarker = 0
    var shouldShowHypothesis = true

    func startMic(restart: Bool = false) {
        self.stopBluetooth()

        // UI
        if !restart {
            self.currentHighlightColor = Color.red.base
            self.namePrefix = ""
            self.plot.color = Color.red.base
            self.plot.isHidden = false
            self.fabButton.backgroundColor = self.currentHighlightColor
        }

        self.speechWhileEnding = false

        // Start recognition
        SpeechRecognitionService.sharedInstance.sampleRate = Int(self.sampleRate)

        // Start audio stream
        AudioKit.start()

        // Stop transcription before hitting 60s streaming limit
        self.transactionTimer = Timer.scheduledTimer(timeInterval: 55.0,
                                                     target: self,
                                                     selector: #selector(transactionTimeoutHandler),
                                                     userInfo: nil,
                                                     repeats: false)
    }

    func stopMic() {
        // Cancel Mic state properties
        self.transactionTimer.invalidate()
        self.restartInProgress = false
        self.speechDetected = false
        self.speechWhileEnding = false
        self.endingTransaction = false

        // Stop audio stream
        AudioKit.stop()

        // Stop recognition
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            SpeechRecognitionService.sharedInstance.stopStreaming()
        })
    }

    func startBluetooth() {
        self.stopMic()

        // Setup
        self.hud = MBProgressHUD.createLoadingHUD(view: self.view, message: "Connecting to Bobbycom")
        self.bluetoothConnectTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                                          target: self,
                                                          selector: #selector(AudioViewController.bluetoothConnectTimerExpired(_:)),
                                                          userInfo: nil,
                                                          repeats: false)
        self.bluetoothRelay = BluetoothRelay()
        self.bluetoothRelay?.delegate = self

        // UI
        self.currentHighlightColor = Color.blue.base
        self.namePrefix = ""
        self.plot.color = Color.blue.base
        self.plot.isHidden = true

        self.fabButton.backgroundColor = self.currentHighlightColor
    }

    func stopBluetooth() {
        // Cancel bluetooth
        self.bluetoothConnectTimer.invalidate()
        guard let relay = self.bluetoothRelay else { return }
        relay.disconnectPeripheral()
        relay.delegate = nil
    }

    // Restart streaming after API error
    func restart() {
        if self.mode == .mic {
            if self.restartInProgress { return }
            self.restartInProgress = true

            self.stopMic()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.restartInProgress = false
                self.startMic(restart: true)
            }
        }
    }

    var play: Bool = false {
        didSet {
            if self.play {
                if self.mode == .mic {
                    self.startMic()
                } else {
                    self.startBluetooth()
                }
            } else {
                if self.mode == .mic {
                    self.stopMic()
                } else {
                    self.stopBluetooth()
                }
            }
            self.playPauseFABMenuItem.title = self.play ? "Pause" : "Play"
            self.playPauseFABMenuItem.fabButton.image = self.play ? Icon.cm.pause : Icon.cm.play
            self.playPauseFABMenuItem.fabButton.tintColor = self.play ? Color.red.base : Color.green.base
        }
    }

    // Speech
    let sampleRate = 16000.0
    var confidenceThreshold: Float {
        return Defaults.shared.get(for: Keys.SpeechConfidence) ?? 0.80
    }

    // AudioKit
    var mic: AKMicrophone!
    var amplitudeTracker: AKAmplitudeTracker!
    var silence: AKBooster!
    var tap: GoogleSpeechToTextStreamingTap!
    var plot: AKNodeOutputPlot!

    @objc func transactionTimeoutHandler() {
        if self.speechDetected {
            return // transaction will be restarted once isFinal transcription is received
        } else {
            self.restart()
        }
    }

    func setupPlot() {
        self.plot = AKNodeOutputPlot(self.mic, frame: self.audioInputPlot.bounds)
        self.plot.backgroundColor = .clear
        self.plot.plotType = .buffer
        self.plot.shouldFill = false
        self.plot.shouldMirror = false
        self.plot.color = self.currentHighlightColor
        self.audioInputPlot.addSubviewAndAttach(subview: self.plot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black

        // Setup Audio
        AKSettings.audioInputEnabled = true

        self.mic = AKMicrophone()
        self.amplitudeTracker = AKAmplitudeTracker(self.mic)

        /*
         * Streaming recognition fails silently after ~60 of continuous audio. This limit applies whether we are silent or speaking.
         * To use streaming recognition over a longer session, we take advantage of natural pauses in speech to split the
         * recognition task into discrete transactions. We rely on the API to detect these pauses and then automatically restart
         * the recognition process to reset our 60 second budget.
         *
         * Each streaming recognition transaction proceeds roughly as follows:
         *
         * start sending audio samples
         *    no response during initial silence
         * start speaking (this sequence will repeat if speaker pauses briefly)
         *    endpointerType: START_OF_SPEECH
         *    live results (isFinal NO)
         *    endpointerType: END_OF_SPEECH
         * stop speaking (aka longer pause or stop speaking)
         *    final results (isFinal YES)
         * stop sending audio samples
         *    endpointerType: END_OF_AUDIO (sometimes repeated, sometimes arrives before isFinal response)
         * automatically start next transaction
         *
         */
        self.tap = GoogleSpeechToTextStreamingTap(self.amplitudeTracker,
                                                  sampleRate: self.sampleRate,
                                                  responseHandler: { response, error in
                                                      var finished = false

                                                      if let err = error {
                                                          print("ERROR: \(err.localizedDescription)")
                                                          self.restart()
                                                          return
                                                      }

                                                      if let response = response {
                                                          if response.hasError {
                                                              if !self.endingTransaction {
                                                                  self.restart()
                                                              }
                                                          } else if response.endpointerType == StreamingRecognizeResponse_EndpointerType.startOfSpeech {
                                                              self.speechDetected = true
                                                              if self.endingTransaction {
                                                                  self.speechWhileEnding = true
                                                              }
                                                          } else if response.endpointerType == StreamingRecognizeResponse_EndpointerType.endOfSpeech {
                                                              self.speechDetected = true
                                                              if self.endingTransaction { self.speechWhileEnding = true }
                                                          } else if response.endpointerType == StreamingRecognizeResponse_EndpointerType.endOfAudio {
                                                              if self.endingTransaction {
                                                                  self.endingTransaction = false
                                                                  self.speechDetected = false
                                                                  print("Restarting audio")
                                                                  self.restart()
                                                              }
                                                          } else {
                                                              for result in response.resultsArray! {

                                                                  if let result = result as? StreamingRecognitionResult,
                                                                      let currentAttrText = self.textView.attributedText {

                                                                      let copy = currentAttrText.attributedSubstring(from: NSMakeRange(0, self.finalTextEndRangeMarker))

                                                                      if result.isFinal {

                                                                          finished = true

                                                                          if let firstResult = result.alternativesArray.firstObject as? SpeechRecognitionAlternative {

                                                                              if firstResult.confidence >= self.confidenceThreshold {

                                                                                  //                                                                                self.finalTimer.invalidate() // no need to self-finalise text
                                                                                  print("FINAL: \(firstResult.transcript)")
                                                                                  var cleanedTranscript = self.setHighlightColorForKeyword(text: firstResult.transcript)
                                                                                  if !self.namePrefix.isEmpty { cleanedTranscript = "\(self.namePrefix.uppercased()): \(cleanedTranscript)" }

                                                                                  let attrString = NSMutableAttributedString(string: cleanedTranscript.capitalizingFirstLetter.trim,
                                                                                                                             attributes: self.currentTextAttributes)

                                                                                  let newLineAttrString = NSMutableAttributedString(string: "\n\n")

                                                                                  let finalString = copy + attrString + newLineAttrString

                                                                                  self.textView.attributedText = finalString
                                                                                  self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.count, 0))
                                                                                  self.finalTextEndRangeMarker = self.textView.text.count
                                                                              } else {
                                                                                  print("FINAL text not above threshold \(firstResult.confidence) < \(self.confidenceThreshold)")
                                                                              }
                                                                          }
                                                                      } else {

                                                                          if !self.shouldShowHypothesis { return }

                                                                          if let firstResult = result.alternativesArray.firstObject as? SpeechRecognitionAlternative {
                                                                              print("TEMP: \(firstResult)")
                                                                              guard let transcript = firstResult.transcript else { return }

                                                                              var cleanedTranscript = self.setHighlightColorForKeyword(text: transcript)
                                                                              if !self.namePrefix.isEmpty { cleanedTranscript = "\(self.namePrefix.uppercased()): \(cleanedTranscript)" }

                                                                              let attrString = NSMutableAttributedString(string: cleanedTranscript.capitalizingFirstLetter.trim,
                                                                                                                         attributes: self.currentTempTextAttributes)
                                                                              self.textView.attributedText = copy + attrString
                                                                              self.textView.scrollRangeToVisible(NSMakeRange(self.textView.text.count, 0))
                                                                          }
                                                                      }
                                                                  }
                                                              }

                                                              if finished {
                                                                  if self.endingTransaction {
                                                                      print("Don't stop, endingTransaction")
                                                                  } else if self.speechWhileEnding {
                                                                      print("Don't stop, speechWhileEnding")
                                                                  } else {
                                                                      self.endingTransaction = true
                                                                      print("Stopping audio")
                                                                      self.restart()

                                                                  }
                                                                  self.speechWhileEnding = false
                                                              }
                                                          }
                                                      }

        })

        self.silence = AKBooster(self.amplitudeTracker, gain: 0.0)
        AudioKit.output = self.silence

        // Setup UI
        self.setupPlot()
        self.prepareButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareFABMenu()
        self.play = true
        //        self.setScreenshotText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AudioViewController.rotated),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)

        // If no API key saved, go to Options page
        let apiKey = Defaults.shared.get(for: Keys.GoogleSpeechToTextAPIKey)
        if apiKey == nil || apiKey!.isEmpty {
            self.handlePlayPauseFABMenuItem(button: self)
            self.handleOptionsFABMenuItem(button: self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.play = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                  object: nil)
    }

    @objc func rotated() {
        self.prepareFABMenu()
    }

    func setHighlightColorForKeyword(text: String) -> String {
        if self.keywordsAndColours.count == 0 { return text }

        let keywords = self.keywordsAndColours.keys
        let tokens = text.lowercased().split { $0 == " " }.map(String.init)
        let intersection = tokens.filter { (string) -> Bool in
            return keywords.contains(string)
        }

        if intersection.count > 0 {
            let last = Array(intersection).last! // last keyword said

            guard let nameAndColour = self.keywordsAndColours[last],
                let colourString = nameAndColour["colour"],
                let name = nameAndColour["name"] else { return text }

            self.currentHighlightColor = UIColor(rgba: colourString)

            // Cache name prefix
            self.namePrefix = name.uppercased()

            let showKeywords = Defaults.shared.get(for: Keys.ShowKeywords) ?? true
            if showKeywords {
                return text
            }

            // Strip out final keyword from transcript - lower and titlecased and consider spaces after
            let stripped = text.replace("\(last) ", replacement: "").replace(last.capitalizingFirstLetter, replacement: "") // if mid-sentence, remove gap
                .replace(last, replacement: "").replace(last.capitalizingFirstLetter, replacement: "") // if start or end of sentence

            return stripped
        }

        return text
    }

    @objc func bluetoothConnectTimerExpired(_ sender: Any) {
        self.hud.setHUDToFailed(message: "Audio.BluetoothMicrophone.Failed.Title".localized,
                                detailsMessage: "Audio.BluetoothMicrophone.Failed.Message".localized,
                                delay: 4.0)
        self.mode = .mic
        self.startMic()
    }

    func setScreenshotText() {
        let first = "JOHN: How are you doing today David?"
        let firstColour = Color.red.base

        let second = "DAVID: I'm doing great, how about yourself?"
        let secondColour = Color.green.base

        let third = "JOHN: Shall we order coffee?"

        let firstAttrString = NSMutableAttributedString(string: first.capitalizingFirstLetter.trim,
                                                        attributes: self.currentTextAttributes)

        self.currentHighlightColor = secondColour

        let secondAttrString = NSMutableAttributedString(string: second.capitalizingFirstLetter.trim,
                                                         attributes: self.currentTextAttributes)

        self.currentHighlightColor = firstColour

        let thirdAttrString = NSMutableAttributedString(string: third.capitalizingFirstLetter.trim,
                                                        attributes: self.currentTempTextAttributes)

        let newLineAttrString = NSMutableAttributedString(string: "\n\n")

        let finalString = NSMutableAttributedString()
        finalString.append(firstAttrString)
        finalString.append(newLineAttrString)
        finalString.append(secondAttrString)
        finalString.append(newLineAttrString)
        finalString.append(thirdAttrString)

        self.textView.attributedText = finalString
    }
}
