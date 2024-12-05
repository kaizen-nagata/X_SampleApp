//
//  TimeLineViewController.swift
//  X_SampleApp
//
//  Created by r.nagata on 2024/11/26.
//

import UIKit
import RealmSwift

class TimeLineViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var posts: [PostDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureAddButton()
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        tableView.reloadData()
    }
 
    @IBAction func tappedAddButton(_ sender: UIButton) {
        transitionToPostView()
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }

    func configureTableView() {
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.allowsSelection = true
        tableView.separatorColor = .gray
        tableView.separatorStyle = .singleLine
        if #available(iOS 15.0, *) {
            tableView.fillerRowHeight = 80
        }
        // セルの高さを自動調整
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2
    }

    // ポスト作成画面遷移
    func transitionToPostView() {
        let storyboard = UIStoryboard(name: "PostViewController", bundle: nil)
        guard let postViewController = storyboard.instantiateInitialViewController() as? PostViewController else { return }
        postViewController.delegate = self
        present(postViewController, animated: true)
    }

    // 取得
    func getData() {
        let realm = try! Realm()
        posts = Array(realm.objects(PostDataModel.self).sorted(byKeyPath: "timestamp", ascending: false))
    }

    // 編集
    func editData(_ post: PostDataModel) {
        // 編集処理（例: 投稿を編集する画面に遷移）
        let storyboard = UIStoryboard(name: "PostViewController", bundle: nil)
        guard let postViewController = storyboard.instantiateInitialViewController() as? PostViewController else { return }
        postViewController.postData = post
        postViewController.delegate = self
        present(postViewController, animated: true)
    }

    // 削除
    func deleteData(_ post: PostDataModel, at indexPath: IndexPath) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(post)
        }

        // データソースを更新
        posts.remove(at: indexPath.row)

        // テーブルビューの行を削除
        getData()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // オプションアラート表示
    func showOptions(for cell: CustomTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]

        let alert = UIAlertController(title: "オプション", message: "投稿を編集または削除します", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "編集", style: .default, handler: { _ in
            self.editData(post)
        }))
        alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
            self.showDeleteConfirmationAlert(for: post, at: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showDeleteConfirmationAlert(for post: PostDataModel, at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "確認",
            message: "このポストを削除してもよろしいですか？",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { _ in
            self.deleteData(post, at: indexPath)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        present(alertController, animated: true)
    }
}

extension TimeLineViewController: UITableViewDataSource {
    // 件数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    // 高さ調整
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }
        let post = posts[indexPath.row]
        cell.usernameViewField.text = post.username
        cell.timestampViewField.text = dateFormatter.string(from: post.timestamp)
        cell.contentViewField.text = post.content
        cell.selectionStyle = .none
        
        return cell
    }
}

extension TimeLineViewController: PostViewControllerDelegate {
    func postDataUpdate() {
        getData()
        tableView.reloadData()
    }
}
