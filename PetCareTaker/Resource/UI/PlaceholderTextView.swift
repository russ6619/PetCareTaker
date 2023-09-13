import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    // 儲存佔位文字
    var placeholder: String = "請輸入您的寵物狀況或是注意事項" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // 儲存佔位文字的顏色
    var placeholderColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty && !placeholder.isEmpty {
            // 設置佔位文字的屬性
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.systemFont(ofSize: 15),
                .foregroundColor: placeholderColor
            ]
            
            // 計算佔位文字的位置
            let x = textContainerInset.left + 5
            let y = textContainerInset.top
            let width = rect.width - textContainerInset.left - textContainerInset.right - 10
            let height = rect.height - textContainerInset.top - textContainerInset.bottom
            let placeholderRect = CGRect(x: x, y: y, width: width, height: height)
            
            // 繪製佔位文字
            (placeholder as NSString).draw(in: placeholderRect, withAttributes: attributes)
        }
    }
    
    // 監聽文字改變事件
    func textViewDidChange(_ textView: UITextView) {
        setNeedsDisplay()
        
        // 檢查文字是否為空，如果不是空的，則隱藏站位文字
        if !text.isEmpty {
            hidePlaceholder()
        }
    }
    
    // Helper 方法，隱藏站位文字
    private func hidePlaceholder() {
        placeholder = ""
        placeholderColor = .clear // 將佔位文字顏色設置為透明
        setNeedsDisplay()
    }

}
