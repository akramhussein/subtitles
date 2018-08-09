//
//  GoogleSpeechToTextStreamingTap.swift
//  Subtitles
//
//  Created by Akram Hussein on 01/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation
import AudioKit
import googleapis

open class GoogleSpeechToTextStreamingTap {

    internal var converter: AVAudioConverter!
    internal var responseHandler: ((StreamingRecognizeResponse?, Error?) -> Void)?
    internal var errorHandler: ((Error) -> Void)?

    @objc public init(_ input: AKNode?, sampleRate: Double = 16000.0, responseHandler: ((StreamingRecognizeResponse?, Error?) -> Void)? = nil) {

        self.responseHandler = responseHandler
        let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: false)!

        self.converter = AVAudioConverter(from: AudioKit.format, to: format)
        self.converter?.sampleRateConverterAlgorithm = AVSampleRateConverterAlgorithm_Normal
        self.converter?.sampleRateConverterQuality = .max

        let sampleRateRatio = AKSettings.sampleRate / sampleRate
        let sampleLength = 0.1 // 100ms
        let inputSampleRate = AudioKit.format.sampleRate
        let inputBufferSize = sampleLength * inputSampleRate // i.e 100ms of 44.1K = 4410 samples.

        input?.avAudioNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(inputBufferSize), format: nil) { buffer, _ in

            let capacity = Int(Double(buffer.frameCapacity) / sampleRateRatio)
            let bufferPCM16 = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(capacity))!

            var error: NSError?
            self.converter?.convert(to: bufferPCM16, error: &error) { _, outStatus in
                outStatus.pointee = AVAudioConverterInputStatus.haveData
                return buffer
            }

            let channel = UnsafeBufferPointer(start: bufferPCM16.int16ChannelData!, count: 1)
            let data = Data(bytes: channel[0], count: capacity * 2)

            SpeechRecognitionService
                .sharedInstance
                .streamAudioData(data,
                                 completion: { response, error in
                                     self.responseHandler?(response, error)
                })
        }
    }
}
