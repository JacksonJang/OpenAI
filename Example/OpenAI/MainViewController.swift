import UIKit
import OpenAI

class MainViewController: BaseViewController {
    var items: [String] = [
        "Generate Image"
    ]
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    private func setupProperties() {
        tableView.register(MainViewCell.self,
                           forCellReuseIdentifier: MainViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getViewController<T>(name:T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController: T = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        
        return viewController
    }
    
    public func push(vc:UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewCell.identifier, for: indexPath) as! MainViewCell
        let index = indexPath.row
        let item = items[index]
        
        cell.configuration(item:item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            let vc = getViewController(name: ImageViewController.self)
            self.push(vc: vc)
        default:
            fatalError("You need to set ViewController")
        }
    }
}

class MainViewCell: UITableViewCell {
    static let identifier = String(describing: MainViewCell.self)
    
    let titleLabel:UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupUI()
    }
    
    public func configuration(item:String) {
        titleLabel.text = item
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
