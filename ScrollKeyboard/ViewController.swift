//
//  ViewController.swift
//  ScrollKeyboard
//
//  Created by Togami Yuki on 2018/11/17.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//
//キーボードが表示された時に、スクロールViewのサイズを大きくする。

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    //テキストフィールのインスタンス化
    let textField = UITextField()
    //スクロールビューのデータを入れるための変数
    var scrollView:UIScrollView!
    
    //スクリーンのサイズを入れる変数を宣言
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIScrollViewインスタンス生成
        scrollView = UIScrollView()
        
        //スクリーンのサイズ取得
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        // UIScrollViewのサイズと位置を設定
        scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
        
        //スクロールビューにtextFieldを追加する処理
        textField.backgroundColor = .white
        textField.frame = CGRect(x: 20, y: screenHeight - 100, width: screenWidth - 40, height: 40)
        scrollView.addSubview(textField)
        
        // UIScrollViewのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        // ビューに追加
        self.view.addSubview(scrollView)
                //キーボードDone機能
        keyBoardDone()
        textField.delegate = self
    }
    //画面が現れる時に表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(notification:)),name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(notification:)),name:UIResponder.keyboardWillHideNotification,object: nil)
    }
    //画面が消える時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
    }
}

//UIScrollViewの拡張
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        print("touchesBegan")
    }
}


//キーボード関連の関数をまとめる。
extension ViewController{
    
    //キーボードが表示された時に呼ばれる
    @objc func keyboardWillShow(notification: NSNotification) {
        let insertHeight:CGFloat = 250
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight + insertHeight)
        let offset = CGPoint(x: 0, y: insertHeight)
        scrollView.setContentOffset(offset, animated: true)
        print("スクリーンのサイズをキーボードの高さ分伸ばし伸ばした分動かす。")
    }
    //キーボードが閉じる時に呼ばれる
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        print("元の大きさへ")
    }
    
    //リターンキーを押した時に、
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //キーボードに「Done」ボタンを追加
    func keyBoardDone(){
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // Doneボタン。押された時に「closeKeybord」関数が呼ばれる。
        let commitButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done, target: self, action:#selector(self.closeKeybord(_:)))
        kbToolBar.items = [spacer, commitButton]
        self.textField.inputAccessoryView = kbToolBar
    }
    @objc func closeKeybord(_ sender:Any){
        self.view.endEditing(true)
    }
}
