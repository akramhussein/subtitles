//
//  SpeechRecognitionService.swift
//  Subtitles
//
//  Created by Akram Hussein on 06/08/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation
import googleapis
import DefaultsKit

typealias SpeechRecognitionCompletionHandler = (StreamingRecognizeResponse?, NSError?) -> Void

final class SpeechRecognitionService {
    var sampleRate: Int = 16000
    private var streaming = false

    private var client: Speech!
    private var writer: GRXBufferedPipe!
    private var call: GRPCProtoCall!

    static let sharedInstance = SpeechRecognitionService()

    func streamAudioData(_ audioData: Data, completion: @escaping SpeechRecognitionCompletionHandler) {
        if !self.streaming {
            // if we aren't already streaming, set up a gRPC connection
            self.client = Speech(host: Keys.GoogleSpeechToTextHost)
            self.writer = GRXBufferedPipe()
            self.call = self.client.rpcToStreamingRecognize(withRequestsWriter: self.writer,
                                                            eventHandler: { _, response, error in
                                                                completion(response, error as NSError?)
            })

            let apiKey = Defaults.shared.get(for: Keys.GoogleSpeechToTextAPIKey) ?? ""

            self.call.requestHeaders.setObject(NSString(string: apiKey),
                                               forKey: NSString(string: "X-Goog-Api-Key"))
            self.call.requestHeaders.setObject(NSString(string: Bundle.main.bundleIdentifier!),
                                               forKey: NSString(string: "X-Ios-Bundle-Identifier"))

            //            print("HEADERS: \(self.call.requestHeaders)")

            self.call.start()
            self.streaming = true

            // send an initial request message to configure the service
            let recognitionConfig = RecognitionConfig()
            recognitionConfig.encoding = .linear16
            recognitionConfig.sampleRate = Int32(self.sampleRate)
            recognitionConfig.languageCode = Defaults.shared.get(for: Keys.Language) ?? Keys.DefaultLanguage
            recognitionConfig.maxAlternatives = 1

            let speechContext = SpeechContext()

            var commonPhrases = Defaults.shared.get(for: Keys.CommonPhrases) ?? [String]()

            // Add any keywords as well
            if let keywords = Defaults.shared.get(for: Keys.KeywordsAndColours) {
                commonPhrases.append(contentsOf: Array(keywords.keys))
            }
            speechContext.phrasesArray = NSMutableArray(array: commonPhrases)

            recognitionConfig.speechContext = speechContext

            let streamingRecognitionConfig = StreamingRecognitionConfig()
            streamingRecognitionConfig.config = recognitionConfig
            streamingRecognitionConfig.singleUtterance = false
            streamingRecognitionConfig.interimResults = true

            let streamingRecognizeRequest = StreamingRecognizeRequest()
            streamingRecognizeRequest.streamingConfig = streamingRecognitionConfig

            self.writer.writeValue(streamingRecognizeRequest)
        }

        // send a request message containing the audio data
        let streamingRecognizeRequest = StreamingRecognizeRequest()
        streamingRecognizeRequest.audioContent = audioData as Data
        self.writer.writeValue(streamingRecognizeRequest)
    }

    func stopStreaming() {
        if !self.streaming {
            return
        }
        self.writer.finishWithError(nil)
        self.streaming = false
    }

    func isStreaming() -> Bool {
        return self.streaming
    }

}
