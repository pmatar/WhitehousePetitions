//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Paul Matar on 01/06/2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPetitions()
        filteredPetitions = petitions
        navigationItem.title = navigationController?.tabBarItem.tag == 0
        ? "Most recent" : "Top rated"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPetitions))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = petition.title
        content.secondaryText = petition.body
        content.prefersSideBySideTextAndSecondaryText = true
        content.textProperties.font = UIFont(name: "Times New Roman", size: 23)!
        content.secondaryTextProperties.numberOfLines = 2
        content.textToSecondaryTextVerticalPadding = 8
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchPetitions() {
        let strURL = navigationController?.tabBarItem.tag == 0
        ? Links.sampleURL : Links.topSampleURL
        
        guard let url = URL(string: strURL) else {
            print("bad url")
            return
        }
        
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
        } else {
            showError()
        }
    }
    
    private func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let petitions = try? decoder.decode(Petitions.self, from: json) {
            self.petitions = petitions.results
            tableView.reloadData()
        }
    }
    
    @objc private func showCredits() {
        let ac = UIAlertController(
            title: "Credits:",
            message: "We The People API of the Whitehouse",
            preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func searchPetitions() {
        let ac = UIAlertController(
            title: "Search",
            message: "We The People API of the Whitehouse",
            preferredStyle: .alert)
        ac.addTextField { tf in
            tf.placeholder = "search..."
        }
        
        let action = UIAlertAction(title: "Search", style: .default) { [weak self] _ in
            guard let text = ac.textFields?.first?.text else { return }
            guard let tempPetitions = self?.petitions.filter({ petition in
                petition.title.contains(text) || petition.body.contains(text)
            }) else { return }
            self?.filteredPetitions = tempPetitions
            self?.tableView.reloadData()
        }
        
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
}

