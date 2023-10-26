//
//  SettingVC.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/8/31.
//

import UIKit
import MessageUI
import SafariServices



/// View Controller to show user settings
final class SettingVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    let userID: String = String(UserDataManager.shared.userData["UserID"] as! Int)
    let privacyUrl = ServerApiHelper.shared.privacyUrl
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        let section = [
            SettingCellModel(title: "登出", style: .default) { [weak self] in
                self?.didTapLogOut()
            },
            SettingCellModel(title: "刪除帳號", style: .destructive) { [weak self] in
                self?.didTapDeleteAccount()
            },
            SettingCellModel(title: "意見回饋", style: .default) { [weak self] in
                self?.didTapFeedback()
            }
        ]
        data.append(section)
        
        let privacyPolicy = SettingCellModel(title: "隱私權申明", style: .default) { [weak self] in
            self?.openPrivacyPolicy()
        }
        data[0].append(privacyPolicy)

    }

    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "登出",
                                            message: "您確定要登出嗎？",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "登出", style: .destructive, handler: { _ in
            AuthManager.shared.logOut { success in
                if success {
                    // 登出成功，切換到登入畫面
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                        print("跳轉到 LoginVC")
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                                window.rootViewController = loginVC
                            } else {
                                // 如果沒有窗口，創建一個新的窗口
                                let newWindow = UIWindow(windowScene: windowScene)
                                newWindow.rootViewController = loginVC
                                newWindow.makeKeyAndVisible()
                            }
                        }
                        
                    }
                } else {
                    // 登出失敗
                    fatalError("Could not log out user")
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
    
    private func didTapDeleteAccount() {
        let actionSheet = UIAlertController(title: "刪除帳號",
                                            message: "您確定要刪除帳號嗎？",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "刪除", style: .destructive, handler: { [weak self] _ in
            // 在這裡處理刪除帳號的邏輯
            // 首先執行登出操作，然後再執行刪除帳號的操作
            AuthManager.shared.logOut { success in
                if success {
                    // 登出成功後執行刪除帳號的操作
                    let apiUrl = "\(ServerApiHelper.shared.deleteUserUrl)?UserID=\(self!.userID)" // 替換成您的用戶ID
                    
                    if let url = URL(string: apiUrl) {
                        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if let error = error {
                                // 處理錯誤
                                print("刪除帳號失敗：\(error.localizedDescription)")
                            } else if let data = data {
                                // 解析 API 響應，您可以根據後端 API 的設計來處理響應
                                
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                    if let success = json?["success"] as? Bool, success {
                                        // 刪除成功，您可以執行相應操作，例如返回登入畫面
                                        DispatchQueue.main.async {
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                                if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                                                    window.rootViewController = loginVC
                                                } else {
                                                    let newWindow = UIWindow(windowScene: windowScene)
                                                    newWindow.rootViewController = loginVC
                                                    newWindow.makeKeyAndVisible()
                                                }
                                            }
                                        }
                                    } else if let message = json?["message"] as? String {
                                        // 刪除失敗，顯示錯誤消息
                                        print("刪除帳號失敗：\(message)")
                                    }
                                } catch {
                                    print("刪除帳號JSON 解析失敗：\(error.localizedDescription)")
                                }
                            }
                        }
                        task.resume()
                    }
                } else {
                    // 登出失敗
                    fatalError("Could not log out user")
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }


    private func didTapFeedback() {
        let actionSheet = UIAlertController(title: "意見回饋",
                                            message: "請選擇回饋方式",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "寄信給我", style: .default, handler: { [weak self] _ in
            self?.sendEmail()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "複製我的信箱", style: .default, handler: { [weak self] _ in
            // 在這裡處理複製你的信箱到剪貼板的邏輯
            let email = "russ855011@gmail.com"
            UIPasteboard.general.string = email
            // 顯示提示或其他操作
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
        
    }

    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let email = "russ855011@gmail.com"
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients([email]) // 設定收件人信箱
            mailComposeViewController.setSubject("意見回饋") // 設定郵件主題
            mailComposeViewController.setMessageBody("", isHTML: false) // 設定郵件內容
            
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            // 無法發送郵件，可能是郵件設定不正確或未設定郵件帳號
            let alertController = UIAlertController(title: "無法發送郵件",
                                                    message: "請檢查您的郵件設定或設定一個郵件帳號以發送郵件。",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: privacyUrl) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }


    
}

// MARK: tableview
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let setting = data[indexPath.section][indexPath.row]
        cell.textLabel?.text = setting.title
        cell.textLabel?.textColor = setting.style == .destructive ? .red : .black // 設定文字顏色
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
}
