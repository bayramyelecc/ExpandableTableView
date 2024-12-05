//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Bayram Yeleç on 5.12.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    var items: [Model] = [
        Model(headerTitle: "Section 1", subTitle: ["item 1","item 2","item 3"]),
        Model(headerTitle: "Section 2", subTitle: ["item 1","item 2","item 3","item 4"]),
        Model(headerTitle: "Section 3", subTitle: ["item 1","item 2","item 3","item 4", "item 5"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        configure()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func configure(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isHidden = items[section].isOn
        if isHidden {
            return 0
        } else {
            return items[section].subTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.section].subTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        button.buttonUI(title: "\(items[section].headerTitle)", image: items[section].isOn ? UIImage(systemName: "chevron.right")! : UIImage(systemName: "chevron.down")!)
        button.tag = section
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ViewController {
    @objc func buttonTapped(_ sender: UIButton) {
        let section = sender.tag
        items[section].isOn.toggle()
        
        let newImage = items[section].isOn ? UIImage(systemName: "chevron.down")! : UIImage(systemName: "chevron.right")!
        
        UIView.transition(with: sender, duration: 0.2, options: .transitionCrossDissolve) {
            sender.configuration?.image = newImage
        }
        
        tableView.reloadSections(IndexSet(integer: section), with: .fade)
    }
}

extension UIButton {
    
    func buttonUI(title: String, image: UIImage) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        self.configuration = config
        self.contentHorizontalAlignment = .fill
    }
    
}
