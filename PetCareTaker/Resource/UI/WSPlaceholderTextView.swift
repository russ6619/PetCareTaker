import UIKit

class WSPlaceholderTextView: UITextView {
    // 佔位文字
    var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 佔位文字顏色
    var placeholderColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 初始化
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // 設置預設字型
        self.font = UIFont.systemFont(ofSize: 15)
        
        // 使用通知監聽文字改變
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 移除通知監聽
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 文字改變通知的處理方法
    @objc func textDidChange(_ notification: Notification) {
        setNeedsDisplay()
    }
    
    // 重寫draw方法繪製佔位文字
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 如果有文字，就直接返回，不需要繪製佔位文字
        if !text.isEmpty || placeholder == nil {
            return
        }
        
        // 設置佔位文字屬性
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 15),
            .foregroundColor: placeholderColor
        ]
        
        // 繪製文字
        let x = textContainerInset.left + 5
        let y = textContainerInset.top
        let width = rect.width - textContainerInset.left - textContainerInset.right - 10
        let height = rect.height - textContainerInset.top - textContainerInset.bottom
        let placeholderRect = CGRect(x: x, y: y, width: width, height: height)
        
        placeholder?.draw(in: placeholderRect, withAttributes: attributes)
    }
    
    // 重寫setText方法
    override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
}

