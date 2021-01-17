//
//  RecentlyPlayedViewController.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-07.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

class RecentlyPlayedViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel = RecentlyPlayedViewModel(title: "RECENTLY_PLAYED".localized)
    private let tableView = UITableView()
    
    // MARK: - Lifecyle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        title = viewModel.title
        
        getRecentlyPlayed()
    }
    
    // MARK: - Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.pinEdges(to: view)
        
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func getRecentlyPlayed() {
        viewModel.getRecentlyPlayed { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension RecentlyPlayedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = viewModel.items?[indexPath.row]
        let trackName = item?.track.name
        
        cell.textLabel?.text = trackName
        
        return cell
    }
}
