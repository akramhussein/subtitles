//
//  Keys.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import DefaultsKit

public struct Keys {
    /// Common phrases
    public static let CommonPhrases = Key<[String]>("CommonPhrases")

    /// Keywords and Colours
    public static let KeywordsAndColours = Key<[String: [String: String]]>("KeywordsAndColours")

    /// Google Speech-to-Text
    public static let GoogleSpeechToTextHost = "speech.googleapis.com"

    /// Options
    public static let GoogleSpeechToTextAPIKey = Key<String>("GoogleSpeechToTextAPIKey")
    public static let SpeechConfidence = Key<Float>("SpeechConfidence")
    public static let ShowKeywords = Key<Bool>("ShowKeywords")
    public static let Language = Key<String>("Language")

    /// Languages
    public static let DefaultLanguage = "en-GB"
    public static let AvailableLanguages = [
        "af-ZA": "Afrikaans (South Africa)",
        "am-ET": "Amharic (Ethiopia)",
        "hy-AM": "Armenian (Armenia)",
        "az-AZ": "Azerbaijani (Azerbaijan)",
        "id-ID": "Indonesian (Indonesia)",
        "ms-MY": "Malay (Malaysia)",
        "bn-BD": "Bengali (Bangladesh)",
        "bn-IN": "Bengali (India)",
        "ca-ES": "Catalan (Spain)",
        "cs-CZ": "Czech (Czech Republic)",
        "da-DK": "Danish (Denmark)",
        "de-DE": "German (Germany)",
        "en-AU": "English (Australia)",
        "en-CA": "English (Canada)",
        "en-GH": "English (Ghana)",
        "en-GB": "English (United Kingdom)",
        "en-IN": "English (India)",
        "en-IE": "English (Ireland)",
        "en-KE": "English (Kenya)",
        "en-NZ": "English (New Zealand)",
        "en-NG": "English (Nigeria)",
        "en-PH": "English (Philippines)",
        "en-ZA": "English (South Africa)",
        "en-TZ": "English (Tanzania)",
        "en-US": "English (United States)",
        "es-AR": "Spanish (Argentina)",
        "es-BO": "Spanish (Bolivia)",
        "es-CL": "Spanish (Chile)",
        "es-CO": "Spanish (Colombia)",
        "es-CR": "Spanish (Costa Rica)",
        "es-EC": "Spanish (Ecuador)",
        "es-SV": "Spanish (El Salvador)",
        "es-ES": "Spanish (Spain)",
        "es-US": "Spanish (United States)",
        "es-GT": "Spanish (Guatemala)",
        "es-HN": "Spanish (Honduras)",
        "es-MX": "Spanish (Mexico)",
        "es-NI": "Spanish (Nicaragua)",
        "es-PA": "Spanish (Panama)",
        "es-PY": "Spanish (Paraguay)",
        "es-PE": "Spanish (Peru)",
        "es-PR": "Spanish (Puerto Rico)",
        "es-DO": "Spanish (Dominican Republic)",
        "es-UY": "Spanish (Uruguay)",
        "es-VE": "Spanish (Venezuela)",
        "eu-ES": "Basque (Spain)",
        "fil-PH": "Filipino (Philippines)",
        "fr-CA": "French (Canada)",
        "fr-FR": "French (France)",
        "gl-ES": "Galician (Spain)",
        "ka-GE": "Georgian (Georgia)",
        "gu-IN": "Gujarati (India)",
        "hr-HR": "Croatian (Croatia)",
        "zu-ZA": "Zulu (South Africa)",
        "is-IS": "Icelandic (Iceland)",
        "it-IT": "Italian (Italy)",
        "jv-ID": "Javanese (Indonesia)",
        "kn-IN": "Kannada (India)",
        "km-KH": "Khmer (Cambodia)",
        "lo-LA": "Lao (Laos)",
        "lv-LV": "Latvian (Latvia)",
        "lt-LT": "Lithuanian (Lithuania)",
        "hu-HU": "Hungarian (Hungary)",
        "ml-IN": "Malayalam (India)",
        "mr-IN": "Marathi (India)",
        "nl-NL": "Dutch (Netherlands)",
        "ne-NP": "Nepali (Nepal)",
        "nb-NO": "Norwegian Bokm̴l (Norway)",
        "pl-PL": "Polish (Poland)",
        "pt-BR": "Portuguese (Brazil)",
        "pt-PT": "Portuguese (Portugal)",
        "ro-RO": "Romanian (Romania)",
        "si-LK": "Sinhala (Sri Lanka)",
        "sk-SK": "Slovak (Slovakia)",
        "sl-SI": "Slovenian (Slovenia)",
        "su-ID": "Sundanese (Indonesia)",
        "sw-TZ": "Swahili (Tanzania)",
        "sw-KE": "Swahili (Kenya)",
        "fi-FI": "Finnish (Finland)",
        "sv-SE": "Swedish (Sweden)",
        "ta-IN": "Tamil (India)",
        "ta-SG": "Tamil (Singapore)",
        "ta-LK": "Tamil (Sri Lanka)",
        "ta-MY": "Tamil (Malaysia)",
        "te-IN": "Telugu (India)",
        "vi-VN": "Vietnamese (Vietnam)",
        "tr-TR": "Turkish (Turkey)",
        "ur-PK": "Urdu (Pakistan)",
        "ur-IN": "Urdu (India)",
        "el-GR": "Greek (Greece)",
        "bg-BG": "Bulgarian (Bulgaria)",
        "ru-RU": "Russian (Russia)",
        "sr-RS": "Serbian (Serbia)",
        "uk-UA": "Ukrainian (Ukraine)",
        "he-IL": "Hebrew (Israel)",
        "ar-IL": "Arabic (Israel)",
        "ar-JO": "Arabic (Jordan)",
        "ar-AE": "Arabic (United Arab Emirates)",
        "ar-BH": "Arabic (Bahrain)",
        "ar-DZ": "Arabic (Algeria)",
        "ar-SA": "Arabic (Saudi Arabia)",
        "ar-IQ": "Arabic (Iraq)",
        "ar-KW": "Arabic (Kuwait)",
        "ar-MA": "Arabic (Morocco)",
        "ar-TN": "Arabic (Tunisia)",
        "ar-OM": "Arabic (Oman)",
        "ar-PS": "Arabic (State of Palestine)",
        "ar-QA": "Arabic (Qatar)",
        "ar-LB": "Arabic (Lebanon)",
        "ar-EG": "Arabic (Egypt)",
        "fa-IR": "Persian (Iran)",
        "hi-IN": "Hindi (India)",
        "th-TH": "Thai (Thailand)",
        "ko-KR": "Korean (South Korea)",
        "cmn-Hant-TW": "Chinese, Mandarin (Traditional, Taiwan)",
        "yue-Hant-HK": "Chinese, Cantonese (Traditional, Hong Kong)",
        "ja-JP": "Japanese (Japan)",
        "cmn-Hans-HK": "Chinese, Mandarin (Simplified, Hong Kong)",
        "cmn-Hans-CN": "Chinese, Mandarin (Simplified, China)"
    ]

}
