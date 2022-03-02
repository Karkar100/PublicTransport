//
//  MapViewController.swift
//  Public Transport
//
//  Created by Diana Princess on 26.02.2022.
//

import UIKit
import MapboxMaps
import SnapKit

class MapViewController: UIViewController, MapViewProtocol {
    
    var presenter: MapPresenterProtocol?
    var station: StationResponseModel!
    var mapView: MapView!
    private let callbackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Подробнее", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        
    }
    

    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    func createMap(stationResponse: StationResponseModel, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        station = stationResponse
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1Ijoia2Fya2FyMTAwIiwiYSI6ImNsMDVxNm80MDB6NzYzbnFkdXdzYzduMnAifQ.ROmDRn0E77qYjXnK7gi1gg")
        let initialCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let options = MapInitOptions(resourceOptions: myResourceOptions,cameraOptions: CameraOptions(center: initialCoordinate, zoom: 16.0))
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        var centerCoordinate = mapView.cameraState.center
        centerCoordinate = initialCoordinate
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        var customPointAnnotation = PointAnnotation(coordinate: initialCoordinate)
        customPointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
        pointAnnotationManager.annotations = [customPointAnnotation]
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        setupButton()
        handleShowBottomSheet(stationResponse: station)
    }

    func setupButton() {
        view.addSubview(callbackButton)
        callbackButton.addTarget(self, action: #selector(returnBottomSheet), for: .touchUpInside)
        callbackButton.clipsToBounds = true
        callbackButton.layer.cornerRadius = 5
        callbackButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(44)
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func handleShowBottomSheet(stationResponse: StationResponseModel) {
        let viewController = MapBottomSheetViewController(initialHeight: 120, station: stationResponse)
        let navigationController = BottomSheetNavigationController(rootViewController: viewController)
        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        navigationController.transitioningDelegate = transitionDelegate
        navigationController.modalPresentationStyle = .custom
        present(navigationController, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        let label = UILabel()
            label.textAlignment = .center
        if message == "" {
            label.text = "Станция не найдена"
        } else {
            label.text = message
        }
            self.view.addSubview(label)
        label.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func returnBottomSheet(){
        presenter?.updateStation(id: station.id ?? "00014195-8703-4ee1-a55a-cc6421c2bd8f")
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

extension MapViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

extension MapViewController: BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { true }
    
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
}
