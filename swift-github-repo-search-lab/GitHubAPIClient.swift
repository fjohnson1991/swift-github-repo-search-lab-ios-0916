//
//  GitHubAPIClient.swift
//  swift-github-repo-search-lab
//
//  Created by Felicity Johnson on 10/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Alamofire

class GithubAPIClient {

    class func searchForRepo(name: String, completion: @escaping ([[String: Any]]) -> Void)  {

        let url = "\(Constants.githubAPIURL)/search/repositories?q=\(name)"
        print(url)
        
//        "\(Constants.githubAPIURL)/search/repositories?q=taboo"
        print("name inside searchrepo \(name)\n\n\n")
        Alamofire.request(url).responseJSON { (response) in
            let jsonData = response.result.value as! [String: Any]
            let items = jsonData["items"] as! [[String:Any]]
            completion(items)
        }
    }
    
    class func getRepositories(_ completion: @escaping ([[String:Any]]) -> ()) {
        let urlString = "\(Constants.githubAPIURL)/repositories?client_id=\(Constants.githubClientID)&client_secret=\(Constants.githubClientSecret)"
        
        Alamofire.request(urlString).responseJSON { (response) in
            let jsonData = response.result.value as! [[String: Any]]
            completion(jsonData)
        }
        
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> ()) {
        
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(Constants.access_token)"
        
        Alamofire.request(urlString, method: .put, encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response) in
            
            if response.response?.statusCode == 204 {
                completion(true)
            } else if response.response?.statusCode == 404 {
                completion(false)
            }
        }
    }
    
    class func starRepository(named: String, completion:@escaping () -> Void) {
        let urlString = "\(Constants.githubAPIURL)/user/starred/\(named)?access_token=\(Constants.access_token)"
        
        Alamofire.request(urlString, method: .put, encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response) in
            completion()
        }
    }
    
    class func unstarRepository(named: String, completion:@escaping () -> Void) {
        let urlString = "\(Constants.githubAPIURL)/user/starred/\(named)?access_token=\(Constants.access_token)"
        Alamofire.request(urlString, method: .delete, encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response) in
            completion()
        }
    }
}


