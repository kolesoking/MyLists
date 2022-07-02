//
//  ViewController.swift
//  MyLists
//
//  Created by катя on 01.07.2022.
//

import UIKit

class ClientsListViewController: UITableViewController {
    
    private let cellID = "cell"
    private var clients: [Client] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ClientTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        
        setNavBar()
        fetchData()
        title = String(clients.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ClientTableViewCell
        let client = clients[indexPath.row]
        
        cell.nameLabel.text = client.name
        cell.cashLabel.text = client.cash
        
        return cell
    }
    
    @objc func addNewClient() {
        showAlert()
    }
    
    func save(clientName: String, clientCash: String) {
        StorageManager.shared.save(clientName, clientCash) { client in
            self.clients.append(client)
            self.tableView.insertRows(
                at: [IndexPath(row: self.clients.count - 1, section: 0)],
                with: .automatic)
        }
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let clients):
                self.clients = clients
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - TableViewDelegate
extension ClientsListViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let client = clients[indexPath.row]
        
        if editingStyle == .delete {
            clients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(client)
            self.navigationItem.title = "Hi " + "\(self.clients.count)"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let client = clients[indexPath.row]
        showAlert(client: client) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ClientsListViewController {
    
    private func showAlert(client: Client? = nil, comletion: (() -> Void)? = nil) {
        let title = client != nil ? "Update Client" : "New client"
        let alert = UIAlertController.createAlertController(title: title)
        
        alert.action(client: client) { clientName, clientCash in
            if let client = client, let comletion = comletion {
                StorageManager.shared.edit(client, name: clientName, cash: clientCash)
                comletion()
            } else {
                self.save(clientName: clientName, clientCash: clientCash)
                self.navigationItem.title = "Hi " + "\(self.clients.count)"
            }
        }
        
        present(alert, animated: true)
        
    }
}
