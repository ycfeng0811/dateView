//
//  HomeVC.swift
//  DatePicker
//
//  Created by YCFeng on 2021/7/8.
//

import Foundation
import URLNavigator
import RxCocoa
import RxSwift

class HomeVC: UIViewController {
    
    let navigator: NavigatorType
    var bag = DisposeBag()
    @IBOutlet weak var dateLabel: UILabel!
    
    init(navigator: NavigatorType) {
        self.navigator = navigator
        super.init(nibName: "Home", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func showDateView(_ sender: Any) {
        let completion: ((Date) -> ()) = { date in
            self.dateLabel.text = "\(date)"
        }
        navigator.present("myapp://DateView", context: completion)
    }
}
