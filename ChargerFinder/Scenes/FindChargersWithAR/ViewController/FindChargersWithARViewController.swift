//
//  FindChargersWithARViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 19/04/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import CoreLocation
import GameplayKit

class FindChargersWithARViewController: UIViewController {
    let locationManager = CLLocationManager()
    var userLocation = CLLocation()
    var userHeading = 0.0
    var headingStep = 0
    var sitesJSON : JSON!
    var sites = [UUID : String]()
    
    private lazy var sceneView: ARSKView = {
        let view = ARSKView()
        return view
    }()
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = AROrientationTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - ProgramaticallyLayoutable
extension FindChargersWithARViewController: ProgrammaticallyLayoutable {
    
    func setupViewHierarchy() {
        view.addSubview(sceneView)
    }
    
    func setupConstraints() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupAditionalConfigurations() {}
}

// MARK: - ARSKViewDelegate
extension FindChargersWithARViewController: ARSKViewDelegate {
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let labelNode = SKLabelNode(text: sites[anchor.identifier])
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        
        let newSize = labelNode.frame.size.applying(CGAffineTransform(scaleX: 1.1, y: 1.5))
        let backgroundNode = SKShapeNode(rectOf: newSize, cornerRadius: 10)
        let randomColor = UIColor(hue: CGFloat(GKRandomSource.sharedRandom().nextUniform()), saturation: 0.5, brightness: 0.4, alpha: 0.9)
        
        backgroundNode.fillColor = randomColor
        backgroundNode.strokeColor = randomColor.withAlphaComponent(1.0)
        backgroundNode.lineWidth = 2
        backgroundNode.addChild(labelNode)
        
        return backgroundNode
    }
}

// MARK: - CLLocationManagerDelegate
extension FindChargersWithARViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.updateSites()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
            self.headingStep += 1
            if self.headingStep < 2 { return }
            
            self.userHeading = newHeading.magneticHeading
            self.locationManager.stopUpdatingHeading()
            self.createSites()
        }
    }
}

// MARK: - TODO: move this functions to the presenter
extension FindChargersWithARViewController {
    func updateSites(){
        let urlString = "https://es.wikipedia.org/w/api.php?ggscoord=\(userLocation.coordinate.latitude)%7C\(userLocation.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {return}
        
        if let data = try? Data(contentsOf: url){
            sitesJSON = JSON(data)
            print(sitesJSON ?? String.empty)
            locationManager.startUpdatingHeading()
        }
        
    }


    func createSites(){
        //Hacer un bucle de todos los lugares que ocupa el JSON de la Wikipedia
        for page in sitesJSON["query"]["pages"].dictionaryValue.values {
            //Ubicar latitud y longitud de esos lugares -> CLLocation
            let lat = page["coordinates"][0]["lat"].doubleValue
            let lon = page["coordinates"][0]["lon"].doubleValue
            let location = CLLocation(latitude: lat, longitude: lon)
            
            //Calcualr la distancia y la dirección (azimut) desde el usuario hasta ese lugar
            let distance = Float(userLocation.distance(from: location))
            let azimut = Math.direction(from: userLocation, to: location)
            
            //Sacar ángulo entre azimut y la dirección del usuario
            let angle = azimut - userHeading
            let angleRad = Math.transformDegreesToRadians(angle)
            
            //Crear las matrices de rotación para posicionar horizontalmente el ancla
            let horizontalRotation = simd_float4x4(SCNMatrix4MakeRotation(Float(angleRad), 1, 0, 0))
            //Crear la matriz para la rotación vertical basada en la distancia
            let verticalRotation = simd_float4x4(SCNMatrix4MakeRotation(-0.3 + Float(distance/500), 0, 1, 0))
            
            //Multiplicar las matrices de rotación anteriores y multiplicarlas por la cámara de ARKit
            let rotation = simd_mul(horizontalRotation, verticalRotation)
            
            //Crear una matriz identidad y moverla una cierta cantidad dependiendo de donde posicionar el objeto en profundidad.
            guard let sceneView = self.view as? ARSKView else{ return }

            guard let currentFrame = sceneView.session.currentFrame else { return }
            
            let rotation2 = simd_mul(currentFrame.camera.transform, rotation)
            
            //Posicionaremos el ancla y le daremos un identificador para localizarlo en escena
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -Math.clamp(value:distance / 1000, lower: 0.5, upper: 4.0)
            
            let transform = simd_mul(rotation2, translation)
            
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            sites[anchor.identifier] = "\(page["title"].string!) - \(Int(distance)) metros"
        }
    }
}
