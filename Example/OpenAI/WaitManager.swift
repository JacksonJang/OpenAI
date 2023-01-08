import UIKit

class WaitManager: NSObject {
    static let shared = WaitManager()
    
    private lazy var view:UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        return view
    }()
    
    private let indicatorView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            view.style = .large
        }
        view.color = .white
        
        return view
    }()
    
    override init() {
        super.init()
        
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    /// Visible indicator
    public func start() {
        if let topView = UIApplication.shared.topViewController() {
            topView.view.addSubview(self.view)
            
            NSLayoutConstraint.activate([
                self.view.topAnchor.constraint(equalTo: topView.view.topAnchor),
                self.view.leadingAnchor.constraint(equalTo: topView.view.leadingAnchor),
                self.view.trailingAnchor.constraint(equalTo: topView.view.trailingAnchor),
                self.view.bottomAnchor.constraint(equalTo: topView.view.bottomAnchor)
            ])
            
            self.indicatorView.startAnimating()
        }
    }
    
    /// Invisible indicator
    public func stop() {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.removeFromSuperview()
        }, completion: { _ in
            self.indicatorView.stopAnimating()
        })
    }
}
