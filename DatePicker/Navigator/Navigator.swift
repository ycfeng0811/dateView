//
//  Created by YCFeng on 2021/3/31.
//

import Foundation
import URLNavigator
import RxCocoa
import RxSwift

protocol ModelViewViewModel {
    associatedtype Input
    func transform(input: Input)
}


class NavigatorMap {
   
    struct AlertContext {
        var title: String
        var message: String
        var completion: (()->())
    }
    
    static var bag = DisposeBag()
    static func initialize(navigator: NavigatorType) {
        home(navigator: navigator)
        //    navigator.register("myapp://user/<int:id>") {}
    }
    

    
    static func home(navigator: NavigatorType) {
        
        
        navigator.register("myapp://Home") { (url, values, _) -> UIViewController? in
            
            let vc = HomeVC(navigator: navigator)

            let nvc = UINavigationController.init(rootViewController: vc)
   
            
            return nvc
        }
        
   
        
        navigator.register("myapp://DateView") { (url, values, context) -> UIViewController? in
            guard let completion = context as? (Date)->() else {
                return nil
            }
            let vc = DateViewController(navigator: navigator, completion: completion)
            return vc
        }
        
   
        
        navigator.handle("navigator://alert", self.alert(navigator: navigator))
        
        navigator.handle("navigator://checkalert", self.checkAlert(navigator: navigator))
    }
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    
    private static func checkAlert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let _context = context as? AlertContext else {
                return false
            }
            let alertController = UIAlertController(title: _context.title, message: _context.message, preferredStyle: .alert)
        
           
            alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
            alertController.addAction(UIAlertAction(title: "刪除",
                                                    style: .destructive) { _ in
                _context.completion()
            })
            navigator.present(alertController)
            return true
        }
    }
}

