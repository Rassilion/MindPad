//
//  ViewController.swift
//  MindPad
//
//  Created by Deniz Gezgin on 29/12/2017.
//  Copyright © 2017 yagodeniz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DrawViewDelegate {
    
    @IBAction func quit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func predict() {
        let context = drawView.getViewContext()
        inputImage = context?.makeImage()
        let pixelBuffer = UIImage(cgImage: inputImage).pixelBuffer()
        let output = try? model.prediction(image: pixelBuffer!)
        prediction.text = output?.classLabel
        submitButton.isEnabled = true
    }
    

    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var scoreLabel: UINavigationItem!
    @IBOutlet weak var timeLabel: UIBarButtonItem!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    var initGam = false
    var questionNo: Int = 0
    var lastAnswerCorrect: Bool = true
    var currentDifficulty: UInt32 = 0
    var mode: Int32 = 0
    var op1: UInt32 = 0
    var op2: UInt32 = 0
    var opcode: UInt32 = 0
    var result: UInt32 = 0
    var answer: String = ""
    
    var score:Int32 = 0
    
    var timerTotal = Timer()
    var questionStartTime:Int = 0

    var totalTimer:Int = 0
    var predictTimer = 1
    let model = mnistCNN()
    var inputImage: CGImage!
    
    func runTotalTime() {
        timerTotal = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTotalTime)), userInfo: nil, repeats: true)
    }

    
    @IBOutlet weak var prediction: UILabel!
    
    func next()
    {
        questionNo += 1
        switch mode {
        case 1://normal
            if questionNo < 5
            {
                generateQuestion(difficulty: 1)
            }
            else if questionNo < 10
            {
                generateQuestion(difficulty: 2)
            }
            else if questionNo == 10
            {
                generateQuestion(difficulty: 3)
            }
            else
            {
                performSegue(withIdentifier: "resultSegue", sender: nil)
            }
            break
        case 2://time attack
            if totalTimer < 150{
                generateQuestion(difficulty: arc4random_uniform(3) + 1)
            }
            break
        case 3: //survival
            if lastAnswerCorrect {
                generateQuestion(difficulty: arc4random_uniform(3) + 1)
            }
            else{
                performSegue(withIdentifier: "resultSegue", sender: nil)
            }
            break
        default:
            break
        }
    }
    
    @objc func updateTotalTime(){
        totalTimer += 1
        
        if (mode == 2){
            timeLabel.title="\(150-totalTimer)"
        }else{
            timeLabel.title="\(totalTimer)"
        }
        if (mode == 2 && totalTimer>150){
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        runTotalTime()
        drawView.delegate=self
        initGame()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if initGam{
            initGame()
            initGam = false
        }
    }

    
    func initGame(){
         questionNo = 0
         lastAnswerCorrect = true
         currentDifficulty = 0
         op1 = 0
         op2 = 0
         opcode = 0
         result = 0
         answer = ""
        
         score = 0
        
         questionStartTime = 0
        
         totalTimer = 0
        
        submitButton.isEnabled = false
        
        next()
        prediction.text = " "
        print(" mode \(mode)")
        
        scoreLabel.title="Score: \(score)"
    }
    
    @IBAction func tappedClear(_ sender: Any) {
        drawView.lines = []
        drawView.setNeedsDisplay()
        prediction.text = " "
        submitButton.isEnabled = false
    }
    
    func gradeAnswer(){
        let answerTime = totalTimer - questionStartTime
        
        var questionScore:Int32 = max(Int32(currentDifficulty*30) - Int32(answerTime),0)
        
        score += questionScore
        scoreLabel.title="Score: \(score)"
    }
    
    @IBAction func tappedDetect(_ sender: Any) {
        let context = drawView.getViewContext()
        inputImage = context?.makeImage()
        let pixelBuffer = UIImage(cgImage: inputImage).pixelBuffer()
        let output = try? model.prediction(image: pixelBuffer!)
        if(output?.classLabel == answer){
            print("true")
            lastAnswerCorrect = true
            gradeAnswer()
        }else{
            print("false")
            lastAnswerCorrect = false
        }
        tappedClear(sender)
        
        next()
        questionStartTime=totalTimer
    }
    
    @IBOutlet weak var question: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateQuestion(difficulty: UInt32) {
        
        questionNoLabel.text="Question  \(questionNo)"
        currentDifficulty = difficulty
        opcode = arc4random_uniform(4)
        var opStr = "+"
        
        switch opcode {
        case 0:
            //number with difficulty + 1 digits
            result = arc4random_uniform(9) + 1
            for _ in 1...difficulty
            {
                result = result * 10 + arc4random_uniform(10)
            }
            
            let maxThird = UInt32(result / 3)
            
            //number in the middle third of the result
            op1 = arc4random_uniform(maxThird) + maxThird
            op2 = result - op1
        
        case 1:
        
            opStr = "-"
            
            //number with difficulty digits
            result = arc4random_uniform(9) + 1
            if difficulty > 1
            {
                for _ in 1...difficulty - 1
                {
                    result = result * 10 + arc4random_uniform(10)
                }
            }
            
            op2 = arc4random_uniform(9) + 1
            if difficulty > 1
            {
                for _ in 1...difficulty - 1
                {
                    op2 = op2 * 10 + arc4random_uniform(10)
                }
            }
            
            op1 = result + op2
            
        case 2:
            
            opStr = "*"
            
            //number with difficulty + 1 digits
            result = arc4random_uniform(9) + 1
            for _ in 1...difficulty
            {
                result = result * 10 + arc4random_uniform(10)
            }
            
            let max = UInt32(sqrt(Double(result)))
            
            //number less than sqrt
            op1 = arc4random_uniform(max - 1) + 2
            op2 = result / op1
            result = op1 * op2
            
        default:
            
            opStr = "/"
            
            //number with difficulty digits
            result = arc4random_uniform(9) + 1
            if difficulty > 1
            {
                for _ in 1...difficulty - 1
                {
                    result = result * 10 + arc4random_uniform(10)
                }
            }
            
            op2 = arc4random_uniform(9) + 1
            if difficulty > 1
            {
                for _ in 1...difficulty - 1
                {
                    op2 = op2 * 10 + arc4random_uniform(10)
                }
            }

            op1 = result * op2
        }
        
        var resultStr = String(result)
        
        answer = ""
        
        if resultStr.count > 1
        {
            let i = arc4random_uniform(UInt32(resultStr.count - 1))
            let index = resultStr.index(resultStr.startIndex, offsetBy: Int(i))
            answer.append(resultStr[index])
            resultStr.replaceSubrange(index...index, with: "?")
        }
        
        else
        {
            answer.append(resultStr)
            resultStr = "?"
        }
        
        print("\(op1) \(opStr) \(op2) = \(resultStr)")
        question.text="\(op1) \(opStr) \(op2) = \(resultStr)"
        
        print(answer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue"{
            if let nextViewController = segue.destination as? ResultViewController{
                nextViewController.score = Int(score)
                nextViewController.totalTime = totalTimer
                nextViewController.mode = mode
            }
        }
        
    }

}
extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_OneComponent8,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let grayColorSpace = CGColorSpaceCreateDeviceGray()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: grayColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
                                        return nil
        }
        
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
}

