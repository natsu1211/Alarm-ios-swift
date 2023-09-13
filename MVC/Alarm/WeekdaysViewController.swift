import UIKit

class WeekdaysViewController: UITableViewController {
    
    var weekdays: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Identifier.weekdaysUnwindIdentifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        for weekday in weekdays {
            if weekday == indexPath.row {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let index = weekdays.index(of: (indexPath.row)) {
            weekdays.remove(at: index)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            weekdays.append(indexPath.row)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
}


extension WeekdaysViewController {
    static func repeatText(weekdays: [Int]) -> String {
        if weekdays.count == 7 {
            return "Every day"
        }
        
        if weekdays.isEmpty {
            return "Never"
        }
        
        var weekdaysSorted = weekdays.sorted(by: <)
        // Does swift has static cached emtpy string?
        var ret = ""
        for day in weekdaysSorted {
            ret += weekdaysText[day]
        }
        return ret
    }
}

fileprivate extension WeekdaysViewController {
    static let weekdaysText = ["Sun ", "Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat "]
}
