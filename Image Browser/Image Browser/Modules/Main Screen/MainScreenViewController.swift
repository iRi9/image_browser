//
//  MainScreenViewController.swift
//  Image Browser
//
//  Created by Giri Bahari on 02/02/23.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var pageNumber = 0
    private var isLoading = false
    private lazy var viewModel: MainScreenViewModel = {
        MainScreenViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image List"
        tableView.register(ListImageTableViewCell.nib,
                           forCellReuseIdentifier: ListImageTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self

        pageNumber += 1
        viewModel.fetchImages(page: pageNumber)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailScreenViewController.identifier {
            guard let detailVC = segue.destination as? DetailScreenViewController,
                  let mainScreenModel = sender as? MainScreenModel else {
                return
            }
            detailVC.imageId = Int(mainScreenModel.id)
        }
    }
}

// MARK: Tableview delegate -
extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCell()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListImageTableViewCell.identifier, for: indexPath) as? ListImageTableViewCell else {
            fatalError("ListImageTableViewCell not found")
        }
        cell.bind(with: viewModel.getImageCell(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: DetailScreenViewController.identifier,
                     sender: viewModel.getImageCell(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNumberOfCell() - 1 && !isLoading {
            pageNumber += 1
            viewModel.fetchImages(page: pageNumber)
        }
    }
}

// MARK: ViewModel delegate -
extension MainScreenViewController: ViewModelDelegate {
    func onLoading(status: Bool) {
        isLoading = status
    }

    func showError(message: String) {
        // TODO: handle
    }

    func reloadView() {
        tableView.reloadData()
    }


}
