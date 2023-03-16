import RxCocoa
import RxSwift
import SnapKit
import UIKit

public enum SimSearchStatus: Equatable {
    /// 开始编辑
    case beginEditing
    /// 改变值
    case valueChange(String)
    /// 结束编辑
    case endEditing
}

public class SearchView: UIView {
    @IBInspectable var isMobileOn: Bool = false {
        didSet {
            mobileTextField.isHidden = !isMobileOn
            searchTextField.isHidden = isMobileOn
        }
    }

    public var searchEdge: UIEdgeInsets = .zero {
        didSet {
            topEdge.constant = searchEdge.top
            leftEdge.constant = searchEdge.left
            rightEdge.constant = searchEdge.right
            bottomEdge.constant = searchEdge.bottom
        }
    }

    @IBOutlet private var contentView: UIView!

    @IBOutlet var searchIcon: UIImageView!

    @IBOutlet var placeholderLabel: UILabel!
    // 普通搜索框
    @IBOutlet var searchTextField: UITextField!
    // 手机号搜索
    @IBOutlet var mobileTextField: MobileTextField!

    // edge 边缘
    @IBOutlet var topEdge: NSLayoutConstraint!
    @IBOutlet var leftEdge: NSLayoutConstraint!
    @IBOutlet var rightEdge: NSLayoutConstraint!
    @IBOutlet var bottomEdge: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    /// 搜索文本去除空格
    public var searchText: String {
        if isMobileOn {
            return mobileTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        }
        return searchTextField.text ?? ""
    }

    /// 搜索框输入变化
    public var searchTextObservable: Observable<String> {
        if isMobileOn {
            return mobileTextField.rx.text.orEmpty.asObservable()
        }
        return searchTextField.rx.text.orEmpty.asObservable()
    }

    public var searchReturnKey: (() -> Void)?

    public func returnKeyType(_ type: UIReturnKeyType) {
        searchTextField.returnKeyType = type
    }

    /// 编辑状态
    public var searchTextFieldStatusObservable = PublishSubject<SimSearchStatus>()

    /// 清除文本
    public func clearText() {
        searchTextField.text = ""
        mobileTextField.text = ""
        placeholderLabel.isHidden = false
    }

    /// 唤醒键盘
    public func beginSearch(delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.isMobileOn {
                self.mobileTextField.becomeFirstResponder()
            } else {
                self.searchTextField.becomeFirstResponder()
            }
        }
    }

    /// 设置默认文本
    /// - Parameter value: 值
    public func setDefaultValue(value: String?, placeholder: String? = "搜索") {
        placeholderLabel.text = placeholder

        if isMobileOn {
            mobileTextField.text = value
        } else {
            searchTextField.text = value
        }

        if value?.isEmpty == false {
            placeholderLabel.isHidden = true
            searchIconCenter(false)
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }

    private func loadViewFromNib() {
       
        let nib = UINib(nibName: String(describing: Self.self), bundle: UIKitCommon.resourceBundle(type: .components))
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = bounds
        addSubview(contentView)

        // 监听searchTextField状态
        searchTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.searchStatusChanged(.beginEditing)
            self.searchTextFieldStatusObservable.onNext(.beginEditing)
        }).disposed(by: disposeBag)

        searchTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.searchStatusChanged(.endEditing)
            self.searchTextFieldStatusObservable.onNext(.endEditing)
        }).disposed(by: disposeBag)

        searchTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            // 设置placeholder
            let textIsEmpty = self.searchTextField.text?.isEmpty ?? true
            self.placeholderLabel.isHidden = !textIsEmpty
            if let lastText = self.searchTextField.text?.last {
                self.searchTextFieldStatusObservable.onNext(.valueChange(String(lastText)))
            }
        }).disposed(by: disposeBag)

        searchTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            if let self = self, let searchReturnKey = self.searchReturnKey {
                searchReturnKey()
            }
        }).disposed(by: disposeBag)

        // 监听MobileTextField状态
        mobileTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.searchStatusChanged(.beginEditing)
            self.searchTextFieldStatusObservable.onNext(.beginEditing)
        }).disposed(by: disposeBag)

        mobileTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.searchStatusChanged(.endEditing)
            self.searchTextFieldStatusObservable.onNext(.endEditing)
        }).disposed(by: disposeBag)

        mobileTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            // 设置placeholder
            let textIsEmpty = self.mobileTextField.text?.isEmpty ?? true
            self.placeholderLabel.isHidden = !textIsEmpty
            if let lastText = self.mobileTextField.text?.last {
                self.searchTextFieldStatusObservable.onNext(.valueChange(String(lastText)))
            }
        }).disposed(by: disposeBag)
    }

    private func searchStatusChanged(_ status: SimSearchStatus) {
        if status == .beginEditing {
            searchIconCenter(false)
        } else {
            if isMobileOn {
                searchIconCenter(mobileTextField.text?.isEmpty ?? true)
            } else {
                searchIconCenter(searchTextField.text?.isEmpty ?? true)
            }
        }
    }

    private func searchIconCenter(_ isCenter: Bool) {
        UIView.animate(withDuration: 0.25) {
            // icon位置
            self.searchIcon.snp.remakeConstraints { make in
                make.height.width.equalTo(20)
                make.centerY.equalToSuperview()
                if !isCenter {
                    make.left.equalTo(10)
                }
            }
            self.searchIcon.superview?.layoutIfNeeded()
        }
    }
}
