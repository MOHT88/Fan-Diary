//
//  MainTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {


    
    var clubNames: Results<Club>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clubNames = realm.objects(Club.self)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubNames.isEmpty ? 0 : clubNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let club = clubNames[indexPath.row]

        cell.clubNameLabel.text = club.clubName
        cell.stadiumLocationLabel.text = club.location
        cell.stadiumNameLabel.text = club.stadium
        cell.stadiumImage.image = UIImage(data: club.imageData!)

        return cell
    }

    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newClubVC = segue.source as? NewClubTableViewController else { return }
        newClubVC.saveNewClub()
        tableView.reloadData()
        
    }
    
    
}
