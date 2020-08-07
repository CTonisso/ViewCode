//
//  SettingsViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 11/21/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit

class SettingsViewController: ACViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let titles: [String] = ["Gravar nova apresentação", "Selecionar tema", "Termos de uso", "Sair da conta"]

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let theme: Theme = UserDefaultsManager.getTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        self.navigationItem.title = "Configurações"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setTheme() {
        self.view.backgroundColor = theme.backgroundColor
        self.tableView.backgroundColor = theme.backgroundColor
        self.tableView.separatorColor = theme.tableViewSeparatorColor
    }

}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: titles[indexPath.section],
                       color: indexPath.section < titles.count - 1 ? theme.textColor : theme.textAlertColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = theme.themeType == ThemeType.dark ? UIImageView(image: #imageLiteral(resourceName: "tableViewSeparator-Dark")) : UIImageView(image: #imageLiteral(resourceName: "tableViewSeparator-Light"))
        return imageView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 49 : 0
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let recordViewController = UIStoryboard(name: "RecordDescription", bundle: nil)
                .instantiateViewController(withIdentifier: "RecordDescription")
                as? RecordDescriptionViewController
            
            NavigationHelper.shared.switchRootViewController(to: recordViewController,
                                                             withAnimation: .revealFromTop)
            
            appDelegate?.window?.rootViewController?.dismiss(animated: true,
                                                                  completion: nil)
        } else if indexPath.section == 1 {
            let chooseThemeViewController = ChooseThemeViewController()
            
            let chooseThemeNavigationController = UINavigationController(rootViewController: chooseThemeViewController)
            NavigationHelper.shared.switchRootViewController(to: chooseThemeNavigationController,
                                                             withAnimation: .revealFromTop)
            
            appDelegate?.window?.rootViewController?.dismiss(animated: true,
                                                             completion: nil)
        } else if indexPath.section == 2 {
            performSegue(withIdentifier: "TermsOfUseSegue", sender: self)
        } else if indexPath.section == 3 {
            UserServices().signOut { (success) in
                if success {
                    let loginViewController = LoginViewController()
                    let navigationController = UINavigationController(rootViewController: loginViewController)

                    NavigationHelper.shared.switchRootViewController(to: navigationController,
                                                                     withAnimation: .revealFromTop)
                    
                    self.appDelegate?.window?.rootViewController?.dismiss(animated: true,
                                                                     completion: nil)
                }
            }
            
        }
    }
}
