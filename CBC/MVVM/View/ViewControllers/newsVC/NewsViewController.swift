//
//  NewsViewController.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-02.
//

import UIKit

final class NewsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: Instance references
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
    private var viewModel = NewsViewModel()
    private let toggleSwitch = UISwitch()
    let isOniPad = UIDevice.current.userInterfaceIdiom == .pad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }
    //Setup All UI Elements
    private func configureUI() {
        setupXibs()
        setupSwitch()
        setupFilterBtn ()
        registerNotifications()
        configureSpinnerView()
    }
    //The Arrangement of Collective's Content being drawn using Xib
    private func setupXibs()  {
        collectionView.register(NewsCollectionViewCell.nib, forCellWithReuseIdentifier: CellIdentifier.newsCell)
        collectionView.collectionViewLayout = layout()
    }
    //To Notify the Internet Connectivity
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(offline(notification:)), name: .NetworkDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(online(notification:)), name: .NetworkConnected, object: nil)
    }
    //Activity indicator
    private func configureSpinnerView() {
        //Setup the activity indicator
        spinner.backgroundColor = UIColor(white: 0, alpha: 0.2) // make bg darker for greater contrast
        spinner.color = .blue
        view.addSubview(spinner)
        spinner.frame = view.frame // center it
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        spinner.transform = transform
    }
    //Only available on the iPad
    private func setupSwitch() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            toggleSwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
            let switchContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
            switchContainer.addSubview(toggleSwitch)
            navigationItem.titleView = switchContainer
        }
    }
    //Filter Options from the API
    private func setupFilterBtn () {
        // Create a custom UIButton with your image
        let button = UIButton(type: .custom)
        let image = UIImage(named: Constants.FILTER_ICON)
        
        let aspectFitSize = image?.aspectFitSize(in: CGSize(width: 50, height: 50))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: aspectFitSize?.width ?? 0, height: aspectFitSize?.height ?? 0)
        button.addTarget(self, action: #selector(showFilterOptions), for: .touchUpInside)
        let customItem = UIBarButtonItem(customView: button)
        // Add the UIBarButtonItem to the right side of the navigation bar
        navigationItem.rightBarButtonItem = customItem
    }
    
    private func activateSpinner(active:Bool) {
        DispatchQueue.main.async {
            active ? self.spinner.startAnimating() : self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled =  active ? false : true
            
        }
    }
    //Configure the layout of the elements based on the device size
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let itemWidth = toggleSwitch.isOn ? 0.5 : 1.0
            let itemSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(itemWidth),
                heightDimension: .estimated(400)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize (
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(400)
            )
            //Not only on iPad but also this works on phone's landscape in this way
            let columns = (isOniPad && self.toggleSwitch.isOn) ? 2 : 1
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
            
            group.interItemSpacing = .fixed(20)
            
            if columns > 1 {
                group.contentInsets.leading = 20
                group.contentInsets.trailing = 20
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets.top = 20
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    //If Online
    @objc private func online(notification: Notification) {
        DispatchQueue.main.async {
            self.showAlertWithActions(title: AlertAction.ALERT_TITLE, message: AlertMerssage.INTERNET_ONLINE_MESSAGE, yesAction: {
                self.fetchData()
            }, noAction: {})
        }
    }
    //If Offline
    @objc private func offline(notification: Notification) {
        DispatchQueue.main.async {
            self.showAlert(title: AlertAction.ALERT_TITLE, message: AlertMerssage.INTERNET_OFFLINE_MESSAGE)
        }
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        fetchData()
    }
    //Show the filteration options
    @objc func showFilterOptions () {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: AlertAction.FILTER_OPTIONS, message: nil, preferredStyle: .actionSheet)
            
            for type in self.viewModel.uniqueNewsTypes {
                let action = UIAlertAction(title: type, style: .default) { [weak self] (_) in
                    // Filter the data based on the selected type
                    self?.viewModel.filterData(with: type)
                    self?.collectionView.reloadData()
                }
                alertController.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: AlertAction.CANCEL, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            // On iPad, set the popover presentation properties
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = []
            }
            if self.viewModel.uniqueNewsTypes.count > 0 {self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
//MARK: Main Fucntion to fetch data from the ViewModel
extension NewsViewController {
    //Fetch data from the API
    fileprivate func fetchData(isReload:Bool? = false) {
        activateSpinner(active: true)
        viewModel.fetchNews (completion:{[weak self] (result) in
            switch result {
            case .success():
                //Reload the table
                print("Success.....")
                DispatchQueue.main.async {
                    self?.activateSpinner(active: false)
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activateSpinner(active: false)
                    self?.showAlert(title: AlertAction.ALERT_TITLE, message: error.localizedDescription)
                }
            }
        },isReload!)
    }
    //Configure the cell details
    fileprivate func configureCell(cell:NewsCollectionViewCell, news:NewsModel)  {
        if let image = news.imageData {cell.imageVw.image = UIImage(data:image)}
        cell.headlineLbl.text = news.title
        cell.publishedDateLbl.text = Int(news.publishedAt ?? 0).toFormattedDateTime()
    }
}
//MARK: Delegates and Data Sources
extension NewsViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredNewsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.newsCell, for: indexPath) as! NewsCollectionViewCell
        if viewModel.filteredNewsData.count > 0 {
            configureCell(cell: cell, news: viewModel.filteredNewsData[indexPath.item])
        }
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegate {
    //MARK: When the list if Scrolled to the bottom it'll fetch new data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsData.count - 1 { // Check if the last cell is displayed
            viewModel.setPageOffset()
            DispatchQueue.main.async {
                self.fetchData(isReload: true) // Trigger the API request for the next page
            }
        }
    }
}
