//
//  PetTabViewController.swift
//  PetCareTaker
//
//  Created by 李暠勳 on 2023/9/3.
//

import UIKit

class PetTabViewController: UIViewController {
    
    // ScrollView作為Tab Layout的容器
    private let tabScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = true
        // 設定 tabScrollView 的位置和大小
        scrollView.frame = CGRect(
            x: 0,
            y: 100,
            width: UIScreen.main.bounds.width,
            height: 40)
        scrollView.backgroundColor = UIColor.systemYellow
        return scrollView
    }()
    
    private let viewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        // 設定 viewScrollView 的位置和大小
        scrollView.frame = CGRect(
            x: 0,
            y: 140,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - 50)
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加 tabScrollView 和 viewScrollView 到主視圖
        view.addSubview(tabScrollView)
        view.addSubview(viewScrollView)
        
        // 設置寵物名稱，此為示例，您需要根據您的數據源動態生成
        let petNames = ["皮皮", "寵物2", "新增寵物"]
        var totalWidth: CGFloat = 0
        
        // 創建和設置Tab按鈕
        for petName in petNames {
            let button = UIButton()
            button.setTitle(petName, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1.0 // 外框線寬度
            button.layer.borderColor = UIColor.black.cgColor // 外框線顏色
            button.sizeToFit()
            let xPosition = totalWidth
            button.frame = CGRect(
                x: xPosition,
                y: 0,
                width: button.frame.width + 10,
                height: tabScrollView.frame.height)
            
            tabScrollView.addSubview(button)
            
            totalWidth += button.frame.width
        }
        
        tabScrollView.contentSize = CGSize(width: totalWidth, height: tabScrollView.frame.height)
        
        // 創建並添加 firstTabVC 的視圖到 viewScrollView
        let firstTabVC = FirstPetTabVC()
        firstTabVC.view.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 2000) // 設定高度為足夠大，以便可以垂直滾動
        viewScrollView.addSubview(firstTabVC.view)
        // 更新 viewScrollView 的 contentSize，以便支援垂直滾動
        viewScrollView.contentSize = CGSize(
            width: viewScrollView.frame.width,
            height: firstTabVC.view.frame.height)
        

        // 添加 FirstPetTabVC 的視圖到 viewScrollView
        viewScrollView.addSubview(firstTabVC.view)

    }
    
    
    
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        // 在這裡處理Tab按鈕被點擊的事件，例如顯示相應寵物的資訊
    }
    // 當使用者新增寵物時，動態添加一個新的Tab按鈕
    func addPetTabButton(petName: String) {
        let button = UIButton()
        button.setTitle(petName, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()
        
        // 計算位置
        let xPosition = tabScrollView.contentSize.width
        button.frame = CGRect(
            x: xPosition,
            y: 0,
            width: button.frame.width,
            height: tabScrollView.frame.height)
        
        // 添加到ScrollView
        tabScrollView.addSubview(button)
        
        // 更新ScrollView的contentSize
        tabScrollView.contentSize = CGSize(
            width: xPosition + button.frame.width,
            height: tabScrollView.frame.height)
    }
    
}
