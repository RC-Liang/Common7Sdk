//
//  CFSheetView.swift
//  
//  统一样式  类似系统 ActionSheetView

import UIKit
import RxSwift
import RxCocoa

public extension PccSheetView {
    
    enum actionStyle {
        
        case `default` // == black
        case black     // 黑色文字 "333333"
        case gray      // 灰色文字 "666666"
        case lightGray // 灰色文字 "999999"
        case cancel    // 取消
    }
}

public class PccSheetView: SheetAnimateView {

    struct SheetConstants {
        static let marginVertical: CGFloat = 6    // 垂直 上下边距 = 6
        static let marginHorizontal: CGFloat = 20 // 水平 左右边距 = 20
        static let wordSpacing: CGFloat = 2       // 标题和内容间距 = 2
        static let spacing: CGFloat = 10          // 按钮间距 = 10
        static let lineHeight: CGFloat = 1      // 线高
        static let buttonHeight: CGFloat = 55     // 按钮高度
    }

    var buttonsArray: [Dictionary <String, Any>] = []  // 配置 点击按钮 的数组
    
    override init() {
        super.init()
        
        delegate = self
        isClickBack = false
    }
    
    public convenience init(title: String?, message: String?) {
       
        self.init()

        titleLabel.text = title
        messageLabel.text = message
        updateLayoutMessage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 标题
    open var title: String? {
        didSet {
            titleLabel.text = title
            updateLayoutMessage()
        }
    }

    // 内容
    open var message: String? {
        didSet {
            messageLabel.text = message
            updateLayoutMessage()
        }
    }
    
    // MARK: 更新messageLabel 的位置
    private func updateLayoutMessage() {
        
        let messageSpacing: CGFloat = titleLabel.text?.count ?? 0 > 0 ? SheetConstants.wordSpacing : 0

        messageLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(messageSpacing)
        }
        
        // 有标题
        // if titleLabel.text?.count ?? 0 <= 0 && messageLabel.text?.count ?? 0 <= 0  {
        //     titleLabel.text = "title 和 message 不能同时为空"
        // }
    }

    // MARK: 配置按钮  代码顺序决定 显示位置
    
    public func config(action title: String, style: PccSheetView.actionStyle = .default, handler: (() -> Void)? = nil) {
        
        var color = UIColor.hexColor("333333")
        switch style {
        case .black:
            color = UIColor.hexColor("333333")
        case .gray:
            color = UIColor.hexColor("666666")
        case .lightGray:
            color = UIColor.hexColor("999999")
        default:
            color = UIColor.hexColor("333333")
        }
        
        // 取消按钮
        if style == .cancel {
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.hexColor("F5F6FA")
            contentView.addSubview(lineView)
            
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            _ = button.rx.tap.subscribe(onNext: { [weak self] in
                self?.hide()
                guard let handler = handler else {
                    return
                }
                handler()
            })
            contentView.addSubview(button)
            
            let bottomView = UIView()
            bottomView.backgroundColor = UIColor.hexColor("F5F6FA")
            contentView.addSubview(bottomView)
            
            let obj = ["line": lineView, "button": button, "bottom": bottomView] as [String : Any]
            buttonsArray.append(obj)
        
            // 其他按钮
        } else {
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(white: 0, alpha: 0.05)
            contentView.addSubview(lineView)
            
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            _ = button.rx.tap.subscribe(onNext: { [weak self] in
                self?.hide()
                guard let handler = handler else {
                    return
                }
                handler()
            })
            contentView.addSubview(button)
            
            let obj = ["line": lineView, "button": button] as [String : Any]
            buttonsArray.append(obj)
        }
    }
    
    public override func show(in viewController: UIViewController? = nil) {

        updateLayoutContent()
        
        var lastView: UIView = messageLabel
        
        for (i, params) in buttonsArray.enumerated() {
    
            // 其他按钮
            if params["bottom"] == nil {
                
                guard let lineView: UIView = params["line"] as? UIView,
                        let button: UIButton = params["button"] as? UIButton else {
                    return
                }
                
                var offsetY = lastView == messageLabel ? SheetConstants.marginVertical : 0
                if i == 0 && titleLabel.text?.count ?? 0 <= 0 && messageLabel.text?.count ?? 0 <= 0  {
                    offsetY = 0
                    lineView.isHidden = true
                }
                lineView.snp.makeConstraints { make in
                    make.top.equalTo(lastView.snp.bottom).offset(offsetY)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(SheetConstants.lineHeight)
                }
                
                button.snp.makeConstraints { make in
                    make.top.equalTo(lineView.snp.bottom)
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(SheetConstants.buttonHeight)
                }
                
                lastView = button
                
            } else {  // 取消
                guard let lineView: UIView = params["line"] as? UIView,
                    let button: UIButton = params["button"] as? UIButton,
                    let bottomView: UIView = params["bottom"] as? UIView else {
                    return
                }
                
                lineView.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(SheetConstants.spacing)
                    make.bottom.equalTo(button.snp.top)
                }
                
                button.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(SheetConstants.buttonHeight)
                    make.bottom.equalTo(bottomView.snp.top)
                }
                
                bottomView.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                    make.height.equalTo(UIKitCommon.safeBottom)
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        super.show(in: viewController)
    }
    
    // MARK: 根据文字计算高度 contentView
    private func updateLayoutContent() {

        let width: CGFloat = UIKitCommon.screenWidth

        let titleHeight = titleLabel.text?.height(constrained: width - 2 * SheetConstants.marginHorizontal, font: titleLabel.font) ?? 0
        let messageHeight = messageLabel.text?.height(constrained: width - 2 * SheetConstants.marginHorizontal, font: messageLabel.font) ?? 0

        // 文字高度 向上取整 不然可能显示不全
        var titleMessageHeight = ceil(titleHeight + messageHeight)
        if titleLabel.text?.count ?? 0 <= 0 && messageLabel.text?.count ?? 0 <= 0  {
            titleMessageHeight = 0
        }

        var height = SheetConstants.marginVertical * 2

        if titleHeight > 0 && messageHeight > 0 {
            height = height + CGFloat(titleMessageHeight) + SheetConstants.wordSpacing
        } else {
            height = height + CGFloat(titleMessageHeight)
        }

        // 按钮高度
        height = height + CGFloat((buttonsArray.count - 1)) * (SheetConstants.buttonHeight + SheetConstants.lineHeight)
        
        // 取消  底部高度
        height = height + SheetConstants.buttonHeight +  SheetConstants.spacing + UIKitCommon.safeBottom

        contentView.frame = CGRect(x: 0, y: 0, width: UIKitCommon.screenWidth, height: height)
    }
    
    // MARK: setter/getter
    fileprivate lazy var contentView: UIView = {
        let tmpView = UIView()
        tmpView.frame = CGRect(x: 0, y: 0, width: UIKitCommon.screenWidth, height: 0)
        return tmpView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#333333")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(SheetConstants.marginHorizontal)
            make.right.equalTo(-SheetConstants.marginHorizontal)
            make.top.equalTo(SheetConstants.marginVertical)
        }
        return label
    }()
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#999999")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(SheetConstants.marginHorizontal)
            make.right.equalTo(-SheetConstants.marginHorizontal)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        return label
    }()
}

extension PccSheetView: SheetAnimateViewDelegate {
    
    public func sheetContentView(_ sheetView: SheetAnimateView) -> UIView {
        return contentView
    }
}

