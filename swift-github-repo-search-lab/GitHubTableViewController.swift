//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GitHubTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({
                
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        store.toggleStarStatus(for: store.repositories[indexPath.row]) { isStarred in
            if isStarred == true {
                let alert = UIAlertController.customAlertController(title: "Congrats!", message: "You just starred \(self.store.repositories[indexPath.row].fullName)")
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController.customAlertController(title: "Congrats!", message: "You just unstarred \(self.store.repositories[indexPath.row].fullName)")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func searchButton(_ sender: AnyObject) {
        let ac = UIAlertController(title: "Enter search item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) { [unowned self, ac](action: UIAlertAction!) in
            let answer = ac.textFields![0]
            self.store.getSearchedRepository(name: answer.text!, completion: {
                    print(self.store.repositories)
                    self.tableView.reloadData()

            })
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

}


extension UIAlertController {
    class func customAlertController(title : String, message : String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in print("Youve pressed OK Button")
        }
        alertController.addAction(OKAction)
        return alertController
    }
}


