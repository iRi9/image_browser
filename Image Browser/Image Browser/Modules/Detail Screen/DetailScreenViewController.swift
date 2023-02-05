//
//  DetailViewController.swift
//  Image Browser
//
//  Created by Giri Bahari on 04/02/23.
//

import UIKit

class DetailScreenViewController: UIViewController {

    var imageId: Int?
    private var isLoading = false
    private lazy var viewModel: DetailScreenViewModel = {
        DetailScreenViewModel()
    }()
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Detail"

        setupNavigationBar()
        setupTableView()
        setupViewModel()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addComment))
    }

    @objc
    private func addComment() {
        guard !isLoading else { return }
        viewModel.addComment(imageId: imageId!)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTableViewCell.nib, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.register(DetailHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailHeaderView.identifier)
    }

    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchDetailComment(imageId: imageId!)
    }
}

// MARK: Tableview -
extension DetailScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCell()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath) as? CommentTableViewCell else {
            fatalError("CommentTableViewCell not found")
        }
        let detailModel = viewModel.getDetail()
        let detailCommentModel = detailModel?.comments
        cell.bind(with: detailCommentModel![indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: DetailHeaderView.identifier) as? DetailHeaderView else {
            fatalError("DetailHeaderView not found")
        }
        if let detailModel = viewModel.getDetail() {
            headerCell.bind(with: detailModel.imageUrl)
        }
        return headerCell
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            guard let detailModel = self.viewModel.getDetail(),
                  let comments = detailModel.comments else {
                return
            }
            self.viewModel.deleteComment(by: comments[indexPath.row].id, on: self.imageId!)
            complete(true)
        }

        deleteAction.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Viewmodel delegate -
extension DetailScreenViewController: ViewModelDelegate {
    func onLoading(status: Bool) {
        isLoading = status
    }

    func showError(message: String) {
        // TODO: handle
    }

    func reloadView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
