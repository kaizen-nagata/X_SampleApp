//
//  PostViewController.swift
//  X_SampleApp
//
//  Created by r.nagata on 2024/11/26.
//

import UIKit
import RealmSwift

protocol PostViewControllerDelegate {
    func postDataUpdate()
}

class PostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var inputUsernameField: UITextField!
    @IBOutlet weak var inputContentField: UITextView!

    var postData: PostDataModel?
    var delegate: PostViewControllerDelegate?
    
    var toolBar: UIToolbar {
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        let toolBar = UIToolbar(frame: toolBarRect)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([doneItem], animated: true)
        return toolBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let post = postData {
            inputUsernameField.text = post.username
            inputContentField.text = post.content
            postButton.setTitle("更新", for: .normal)
        } else {
            postButton.setTitle("ポスト", for: .normal)
        }

        configureUserNameTextField()
        configureContentTextField()
        configurePostButton()
        updatePostButtonState()
    }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }

    @IBAction func tappedCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func tappedSaveButton(_ sender: UIButton) {
        saveRecord()
    }

    func configurePostButton() {
        postButton.layer.cornerRadius = postButton.bounds.height / 2
    }

    func configureUserNameTextField() {
        inputUsernameField.inputAccessoryView = toolBar
        inputUsernameField.layer.borderColor = UIColor.systemGray4.cgColor
        inputUsernameField.delegate = self
    }

    func configureContentTextField() {
        inputContentField.inputAccessoryView = toolBar
        inputContentField.layer.borderColor = UIColor.systemGray4.cgColor
        inputContentField.layer.borderWidth = 0.5
        inputContentField.layer.cornerRadius = 5
        inputContentField.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        inputContentField.delegate = self
    }

    func saveRecord() {
        guard checkContentValidity() else {
            showAlert(title: "エラー", message: "コンテンツは1文字以上、140文字以下である必要があります。")
            return
        }

        let realm = try! Realm()
        let post = postData ?? PostDataModel()

        try! realm.write {
            if let username = inputUsernameField.text {
                post.username = username
            }
            if let content = inputContentField.text {
                post.content = content
            }
            post.timestamp = Date()
            realm.add(post)
        }
        delegate?.postDataUpdate()
        dismiss(animated: true)
    }

    func textViewDidChange(_ textView: UITextView) {
        updatePostButtonState()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        updatePostButtonState()
    }
    
    func checkUserNameValidity() -> Bool {
        let username = inputUsernameField.text ?? ""
        return !username.isEmpty
    }

    func checkContentValidity(_ text: String? = nil) -> Bool {
        let content = text ?? inputContentField.text ?? ""
        return content.count >= 1 && content.count <= 140
    }

    func updatePostButtonState() {
        let isUserNameValid = checkUserNameValidity()
        let isContentValid = checkContentValidity()
        postButton.isEnabled = isUserNameValid && isContentValid
        postButton.backgroundColor = isUserNameValid && isContentValid ? .systemBlue : .systemGray4
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

}
