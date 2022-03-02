//
//  MapBottomSheetViewController.swift
//  Public Transport
//
//  Created by Diana Princess on 26.02.2022.
//

import UIKit
import SnapKit

class MapBottomSheetViewController: UIViewController {

    private let _scrollView = UIScrollView()
    
    
    private let stationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }
    var currentStation: StationResponseModel
    var routes: [RouteData] = []
    
    // MARK: - Init

    init(initialHeight: CGFloat, station: StationResponseModel) {
        currentHeight = initialHeight
        currentStation = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        setupSubviews()
        updatePreferredContentSize()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(_scrollView)
        
        _scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview()
        }
        _scrollView.alwaysBounceVertical = true
        
        stationNameLabel.text = currentStation.name
        view.addSubview(stationNameLabel)
        stationNameLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        if currentStation.routePath?.count == 0 {
            noRoutes()
        } else {
            displayRoutes(station: currentStation)
        }
    }

    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
    }
    
    private func updateContentHeight(newValue: CGFloat) {
        guard newValue >= 150 && newValue < 5000 else { return }
        
        currentHeight = newValue
        updatePreferredContentSize()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func displayRoutes(station: StationResponseModel){
        var labelArray: Array<UILabel> = []
        var timeLabelArray: Array<UILabel> = []
        for route in station.routePath ?? [] {
            labelArray += [createNewLabel(withColor: hexStringToUIColor(hex: route.color ?? "#999999"), title: setTitle(withColor: hexStringToUIColor(hex: route.fontColor ?? "#FFFFFF"), text: route.number))]
            if route.timeArrival.isEmpty {
                timeLabelArray += [createTimeLabel(time: "неизвестно")]
            } else {
                timeLabelArray += [createTimeLabel(time: route.timeArrival[0])]
            }
        }
        let subStackView = UIStackView(arrangedSubviews: labelArray)
        subStackView.axis = .horizontal
        subStackView.distribution = .fillEqually
        subStackView.alignment = .fill
        subStackView.spacing = 8
        let timeStackView = UIStackView(arrangedSubviews: timeLabelArray)
        timeStackView.axis = .horizontal
        timeStackView.distribution = .fillEqually
        timeStackView.alignment = .fill
        timeStackView.spacing = 8
        let mainStackView = UIStackView(arrangedSubviews: [subStackView, timeStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        _scrollView.addSubview(mainStackView)
        
        let viewsDictionary = ["mainStackView":mainStackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[mainStackView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[mainStackView]-30-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        _scrollView.addConstraints(stackView_H)
        _scrollView.addConstraints(stackView_V)
        mainStackView.snp.makeConstraints{ make in
            make.centerY.equalTo(view)
        }
    }
    
    func setTitle(withColor fontColor: UIColor, text: String) -> NSAttributedString{
        let attributes = [NSAttributedString.Key.foregroundColor: fontColor]
        let title = NSAttributedString(string: text, attributes: attributes)
        return title
    }
    
    func createNewLabel(withColor color: UIColor, title: NSAttributedString) -> UILabel{
        let newLabel = UILabel()
        newLabel.backgroundColor = color
        newLabel.textAlignment = .center
        newLabel.clipsToBounds = true
        newLabel.layer.cornerRadius = 5
        newLabel.attributedText = title
        return newLabel
    }
    
    func createTimeLabel(time: String) -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        var attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if time == "неизвестно" {
            attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemRed]
        } else {
            attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
        }
        label.attributedText = NSAttributedString(string: time, attributes: attributes)
        return label
    }
    
    func noRoutes(){
        let noRouteLabel = UILabel()
        noRouteLabel.textAlignment = .center
        let font = UIFont.systemFont(ofSize: 24)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowBlurRadius = 3

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.red,
            .shadow: shadow
        ]
        noRouteLabel.attributedText = NSAttributedString(string: "МАРШРУТЫ НЕ НАЙДЕНЫ!", attributes: attributes)
        view.addSubview(noRouteLabel)
        noRouteLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
