

import Foundation
import UIKit
import URLNavigator
import RxCocoa
import RxSwift

class DateViewController: UIViewController {
    
    let navigator: NavigatorType
    var bag = DisposeBag()
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var sureButton: UIButton!
    
    var selectedDate = BehaviorRelay<Date?>(value: nil)
    var completion: ((Date) -> ())
    
    init(navigator: NavigatorType, completion: @escaping ((Date) -> ())) {
        self.navigator = navigator
        self.completion = completion
        super.init(nibName: "DateView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: bag)

        sureButton
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                guard let _date = selectedDate.value else {
                    return
                }
                self.dismiss(animated: true) {
                    completion(_date)
                }
            }).disposed(by: bag)

        datePicker.rx
            .date
            .subscribe(onNext: { [unowned self] date in
                self.selectedDate.accept(date)
            }).disposed(by: bag)
            
    }
    
    
    deinit {
        print("date view deinit")
    }
}
