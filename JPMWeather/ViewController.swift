//
//  ViewController.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var searchBar : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for a city"
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    private func setupViews(){
        self.view.backgroundColor = .systemBackground
        self.navigationItem.searchController = self.searchBar
    }


}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
                    


extension UIView {
    func setConstraints(top: NSLayoutYAxisAnchor? = nil, topPadding: CGFloat = 0,
                        bottom: NSLayoutYAxisAnchor? = nil, bottomPadding: CGFloat = 0,
                        leading: NSLayoutXAxisAnchor? = nil, leadingPadding: CGFloat = 0,
                        trailing: NSLayoutXAxisAnchor? = nil, trailingPadding: CGFloat = 0,
                        width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -trailingPadding).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: leadingPadding).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
