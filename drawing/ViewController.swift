//
//  ViewController.swift
//  drawing
//
//  Created by Luis Garcia on 7/6/17.
//  Copyright © 2017 GT. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var motionManager: CMMotionManager?
    var coloring = false
    var myColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        selectedImage = tappedImage.image!
        
        if selectedImage == #imageLiteral(resourceName: "brick"){
            print("I got bricks")
            myColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1.0)
        }
        if selectedImage == #imageLiteral(resourceName: "train"){
            print("I got train")
            myColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1.0)
        }
        if selectedImage == #imageLiteral(resourceName: "canvas"){
            print("I got canvas")
            myColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        }


        

        print("in img tapped func")
        print(tappedImage)
        update()
    }
    func update(){
        print("made it to update")
        permView.image = selectedImage
    }
    
    //images
    
    @IBOutlet weak var canvas1: UIImageView!
    @IBOutlet weak var canvas2: UIImageView!
    @IBOutlet weak var canvas3: UIImageView!
    var selectedImage = UIImage(named: "train")
    
    
    //buttons
    
    @IBAction func resetFunc(_ sender: UIButton) {
        permView.image = nil
    }
    
    
    @IBAction func onRealRelease(_ sender: UIButton) {
        
        if let manager = motionManager {
            manager.stopDeviceMotionUpdates()
        }
        
        
        
    }
    
    
    @IBAction func onRelease(_ sender: UIButton) {
//        if !coloring {
//            coloring = true
//        } else {
//            coloring = false
//        }
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager")
            if manager.isDeviceMotionAvailable {
                print("We can detect device motion!")
                let myQ = OperationQueue()
                manager.deviceMotionUpdateInterval = 0.01
//                if coloring {
                    manager.startDeviceMotionUpdates(to: myQ, withHandler: {
                        (data: CMDeviceMotion?, error: Error?) in
                        if let mydata = data {
                            print("My pitch ", mydata.attitude.pitch)
                            print("My roll ", mydata.attitude.roll)
                            let thisPitch = self.degrees(radians: mydata.attitude.pitch * 5) + 300
                            let thisRoll = self.degrees(radians: mydata.attitude.roll * 2.5) + 200
                            let currentPoint = CGPoint(x: thisRoll, y: thisPitch)
                            print(currentPoint)
                            self.lastPoint = currentPoint
                            self.drawLines(fromPoint: self.lastPoint, toPoint: currentPoint)
                            
                            
                            
                            
                        }
                        if let myerror = error {
                            print("myError", myerror)
                            manager.stopDeviceMotionUpdates()
                        }
                    })
//                } else {
//                    manager.stopDeviceMotionUpdates()
//                }
            } else {
                print("We can not detect device motion!")
            }
        } else {
            print("We do not have a motion manager")
        }

        
        
    }
   
    func degrees(radians:Double) -> Double {
        return (180/Double.pi) * radians
    }
    
    @IBOutlet weak var permView: UIImageView!
//    permView = CGAffineTransformMakeScale(0.5, 0.5)
//    permView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 15.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
//    let colors: [(CGFloat, CGFloat, CGFloat)] = [(0,0,0)]
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = false
//        if let touch = touches.first {
//            lastPoint = touch.location(in: self.view)
//        }
//    }
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        permView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        print (fromPoint, " and ", toPoint)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(4)
        context?.setStrokeColor(myColor.cgColor)
        
        context?.strokePath()
        permView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = true
//        if let touch = touches.first {
//            let currentPoint = touch.location(in: self.view)
//            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
//            
//            lastPoint = currentPoint
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !swiped {
//            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
//        }
//    }

    
//    let interval = 0.5
    
//    func isDevicesAvailable() -> Bool {
//        let gyroAvailable = motionManager.isGyroAvailable
//        let accelAvailable = motionManager.isAccelerometerAvailable
//        if !motionManager.isDeviceMotionAvailable {
//            let alert = UIAlertController(title: "Drawing", message: "Your device does not have the necessary sensors. You might wat to try on another device.", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
//            print("Devices not detected")
//        }
//        return motionManager.isDeviceMotionAvailable
//    }
    
//    func myDeviceMotion() {
//        motionManager.startDeviceMotionUpdates(to: <#T##OperationQueue#>, withHandler: <#T##CMDeviceMotionHandler##CMDeviceMotionHandler##(CMDeviceMotion?, Error?) -> Void#>)
//    }
//    
    
        
        
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if isDevicesAvailable() {
//            print("Core Motion Launched")
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
        canvas1.image = UIImage(named: "canvas")
        canvas2.image = UIImage(named: "brick")
        canvas3.image = UIImage(named: "train")
        
        
        
        
        let canvas1Tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        canvas1.isUserInteractionEnabled = true
        canvas1.addGestureRecognizer(canvas1Tap)
        
        let canvas2Tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        canvas2.isUserInteractionEnabled = true
        canvas2.addGestureRecognizer(canvas2Tap)
        
        let canvas3Tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        canvas3.isUserInteractionEnabled = true
        canvas3.addGestureRecognizer(canvas3Tap)
        
     


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

