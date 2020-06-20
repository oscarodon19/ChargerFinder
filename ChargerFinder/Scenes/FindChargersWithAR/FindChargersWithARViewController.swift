//
//  ARViewController.swift
//  ChargerFinder
//
//  Created by Oscar Odon on 07/06/2020.
//  Copyright © 2020 Oscar Odon. All rights reserved.
//

import SpriteKit
import ARKit
import CoreLocation
import GameplayKit

class FindChargersWithARViewController: UIViewController {
    private let router: FindChargersWithARRouter
    private var presenter: FindChargersPresenterProtocol
    var userLocation: CLLocation
    var viewModel: [Charger]?
    var userHeading = 0.0
    var sites = [UUID : String]()
    
    private lazy var sceneView: ARSKView = {
        let view = ARSKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
       
    init(router: FindChargersWithARRouter, presenter: FindChargersPresenterProtocol, userLocation: CLLocation = CLLocation()) {
        self.router = router
        self.presenter = presenter
        self.userLocation = userLocation
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.setViewDelegate(self)
        presenter.viewDidStart()
        sceneView.delegate = self
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
       
        let scene = SKScene(size: view.frame.size)
        sceneView.presentScene(scene)
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
}

// MARK: - ChargersDisplayable

extension FindChargersWithARViewController: ChargersDisplayable {
    func displayFetchedChargers(with viewModel: [Charger]) {
        self.viewModel = viewModel
    }
    
    func userDidAuthorizeLocation(_ coordinates: CLLocationCoordinate2D) {}
    
    func userDidNotAuthorizeLocation() {
        let alert = UIAlertController(title: "Location Access Required", message: "We need location access permits to use maps features", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didChangeLocation(with location: CLLocation) {
        userLocation = location
    }
    
    func didChangeHeading(with newHeading: CLHeading, _ manager: CLLocationManager) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userHeading = newHeading.magneticHeading
            manager.stopUpdatingHeading()
            self.createSites()
        }
    }
}

// MARK: - ProgramaticallyLayoutable
extension FindChargersWithARViewController: ProgrammaticallyLayoutable {
    
    func setupViewHierarchy() {
        view.addSubview(sceneView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            sceneView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sceneView.heightAnchor.constraint(equalTo: view.heightAnchor),
            sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
}

// MARK: - TODO: move this functions to the presenter
extension FindChargersWithARViewController {
    func createSites() {
        guard let chargers = viewModel else { return }
        for charger in chargers {
            //Ubicar latitud y longitud de los cargadores -> CLLocation
            let lat = charger.latitude
            let lon = charger.longitude
            let location = CLLocation(latitude: lat, longitude: lon)
            
            //Calcular la distancia y la dirección (azimut) desde el usuario hasta ese cargador
            let distance = Float(userLocation.distance(from: location))
            let azimut = Math.bearing(from: userLocation, to: location)
            
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
            let sceneView = self.sceneView

            guard let currentFrame = sceneView.session.currentFrame else { return }
            
            let rotation2 = simd_mul(currentFrame.camera.transform, rotation)
            
            //Posicionaremos el ancla y le daremos un identificador para localizarlo en escena
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -Math.clamp(value:distance / 1000, lower: 0.5, upper: 4.0)
            
            let transform = simd_mul(rotation2, translation)
            
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            sites[anchor.identifier] = "\(charger.name) - \(Int(distance)) metros"
        }
    }
}
