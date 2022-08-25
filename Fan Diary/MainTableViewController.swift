//
//  MainTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import UIKit

class MainTableViewController: UITableViewController {


    
    let clubNames = Club.getClubs()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
//        var content = cell.defaultContentConfiguration()
//        content.text = clubs[indexPath.row]
//        content.image = UIImage(named: clubs[indexPath.row])
//        content.imageProperties.maximumSize.width = 40
//
//        cell.contentConfiguration = content
        
        cell.clubNameLabel.text = clubNames[indexPath.row].clubName
        cell.stadiumImage.image = UIImage(named: clubNames[indexPath.row].image)
        cell.stadiumLocationLabel.text = clubNames[indexPath.row].location
        cell.stadiumNameLabel.text = clubNames[indexPath.row].stadium
        
        return cell
    }
    
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    
    
}
