//
//  CFAlertView.swift
//  
//  统一样式  类似系统 AlertView

import UIKit
import RxSwift
import RxCocoa

public extension PccAlertView {
    enum actionStyle {
        case `default`    // 默认确认按钮红色
        case cancel       // 取消按钮黑色
    }
}

public class PccAlertView: AlertAnimateView {
    
    struct AlertConstants {
        static let marginVertical: CGFloat = 29   // 垂直 上下边距 = 29
        static let marginHorizontal: CGFloat = 32 // 水平 左右边距 = 32
        static let spacing: CGFloat = 26          // 间距 = 26
        static let lineHeight: CGFloat = 0.5      // 线高
        static let buttonHeight: CGFloat = 55     // 按钮高度
    }

   
    
    let maxButtons: Int = 2            // 可配置点击按钮的个数
    var buttonsArray: [UIButton] = []  // 配置 点击按钮 的数组
    
    let disposeBag = DisposeBag()
    
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
        
        let messageSpacing: CGFloat = messageLabel.text?.count ?? 0 > 0 ? AlertConstants.spacing : 0

        messageLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(messageSpacing)
        }
        
        // 有标题
        if titleLabel.text?.count ?? 0 <= 0 && messageLabel.text?.count ?? 0 <= 0  {
            titleLabel.text = "title 和 message 不能同时为空"
        }
    }

    // MARK: 配置按钮  代码顺序决定 显示位置
    
    public func config(action title: String, style: PccAlertView.actionStyle = .default, handler: (() -> Void)? = nil) {
        
        // 最多可添加按钮的判断
        guard maxButtons >= buttonsArray.count else {
            return
        }
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        let color = style == .default ? UIKitCommon.ThemeColor : UIColor.hexColor("#333333", alpha: 0.8)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.rx.tap.subscribe { [weak self] event in
            if case .next() = event {
                self?.hide()
                
                guard let handler = handler else {
                    return
                }
                handler()
            }
        }.disposed(by: disposeBag)
        
        contentView.addSubview(button)
        buttonsArray.append(button)
    }
    
    public override func show(in viewController: UIViewController? = nil) {
        
        updateLayoutContent()
        
        // 只有一个按钮
        if buttonsArray.count == 1 {
            let button = buttonsArray.first
            button?.snp.updateConstraints({ make in
                make.top.equalTo(horizontalLineView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(AlertConstants.buttonHeight)
            })
            
        } else if buttonsArray.count == 2 { // 两个按钮
            let leftButton = buttonsArray.last
            leftButton?.snp.updateConstraints({ make in
                make.top.equalTo(horizontalLineView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalTo(verticalLineView.snp.left)
                make.bottom.equalToSuperview()
                make.height.equalTo(AlertConstants.buttonHeight)
            })
            
            let rightButton = buttonsArray.first
            rightButton?.snp.updateConstraints({ make in
                make.top.equalTo(horizontalLineView.snp.bottom)
                make.right.equalToSuperview()
                make.left.equalTo(verticalLineView.snp.right)
                make.bottom.equalToSuperview()
                make.height.equalTo(AlertConstants.buttonHeight)
            })
        }
        
        super.show(in: viewController)
    }
    
    // MARK: 根据文字计算高度 contentView
    private func updateLayoutContent() {
        
        let width: CGFloat = UIKitCommon.screenWidth - 56

        let titleHeight = titleLabel.text?.height(constrained: width - 2 * AlertConstants.marginHorizontal, font: titleLabel.font) ?? 0
        let messageHeight = messageLabel.text?.height(constrained: width - 2 * AlertConstants.marginHorizontal, font: messageLabel.font) ?? 0
        
        // 文字高度 向上取整 不然可能显示不全
        let titleMessageHeight = ceil(titleHeight + messageHeight)
        
        var height = AlertConstants.marginVertical * 2
        
        if titleHeight > 0 && messageHeight > 0 {
            height = height + CGFloat(titleMessageHeight) + AlertConstants.spacing
        } else {
            height = height + CGFloat(titleMessageHeight)
        }
        
        height = height + AlertConstants.lineHeight + AlertConstants.buttonHeight
        
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    // MARK: setter/getter
    fileprivate lazy var contentView: UIView = {
        let tmpView = UIView()
        let width: Int = Int(UIKitCommon.screenHeight - 56)
        tmpView.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        tmpView.backgroundColor = .white
        return tmpView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#333333", alpha: 0.9)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(AlertConstants.marginHorizontal)
            make.right.equalTo(-AlertConstants.marginHorizontal)
            make.top.equalTo(AlertConstants.marginVertical)
        }
        return label
    }()
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hexColor("#999999")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(AlertConstants.marginHorizontal)
            make.right.equalTo(-AlertConstants.marginHorizontal)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        return label
    }()
    
    fileprivate lazy var horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(AlertConstants.marginVertical)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        return view
    }()
    
    fileprivate lazy var verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(horizontalLineView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(0.5)
            make.centerX.equalToSuperview()
        }
        return view
    }()
    
}

extension PccAlertView: AlertAnimateViewDelegate {
    public func alertContentView(_ alertView: AlertAnimateView) -> UIView {
        return contentView
    }
}
