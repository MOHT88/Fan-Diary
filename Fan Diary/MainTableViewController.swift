//
//  MainTableViewController.swift
//  Fan Diary
//
//  Created by Сергей Иванов on 25.08.2022.
//

import UIKit

class MainTableViewController: UITableViewController {

    let stadiums = ["ЦСКА", "Спартак", "Арсенал", "Локомотив", "Динамо", "Рубин"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stadiums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = stadiums[indexPath.row]
        content.image = UIImage(named: stadiums[indexPath.row])
        content.imageProperties.maximumSize.width = 40
        
        cell.contentConfiguration = content
        
        
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
