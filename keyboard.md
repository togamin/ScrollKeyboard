## 【Swift4】キーボード表示時、TextFieldが隠れないようにViewをスクロールする方法



<h2>今回作成するサンプルアプリ</h2>

以下が今回作成するアプリです。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">【iOSアプリ開発】<br><br>キーボードを表示したときに、テキストフィールドが隠れないようにする機能 <a href="https://t.co/FkDsMXFVOM">pic.twitter.com/FkDsMXFVOM</a></p>&mdash; とがみん@ブロガーinセブエンジニア (@togaminnnn) <a href="https://twitter.com/togaminnnn/status/1069782025928826880?ref_src=twsrc%5Etfw">2018年12月4日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



`TextField`をタッチすると同時に、キーボードが表示されます。この時、キーボードに`TextField`が隠れないように、画面も一緒に動くようになっています。

このサンプルアプリの実装方法について紹介していきます。

<h2>実装方法</h2>

<h3>キーボードが表示された時に、TextFieldの位置を移動する方法</h3>

キーボードが表示された時に、`TextField`の位置を移動させるためにする事は以下の2つです。

<ol><li>スクロールビューの配置</li><li>キーボードが表示される時にスクロールビューを動かし、閉じる時にスクロールビューを元に戻す処理</li></ol>

<h4>スクロールビューの配置</h4>

スクロールビューのデータを入れるための変数を`ViewController`クラスの中に宣言します。

```swift
var scrollView:UIScrollView!
```

そして、`viewDidLoad()`でインスタンス化します。

```swift
// UIScrollViewをインスタンス化
scrollView = UIScrollView()
```

`scrollView`のサイズ指定のため、デバイスの画面サイズを取得します。

```swift
//スクリーンのサイズを入れる変数を宣言
var screenWidth:CGFloat!
var screenHeight:CGFloat!

//スクリーンのサイズ取得
screenWidth = UIScreen.main.bounds.size.width
screenHeight = UIScreen.main.bounds.size.height
```

`scrollView`のサイズと位置を指定します。デバイスのサイズと同じサイズにしています。

```swift
// UIScrollViewのサイズと位置を設定
scrollView.frame = CGRect(x:0,y:0,width: screenWidth, height: screenHeight)
```

このスクロールビューに`TextField`を乗せる処理を記述します。

```swift
//スクロールビューにtextFieldを追加する処理
//表示位置とTextFieldのサイズを指定
textField.frame = CGRect(x: 20, y: screenHeight - 100, width: screenWidth - 40, height: 40)

//TextFieldをスクロールビューに追加
scrollView.addSubview(textField)
```

次に、スクロールビューの中に入れるコンテンツの大きさを指定し、`view`に追加します。キーボードが表示されていない時は、画面がスクロールされないようにするために、コンテンツのサイズは画面のサイズと同じに設定しています。

```swift
// UIScrollViewのコンテンツのサイズを指定
scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
// ビューに追加
self.view.addSubview(scrollView)
```

これで、`TextField`の乗った、スクロールViewが、追加されます。`height`を画面の高さ以上の大きさにすると、Viewをスクロールする事ができるようになっています。

<h4>キーボードが表示される時にスクロールビューを動かす処理と閉じる際に戻す処理</h4>

`viewWillAppear`関数を追加し、以下のコードを記述します。

```swift
override func viewWillAppear(_ animated: Bool) {
 	super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(notification:)),name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(notification:)),name:UIResponder.keyboardWillHideNotification,object: nil)
}


override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       		NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
}
```

`NotificationCenter`はある動作があった時に、別の動作を実行させるような機能です。このコードは、キーボードが表示される時に、`keyboardWillShow(notification:)`関数が呼び出され、キーボードが閉じる時に、`keyboardWillHide(notification:)`が呼ばれます。

それらの関数を、記述します。

`extension`を活用して、キーボードの処理をまとめていきます。

```swift
//キーボード関連の関数をまとめる。
extension ViewController{
	//キーボードが表示された時に呼ばれる
	@objc func keyboardWillShow(notification: NSNotification) {
 		//キーボードが押された時に伸ばすコンテンツのサイズ
        let insertHeight:CGFloat = 250
        //スクロールビューのなかのコンテンツのサイズを指定
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight + insertHeight)
        let offset = CGPoint(x: 0, y: insertHeight)
        //offsetで指定した分スクロールする
        scrollView.setContentOffset(offset, animated: true)
	}
	//キーボードが閉じる時に呼ばれる
	@objc func keyboardWillHide(notification: NSNotification) {
   		//スクロールビューのなかのコンテンツのサイズを元の大きさへ戻す
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
	}
}
```

キーボードが呼ばれた時に、スクロールビューを少しずらし、閉じる時に、元に戻します。

**参考サイト**

<a href = "https://qiita.com/ika_tarou/items/af67ede61f56eccff9a4">＞NotificationCenter基礎の基礎</a>

<a href = "https://hacknote.jp/archives/7958/">＞TextViewをキーボードに隠されず、高さが動的に変わるようにする</a>



これで実行すると、キーボードが表示される時と、表示された後にスクロールビューが動き、`TextField`が隠れずにしっかり入力することができます。



<h3>キーボードを戻す機能</h3>

まずキーボードを戻す機能についてです。以下の3つについて紹介していきます

<ol><li>Doneボタンを追加し、それを押すとキーボードをしまう機能</li><li>キーボード以外をタッチする事で、キーボードをしまう機能</li><li>確定キーを押す事で、キーボードをしまう機能</li></ol>

<h4>Doneボタンを追加し、それを押すとキーボードをしまう機能</h4>

以下のコードをキーボードの処理をまとめた`extension`クラスの内側に記述します。

```swift
extension ViewController{
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
```

これを記述後、`viewDidLoad`内に`keyBoardDone()`を記入します。

実行すると、キーボードに「Done」ボタンが追加されており、それを押すとキーボードが閉じます。

<h4>キーボード以外をタッチする事で、キーボードをしまう機能</h4>

以下のコードを追加します。スクロールViewがタップされた時に呼び出されます。

```swift
//UIScrollViewの拡張
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        print("touchesBegan")
    }
}
```

<a href = "https://qiita.com/shu26/items/b4985f6479e0276a4d17">＞【Swift】UIScrollViewがタッチできない時の対処法</a>

上記を記述することによって、キーボード表示時、画面をタップすることによってキーボードを閉じることができます。

<h4>確定キーを押す事で、キーボードをしまう機能</h4>

`TextField`入力後、確定キーを押すことで、キーボードを閉じるには以下のように書きます。

```swift
//デリゲートを追加
UITextFieldDelegate
```

```swift
//ViewDidLoadに以下を追加
textField.delegate = self
```

```swift
//リターンキーを押した時に、
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 	textField.resignFirstResponder()
  	return true
}
```

これで、キーボードの確定ボタンを押した時に、キーボードが閉じるようになります。
