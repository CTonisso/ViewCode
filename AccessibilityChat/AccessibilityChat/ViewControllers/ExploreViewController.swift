//
//  ExploreViewController.swift
//  AccessibilityChat
//
//  Created by Carlos Marcelo Tonisso Junior on 10/24/18.
//  Copyright © 2018 Bianca Itiroko. All rights reserved.
//

import UIKit
import Gifu

class ExploreViewController: ACViewController {
    let explorePresenter: ExplorePresenter = ExplorePresenter()
    let theme: Theme = UserDefaultsManager.getTheme()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextAudioButton: UIButton!
    @IBOutlet weak var previousAudioButton: UIButton!
    @IBOutlet weak var loadingImageView: GIFImageView!
    
    var users: [LocalUser] = []
    var audios: [Data?] = []

    var currentIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Explore"
        
        previousAudioButton.isHidden = true
        nextAudioButton.isHidden = true
        
        loadingImageView.isAccessibilityElement = true
        loadingImageView.animate(withGIFNamed: theme.loadingGIFName)
        self.loadingImageView.accessibilityLabel = "Carregando, por favor aguarde"

        guard let userUid = explorePresenter.fetchUser() else {
            print("LOG: Problems in getting current user")
            return
        }

        explorePresenter.fetchUsers(without: userUid) { (users) in
            let filteredUsers = users.filter {
                $0.descriptionID != nil
            }

            self.users = filteredUsers

            self.explorePresenter.retrieveAudioDescriptions(users: self.users, completion: { (audios) in
                self.audios = audios

                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                    self.loadingImageView.stopAnimatingGIF()
                    self.loadingImageView.isHidden = true
                    self.previousAudioButton.isHidden = false
                    self.nextAudioButton.isHidden = false
                })
            })
        }

        configureCollectionLayout()
        configureButtons()
        self.view.backgroundColor = theme.backgroundColor
        
        enableButtons(IndexPath(row: 0, section: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    private func configureButtons() {
        nextAudioButton.setBackgroundImage(theme.nextButtonImage, for: .normal)
        previousAudioButton.setBackgroundImage(theme.previousButtonImage, for: .normal)
    }
    
    private func configureCollectionLayout() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.contentMode = .top
        let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 0
        layout?.minimumInteritemSpacing = 0
        layout?.sectionInset = UIEdgeInsets.zero
    }

    fileprivate func enableButtons(_ currentIndexPath: IndexPath) {
        self.nextAudioButton.isEnabled = currentIndexPath.row != users.count - 1 ? true : false
        self.previousAudioButton.isEnabled = currentIndexPath.row != 0 ? true : false
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        guard let currentIndexPath = self.currentIndexPath else { return }
        if currentIndexPath.row < users.count - 1 {
            print(currentIndexPath)
            let nextIndex = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
            collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
            self.currentIndexPath = nextIndex
            enableButtons(nextIndex)
        }
    }

    @IBAction func previousPressed(_ sender: UIButton) {
        guard let currentIndexPath = self.currentIndexPath else { return }
        if currentIndexPath.row > 0 {
            let previousIndex = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
            collectionView.scrollToItem(at: previousIndex, at: .centeredHorizontally, animated: true)
            self.currentIndexPath = previousIndex
            enableButtons(previousIndex)
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PresentingAudioCollectionViewCell!

        if let cellAudio = collectionView.dequeueReusableCell(withReuseIdentifier: "PresentingAudioCell",
                                                              for: indexPath) as? PresentingAudioCollectionViewCell {
            cell = cellAudio
        }

        if let name = users[indexPath.row].name,
            let age = users[indexPath.row].age,
            let city = users[indexPath.row].city,
            let state = users[indexPath.row].state {
            cell.nameLabel.text = name
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let birth = TimeFormat.age(date: age) {
                cell.ageLabel.text = "\(birth) anos"
            } else {
                cell.ageLabel.text = "Idade não informada"
            }
            
            cell.cityLabel.text = "\(city), \(state)"
        }
        
        cell.playButton.setBackgroundImage(theme.playButton, for: .normal)

        cell.audioCurrentTimeLabel.text = TimeFormat.format(seconds: cell.counter)
        cell.audioTimeLabel.text = TimeFormat.format(seconds: cell.counter)
        cell.user = users[indexPath.row]
        
        cell.delegate = self
        
        cell.setupInitialState()

        return cell
    }

    func setPlayButtonAccessibilityLabel(button: UIButton, duration: Int) {
        let minutes = duration/60
        let seconds = duration%60
        button.accessibilityLabel = "Ouvir descrição com duração de \(minutes) minutos e \(seconds) segundos"
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        
        guard let data = audios[indexPath.row] else {
            print("LOG: Problems to get data audio from array")
            return
        }
        
        if let cellAudio = cell as? PresentingAudioCollectionViewCell {
            let duration = cellAudio.resetDuration(data)
            cellAudio.audioTimeLabel.text = TimeFormat.format(seconds: duration)
            setPlayButtonAccessibilityLabel(button: cellAudio.playButton, duration: duration)
        }
    }
}

extension ExploreViewController: ShowViewControllerDelegate {
    func show(_ viewController: ChatLogController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
