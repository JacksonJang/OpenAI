import UIKit

class ImageViewController: BaseViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
    }
    
    private func setupProperties() {
        textField.delegate = self
    }
    
    @IBAction func onTouchGenerate(_ sender: Any) {
        WaitManager.shared.start()
        OpenAI.makeImage(text: textField.text ?? "bird", size: ._256x256, completion: { [weak self] result in
            switch result {
            case .success(let model):
                let dic = model.data

                dic.forEach{
                    print("generated url : \($0.url)")
                    do {
                        if let url = URL(string: $0.url), let data = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                self?.imageView.image = UIImage(data: data)
                                WaitManager.shared.stop()
                            }
                        }
                    }
                }
            case .failure(let error):
                print("error : \(error.localizedDescription)")
            }
        })
    }
}

extension ImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
