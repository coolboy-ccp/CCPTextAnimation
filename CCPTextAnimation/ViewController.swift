//
//  ViewController.swift
//  CCPTextAnimation
//
//  Created by 储诚鹏 on 2019/1/30.
//  Copyright © 2019 储诚鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GradientText.animation(in: self.view, origin: CGPoint(x: 10, y: 100), text: "这是一个测试字符串")
        GradientText.animation(in: self.view, origin: CGPoint(x: 10, y: 180), text: Date())
        let data = "我是一个转化成data的字符串".data(using: .utf8)
        GradientText.animation(in: self.view, origin: CGPoint(x: 10, y: 260), text: data ?? "data为空")
        GradientText.animation(in: self.view, origin: CGPoint(x: 10, y: 320), texts: ["第一行", "第二行", "第三行"])
        
    }


}

