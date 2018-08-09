//
//  AddKeywordViewController.swift
//  Subtitles
//
//  Created by Akram Hussein on 09/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit
import Eureka
import DefaultsKit
import ColorPickerRow

class AddKeywordViewController: FormViewController {

    var keyword: String?

    var keywordsAndColours: [String: [String: String]] {
        return Defaults.shared.get(for: Keys.KeywordsAndColours) ?? [String: [String: String]]()
    }

    var keywords: [String] {
        return Array(self.keywordsAndColours.keys)
    }

    var names: [String] {
        return self.keywordsAndColours.values.flatMap { $0["name"] }
    }

    init(keyword: String? = nil) {
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "AddKeyword.Title".localized

        self.navigationItem.leftBarButtonItem = .textBarButton("Done".localized, delegate: self, action: #selector(self.donePressed(_:)))
        self.navigationItem.rightBarButtonItem = .textBarButton("Save".localized, delegate: self, action: #selector(self.savePressed(_:)))

        self.form +++ Section("")

            <<< TextRow("name") { row in
                row.title = "AddKeyword.Row.Name".localized
                row.placeholder = "AddKeyword.Row.Name.Placeholder".localized

                if let kw = self.keyword, let name = self.keywordsAndColours[kw]!["name"] {
                    row.value = name.capitalizingFirstLetter
                }
            }

            <<< TextRow("keyword") { row in
                row.title = "AddKeyword.Row.Keyword".localized
                row.placeholder = "AddKeyword.Row.Keyword.Placeholder".localized
                row.value = self.keyword?.capitalizingFirstLetter
            }

            <<< ColorPickerRow("colour") { row in
                row.title = "AddKeyword.Row.Colour".localized
                row.isCircular = false
                row.showsCurrentSwatch = true
                row.showsPaletteNames = false

                if let kw = self.keyword, let colour = self.keywordsAndColours[kw]!["colour"] {
                    row.value = UIColor(rgba: colour)
                } else {
                    row.value = .black
                }
            }.cellSetup { cell, _ in
                cell.palettes = [Material().palette]
            }

        if self.keyword != nil {
            self.form +++ Section("")

                <<< ButtonRow("delete") { row in
                    row.title = "Delete".localized
                }.cellSetup { cell, _ in
                    cell.tintColor = .red
                }.onCellSelection { _, _ in
                    var keywordsAndColours = self.keywordsAndColours
                    keywordsAndColours.removeValue(forKey: self.keyword!)
                    Defaults.shared.set(keywordsAndColours, for: Keys.KeywordsAndColours)
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }

    @objc func donePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func savePressed(_ sender: Any) {
        guard let nameRow = self.form.rowBy(tag: "name") as? TextRow,
            let name = nameRow.value, !name.trim.isEmpty else {
            self.showAlert("AddKeyword.Row.Name.Error".localized, okTitle: "OK".localized)
            return
        }

        guard let keywordRow = self.form.rowBy(tag: "keyword") as? TextRow,
            let keyword = keywordRow.value, !keyword.trim.isEmpty else {
            self.showAlert("AddKeyword.Row.Keyword.Error".localized, okTitle: "OK".localized)
            return
        }

        guard let colourPickerRow = self.form.rowBy(tag: "colour") as? ColorPickerRow,
            let colour = colourPickerRow.cell.colorSpec(forColor: colourPickerRow.value)?.color, colour.hex != "#ffffff" else {
            self.showAlert("AddKeyword.Row.Colour.Error".localized, okTitle: "OK".localized)
            return
        }

        var keywordsAndColours = self.keywordsAndColours

        if self.keyword == nil {
            // Saving new
            if self.names.contains(name) {
                self.showAlert("AddKeyword.Row.Name.Duplicate".localized, okTitle: "OK".localized)
                return
            }

            if self.keywords.contains(keyword) {
                self.showAlert("AddKeyword.Row.Keyword.Duplicate".localized, okTitle: "OK".localized)
                return
            }
        } else {
            // Updating - delete old one
            keywordsAndColours.removeValue(forKey: self.keyword!)
        }

        keywordsAndColours[keyword.lowercased().trim] = ["name": name.trim.capitalizingFirstLetter, "colour": colour.hex]
        Defaults.shared.set(keywordsAndColours, for: Keys.KeywordsAndColours)

        self.navigationController?.popViewController(animated: true)
    }

}
