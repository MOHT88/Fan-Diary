//
//  MainTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var clubNames: Results<Club>!
    private var filteredClubNames: Results<Club>!
    private var ascendingSorting = true
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clubNames = realm.objects(Club.self)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredClubNames.count
        }
        return clubNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let club = isFiltering ? filteredClubNames[indexPath.row] : clubNames[indexPath.row]
        
        cell.clubNameLabel.text = club.clubName
        cell.stadiumLocationLabel.text = club.location
        cell.stadiumNameLabel.text = club.stadium
        cell.stadiumImage.image = UIImage(data: club.imageData!)
        
        return cell
    }
    
    // MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let club = clubNames[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteObject(club)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let club = isFiltering ? filteredClubNames[indexPath.row] : clubNames[indexPath.row]
            let newClubVC = segue.destination as! NewClubTableViewController
            newClubVC.currentClub = club
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newClubVC = segue.source as? NewClubTableViewController else { return }
        newClubVC.saveClub()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0  {
            clubNames = clubNames.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            clubNames = clubNames.sorted(byKeyPath: "clubName", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filteredContentForSearchText(_ searchText: String) {
        filteredClubNames = clubNames.filter("clubName CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}
