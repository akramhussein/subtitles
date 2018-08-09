//
//  OptionsViewController.swift
//  Subtitles
//
//  Created by Akram Hussein on 10/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Eureka
import UIKit
import DefaultsKit

final class OptionsViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Options.Title".localized

        self.navigationItem.leftBarButtonItem = .textBarButton("Done".localized, delegate: self, action: #selector(self.donePressed(_:)))
        self.navigationItem.rightBarButtonItem = .textBarButton("Save".localized, delegate: self, action: #selector(self.savePressed(_:)))

        self.form +++ Section(header: "Options.Section.APIKey.Header".localized, footer: "Options.Section.APIKey.Footer".localized)

            <<< TextRow("api_key") { row in
                row.value = Defaults.shared.get(for: Keys.GoogleSpeechToTextAPIKey)
            }

            +++ Section(header: "Options.Section.SpeechPredictionConfidence.Header".localized, footer: "Options.Section.SpeechPredictionConfidence.Footer".localized)

            <<< SliderRow("confidence") { row in
                row.title = "Options.Row.Confidence".localized
                row.minimumValue = 0.01
                row.maximumValue = 0.99
                row.steps = 98
                row.value = Defaults.shared.get(for: Keys.SpeechConfidence) ?? 0.80
                row.displayValueFor = {
                    String(format: "%.0f%%", ($0 ?? 0) * 100)
                }
            }

            +++ Section(header: "", footer: "Options.Section.ShowKeywords.Footer".localized)

            <<< PickerInlineRow<String>("language") {
                $0.title = "Options.Row.Language".localized
                $0.options = Keys.AvailableLanguages.map { $0.value }.sorted()
                let langId = Defaults.shared.get(for: Keys.Language) ?? Keys.DefaultLanguage
                let langName = Keys.AvailableLanguages[langId]
                $0.value = langName
            }

            <<< SwitchRow("show_keywords") { row in
                row.title = "Options.Row.ShowKeywords".localized
                row.value = Defaults.shared.get(for: Keys.ShowKeywords) ?? true
            }

    }

    // MARK: Actions

    @objc public func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc public func savePressed(_ sender: Any) {

        guard let apiKeyRow = self.form.rowBy(tag: "api_key") as? TextRow,
            let apiKey = apiKeyRow.value, !apiKey.trim.isEmpty else {
            self.showAlert("Options.Section.APIKey.Error".localized, okTitle: "OK".localized)
            return
        }

        guard let confidenceRow = self.form.rowBy(tag: "confidence") as? SliderRow,
            let confidence = confidenceRow.value else {
            self.showAlert("Options.Row.Confidence.Error".localized, okTitle: "OK".localized)
            return
        }

        guard let showKeywordsRow = self.form.rowBy(tag: "show_keywords") as? SwitchRow,
            let showKeywords = showKeywordsRow.value else {
            return
        }

        guard let languageRow = self.form.rowBy(tag: "language") as? PickerInlineRow<String>,
            let languageName = languageRow.value else {
            return
        }

        Defaults.shared.set(apiKey, for: Keys.GoogleSpeechToTextAPIKey)
        Defaults.shared.set(confidence, for: Keys.SpeechConfidence)
        Defaults.shared.set(showKeywords, for: Keys.ShowKeywords)

        let langId = Keys.AvailableLanguages.keysForValue(value: languageName).first!
        Defaults.shared.set(langId, for: Keys.Language)

        self.dismiss(animated: true, completion: nil)
    }
}
