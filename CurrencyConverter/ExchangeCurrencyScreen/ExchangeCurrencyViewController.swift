//
//  CorrencyConververViewController.swift
//  CurrencyConverter
//
//  Created by Ice on 13.12.2024.
//

import UIKit

fileprivate struct Styles {
    struct Color {
        static let backgroundColor = UIColor.AppColor.ghostWhiteColor
        static let headerTitleColor = UIColor.AppColor.midnightExpressColor
        static let backButtonColor = UIColor.AppColor.waikawaGreyColor
    }
    
    struct Image {
        static let backButtonIcon = UIImage(named: "BackButtonGreyColor")
    }
    
    struct Text {
        static let screenTitle = "Exchange Currency"
    }
}

class ExchangeCurrencyViewController: UIViewController {
    lazy var exchangeAmountView: ExchangeAmountView = {
        let view = ExchangeAmountView()
        return view
    }()
    
    lazy var convertedAmountCardView: ConvertedAmountCardView = {
        let view = ConvertedAmountCardView()
        return view
    }()
    
    lazy var currencyCardView: CurrencyCardView = {
        let view = CurrencyCardView()
        view.showListOfCurrencies = { [weak self] identifier, currency in
            self?.showListOfCurrencies(isSourceCurrency: identifier, currentCurrency: currency)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    deinit {
        print(#function, "ExchangeCurrencyViewController")
    }
    
    private func initUI() {
        detailsScreenNavigationHeader(backButtonImage: Styles.Image.backButtonIcon, action: #selector(backButtonAction), title: Styles.Text.screenTitle)
        view.backgroundColor = Styles.Color.backgroundColor
        
        view.addSubview(exchangeAmountView)
        view.addSubview(convertedAmountCardView)
        view.addSubview(currencyCardView)
        
        let viewTopInset: CGFloat = 25 + UIApplication.windowInset.top + (navigationController?.view.safeAreaInsets.top ?? 0)
        
        exchangeAmountView.topAnchor.constraint(equalTo: view.topAnchor, constant: viewTopInset).isActive = true
        exchangeAmountView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exchangeAmountView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        convertedAmountCardView.topAnchor.constraint(equalTo: exchangeAmountView.bottomAnchor, constant: 25).isActive = true
        convertedAmountCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        convertedAmountCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        currencyCardView.topAnchor.constraint(equalTo: convertedAmountCardView.bottomAnchor, constant: 16).isActive = true
        currencyCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currencyCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc
    private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showListOfCurrencies(isSourceCurrency: Bool, currentCurrency: CurrencyType) {
        let currenciesVC = CurrencyListViewController(currentCurrency: currentCurrency)
        currenciesVC.selectedValue = { [weak self] currency in
            if isSourceCurrency {
                self?.currencyCardView.sourceCurrency.updateCurrency(currency)
            } else {
                self?.currencyCardView.targetCurrency.updateCurrency(currency)
            }
        }
        
        let navigationVC = UINavigationController(rootViewController: currenciesVC)
        
        if let sheet = navigationVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(navigationVC, animated: true, completion: nil)
    }
}
