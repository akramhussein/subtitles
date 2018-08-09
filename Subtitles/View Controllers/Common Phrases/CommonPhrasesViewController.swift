//
//  CommonPhrasesViewController.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit
import Eureka
import DefaultsKit

class CommonPhrasesViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CommonPhrases.Title".localized

        self.navigationItem.leftBarButtonItem = .textBarButton("Done".localized, delegate: self, action: #selector(CommonPhrasesViewController.donePressed(_:)))
        self.navigationItem.rightBarButtonItem = .textBarButton("Save".localized, delegate: self, action: #selector(CommonPhrasesViewController.savePressed(_:)))

        let commonPhrases = Defaults.shared.get(for: Keys.CommonPhrases) ?? [String]()

        let section = MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                         footer: "CommonPhrases.Section.Footer".localized) {

            $0.addButtonProvider = { _ in
                ButtonRow {
                    $0.title = "CommonPhrases.Row.AddNewPhrase".localized
                }
            }

            $0.multivaluedRowToInsertAt = { _ in
                NameRow {
                    $0.placeholder = "CommonPhrases.Row.Phrase.Placeholder".localized
                }
            }

            // Example
            $0 <<< NameRow {
                $0.placeholder = "CommonPhrases.Row.Phrase.Example.Placeholder".localized
            }

            // Add existing common phrases
            for c in commonPhrases { $0 <<< NameRow { $0.value = c } }

        }
        section.tag = "values_section"

        self.form +++ section

    }

    // MARK: Actions

    @objc public func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc public func savePressed(_ sender: Any) {
        guard let section = self.form.sectionBy(tag: "values_section") as? MultivaluedSection else { return }
        let values = section.values().flatMap { $0 as? String }
        Defaults.shared.set(values, for: Keys.CommonPhrases)
        self.dismiss(animated: true, completion: nil)
    }
}
