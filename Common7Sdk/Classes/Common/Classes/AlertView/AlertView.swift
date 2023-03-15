//
//  AlertView.swift
//
//  系统的alert、actionSheet

import Foundation
import UIKit

extension AlertView {
    enum Status {
        case `default`
        case alert
        case sheet
    }
}

class AlertView: NSObject {
    convenience init(title: String?, message: String?, status: AlertView.Status) {
        self.init()

        let style: UIAlertController.Style = status == .sheet ? .actionSheet : .alert
        alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    }

    // 类型
    open var status: AlertView.Status = .default {
        didSet {
            let style: UIAlertController.Style = status == .sheet ? .actionSheet : .alert
            alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        }
    }

    // 标题
    open var title: String? {
        didSet {
            alertController?.title = title
        }
    }

    // 内容
    open var message: String? {
        didSet {
            alertController?.message = message
        }
    }

    // MARK: 配置按钮  代码顺序决定 显示位置

    open func config(text: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        let action = UIAlertAction(title: text, style: style) { _ in
            if handler != nil {
                handler!()
            }
        }
        alertController?.addAction(action)
    }

    // MARK: 配置输入框  只有alert 才有

    open func addTextField(handler: ((UITextField) -> Void)? = nil) {
        guard status != .sheet else {
            return
        }

        alertController?.addTextField(configurationHandler: { textField in
            if handler != nil {
                handler!(textField)
            }
        })
    }

    fileprivate var alertController: UIAlertController?

    open func show(in viewController: UIViewController? = nil) {
        guard let alert = alertController else {
            return
        }

        if viewController == nil {
            UIKitCommon.currentViewController()?.present(alert, animated: true, completion: nil)
        } else {
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
