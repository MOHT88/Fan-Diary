//
//  MainTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    
    
    var clubNames: Results<Club>!
    var ascendingSorting = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubNames = realm.objects(Club.self)
        
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubNames.isEmpty ? 0 : clubNames.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let club = clubNames[indexPath.row]

        cell.clubNameLabel.text = club.clubName
        cell.stadiumLocationLabel.text = club.location
        cell.stadiumNameLabel.text = club.stadium
        cell.stadiumImage.image = UIImage(data: club.imageData!)

        return cell
    }
    
    
    
// MARK: Table view Delegate
    
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
            let club = clubNames[indexPath.row]
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
