//
//  ViewController.swift
//  Route
//
//  Created by Надежда Морозова on 03/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    var locationManager = LocationManager.instance
    private var coordinates: CLLocationCoordinate2D?
    private var showYourLocationBool = true
    private var coordinatesArray: [CLLocationCoordinate2D] = []
    private var gMBounds: GMSCoordinateBounds?
    public var route: GMSPolyline?
    public var routePath: GMSMutablePath?
    private var marker: GMSMarker?
    private var imageForMarKer: UIImage?
    
    private let alert = UIAlertController(title: "Ошибка", message: "Нажмите Stop", preferredStyle: .alert)
    
    @IBOutlet var photoAva: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        if let loadImage = SaveToDisc().getSavedImage(named: "avatar.jpg") {
            imageForMarKer = loadImage
        }
        photoAva.layer.cornerRadius = photoAva.frame.width/2
    }
    
    @IBAction func StertAction(_ sender: Any) {
        showYourLocationBool = true
        route?.map = nil
        locationManager.startUpdatingLocation()
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        CoordinatesClass().deleteData()
    }
    
    @IBAction func PastAction(_ sender: Any) {
        let array = CoordinatesClass().loadData()
        if !showYourLocationBool {
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            route?.map = mapView
            print(array)
            for i in array {
                routePath?.add(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
                gMBounds?.includingCoordinate(CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude))
            }
            if let myCoordinate = gMBounds {
                let newCamera = GMSCameraUpdate.fit(myCoordinate, withPadding: 10)
                print("OK")
                mapView.animate(with: newCamera)
            }
            route?.path = routePath
        }
            
        else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func StopAction(_ sender: Any) {
        showYourLocationBool = false
        locationManager.stopUpdatingLocation()
        coordinatesArray.removeAll()
    }
    
    func configureMap() {
        if let myCoordinate = coordinates {
       // let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        let camera = GMSCameraPosition.camera(withTarget: myCoordinate, zoom: 17)
        mapView.camera = camera
        // Устанавливаем делегат
            mapView.delegate = (self as! GMSMapViewDelegate)
        }
    }
    
    func addMarker(location: CLLocationCoordinate2D ) {
        marker = GMSMarker(position: location)
        marker?.map = mapView
        
        if let image = imageForMarKer {
            let markerNewView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            markerNewView.layer.masksToBounds = true
            let imageview = UIImageView(image: image)
            imageview.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
            markerNewView.addSubview(imageview)
            markerNewView.layer.cornerRadius = markerNewView.frame.size.width/2
            marker?.iconView = markerNewView
        }
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                // Обновляем путь у линии маршрута путём повторного присвоения
                self?.route?.path = self?.routePath
                // Чтобы наблюдать за движением, установим камеру на только что добавленную
                // точку
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
        }
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        // Отвязываем от карты старую линию
        route?.map = nil
        // Заменяем старую линию новой
        route = GMSPolyline()
        // Заменяем старый путь новым, пока пустым (без точек)
        routePath = GMSMutablePath()
        // Добавляем новую линию на карту
        route?.map = mapView
        // Запускаем отслеживание или продолжаем, если оно уже запущено
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func takeSelfi(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {return}
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func toPhoto() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelfiViewController")
        controller.removeFromParent()
        show(controller, sender: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        SaveToDisc().deleteImage(name: "avatar")
        
        let image = extractImage(from: info)
        imageForMarKer = image ?? UIImage()
        SaveToDisc().saveImage(image: image ?? UIImage(), name: "avatar")
        picker.dismiss(animated: true, completion: nil)
        self.removeMarker()
        locationManager.location.asObservable().bind { [weak self] location in
            if let location = location {
                self?.removeMarker()
                self?.addMarker(location: location.coordinate)
            }
        }
    }
    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        // Пытаемся извлечь отредактированное изображение
        if let image = info[.editedImage] as? UIImage {
            return image
            // Пытаемся извлечь оригинальное
        } else if let image = info[.originalImage] as? UIImage {
            return image
        } else {
            // Если изображение не получено, возвращаем nil
            return nil
        }
    }
}



