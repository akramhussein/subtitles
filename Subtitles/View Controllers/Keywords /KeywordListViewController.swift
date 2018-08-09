//
//  KeywordViewController.swift
//  Subtitles
//
//  Created by Akram Hussein on 09/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit
import DefaultsKit

final class KeywordTableViewCell: UITableViewCell {}

class KeywordListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.backgroundColor = .white

            self.tableView.separatorStyle = .singleLine
            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            self.tableView.tableFooterView = UIView(frame: .zero)

            self.tableView.separatorInset = .zero
            self.tableView.layoutMargins = .zero

            self.tableView.register(KeywordTableViewCell.self, forCellReuseIdentifier: KeywordTableViewCell.className)
        }
    }

    var keywordsAndColours: [String: [String: String]] {
        return Defaults.shared.get(for: Keys.KeywordsAndColours) ?? [String: [String: String]]()
    }
    var keywords: [String] {
        return Array(self.keywordsAndColours.keys)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Keywords.Title".localized

        self.navigationItem.leftBarButtonItem = .textBarButton("Done".localized, delegate: self, action: #selector(donePressed(_:)))
        self.navigationItem.rightBarButtonItem = .textBarButton("Add".localized, delegate: self, action: #selector(addPressed(_:)))
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: Actions

    @objc public func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc public func addPressed(_ sender: Any) {
        self.navigationController?.pushViewController(AddKeywordViewController(), animated: true)
    }
}

extension KeywordListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywordsAndColours.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: KeywordTableViewCell.className)

        let keyword = self.keywords[indexPath.row]
        cell.detailTextLabel?.text = keyword.capitalizingFirstLetter // keyword

        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 26.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 22.0)

        if let name = self.keywordsAndColours[keyword]!["name"] {
            cell.textLabel?.text = name.capitalizingFirstLetter // name
        } else {
            cell.textLabel?.text = ""
        }

        if let colour = self.keywordsAndColours[keyword]!["colour"] {
            cell.detailTextLabel?.textColor = UIColor(rgba: colour)
        } else {
            cell.detailTextLabel?.textColor = .black
        }

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            let keyword = self.keywords[indexPath.row]
            var keywordsAndColours = self.keywordsAndColours
            keywordsAndColours.removeValue(forKey: keyword)
            Defaults.shared.set(keywordsAndColours, for: Keys.KeywordsAndColours)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
}

extension KeywordListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keyword = self.keywords[indexPath.row]
        self.navigationController?.pushViewController(AddKeywordViewController(keyword: keyword), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

}
