import Foundation
import UIKit

public extension UITableView {
    func indexPath(forSubView subView: UIView?) -> IndexPath? {
        var view = subView
        while view != nil && !(view is UITableViewCell) {
            view = subView?.superview
        }
        if let cellView = view as? UITableViewCell {
            return self.indexPath(for: cellView)
        } else {
            return nil
        }
    }
}
