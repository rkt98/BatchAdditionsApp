//
//  ViewController.swift
//  BatchAdditions
//
//  Created by Ryan Tansey on 5/06/23.
//

import UIKit
import TabularData

class ViewController: UIViewController {

    @IBOutlet weak var batchSizeTextField: UITextField!

    
    @IBOutlet weak var targetBrixTextField: UITextField!
    
    @IBOutlet weak var measuredBrixTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var bucketOne: UIImageView!
    
    @IBOutlet weak var bucketTwo: UIImageView!
    
    @IBOutlet weak var bucketThree: UIImageView!
    
    @IBOutlet weak var bucketFour: UIImageView!
    
    @IBOutlet weak var bucketFive: UIImageView!
    
    @IBOutlet weak var bucketSix: UIImageView!
    
    @IBOutlet weak var bucketSeven: UIImageView!
    
    @IBOutlet weak var bucketEight: UIImageView!
    
    @IBOutlet weak var plusSign: UIImageView!
    
    @IBOutlet weak var bucketRemainderLabel: UILabel!
    
    var sucroseArray: sucroseArrays!
    
    @IBOutlet weak var bucketInfoLabel: UILabel!
    
    
    @IBOutlet weak var bigAdditionPlus: UIImageView!
    
    @IBOutlet weak var bigAdditionLabel: UILabel!
    //based off logical sizes found online min is iphone 10
    let minScreenSizeWidth: CGFloat = 375
    let minScreenSizeHeight: CGFloat = 812
    
    //var screenRect: CGRect!
    var screenSizeWidth, screenSizeHeight: CGFloat!
    
    var small: Bool!
    
    var batchSizeText, targetBrixText, measuredBrixText: String!
    
    var batchSize, targetBrix, measuredBrix: Double!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sucroseArray = sucroseArrays()
        showHideBuckets(hidden: true)
        resultLabel.text = ""
        showHideAddition(hidden: true)
        setupKeyboardToolbars()
       
        screenSizeWidth = UIScreen.main.bounds.width
        screenSizeHeight = UIScreen.main.bounds.height
        
        if((screenSizeWidth <= minScreenSizeWidth) || (screenSizeHeight <= minScreenSizeHeight))
        {
            small = true;
        }
        else
        {
            small = false;
        }
        
    }

    @IBAction func calculateButtonPressed(_ sender: Any) {
        
        showHideAddition(hidden: true)
        showHideBuckets(hidden: true)
        
        //let defaultValue: String = "0.0"
        
        batchSizeText = batchSizeTextField.text!
        targetBrixText = targetBrixTextField.text!
        measuredBrixText = measuredBrixTextField.text!
        
        batchSize = Double(batchSizeText) ?? 0.0
        targetBrix = Double(targetBrixText) ?? 0.0
        measuredBrix = Double(measuredBrixText) ?? 0.0
        
        resultLabel.text = ""
        resultLabel.isHidden = false
        resultLabel.textColor = UIColor.systemRed
        
        if(batchSize != 0 && targetBrix != 0 && measuredBrix != 0)
        {
            if(targetBrix < 70)
            {
                if(measuredBrix < 70)
                {
                    if(!(targetBrix > measuredBrix))
                    {
                        
                        let addition = calculateAddition(_batchSize: batchSize, _targetBrix: targetBrix, _measuredBrix: measuredBrix)
                        
                        
                        if(addition <= 104)
                        {
                            if(small)
                            {
                                showHideBuckets(hidden: true)
                                showHideAddition(hidden: false)
                                resultLabel.text = ""
                                bigAdditionLabel.text = "\(Int(addition)) L"
                            }
                            else
                            {
                                showHideBuckets(hidden: false)
                                setBuckets(addition: Int(addition))
                                resultLabel.text = "     Water addition = \(Int(addition)) L"
                                resultLabel.textColor = UIColor.lightGray
                            }

                        }
                        else
                        {
                            showHideAddition(hidden: false)
                            resultLabel.text = ""
                            bigAdditionLabel.text = "\(Int(addition)) L"
                        }
                        
                    }
                    else
                    {
                        resultLabel.text = "Measured brix is less than target no water needed"
                        
                    }
                }
                else
                {
                    resultLabel.text = "Measured brix must be less than 70"
                    
                }
            }
            else
            {
                resultLabel.text = "Target brix must be less than 70"
                
            }
        }
        else if(batchSizeText.isEmpty || measuredBrixText.isEmpty || targetBrixText.isEmpty)
        {
            var errorString: String = "Please enter value for: "
            
            
            if(batchSizeText.isEmpty)
            {
                errorString = errorString + "[Batch Size] "
            }
            
            if(measuredBrixText.isEmpty)
            {
                errorString = errorString + "[Measured Brix] "
            }
            
            if(targetBrixText.isEmpty)
            {
                errorString = errorString + "[Target Brix] "
            }
            
        }
        else
        {
            resultLabel.text = "Batch size, target brix & measured brix must be greater than 0"
            
        }
        
    }
    
    /*
        Index   0 = target Density
                1 = target brix
                2 = measured density
                3 = measured brix
                4 = target batchsize
                5 = water addition step 1 abs
                6 = batch size step 2
                7 = water addition step 2 abs
                8 = batch size step 3
                9 = water addition final
     */
    
    func calculateAddition(_batchSize: Double, _targetBrix: Double, _measuredBrix: Double) -> Double
    {
        var values = [Double](repeating: 0.0, count: 10)
        values[0] = sucroseArray.getDensity(targetBrix: _targetBrix)
        values[1] = _targetBrix
        values[2] = sucroseArray.getDensity(targetBrix:_measuredBrix)
        values[3] = _measuredBrix
        values[4] = _batchSize
        
        values[5] = abs(((values[3]*values[4]*values[2])/(values[0]*values[1]))-values[4])
        values[6] = (values[4] - values[5])
        values[7] = abs(((values[3]*values[6]*values[2])/(values[0]*values[1]))-values[6])
        values[8] = (values[6] + (values[5]-values[7]))
        values[9] = abs((values[3]*values[8]*values[2])/(values[0]*values[1]))-values[8]
        
        print(values)
        
        return round(values[9])
    }
    
    func setBuckets (addition: Int)
    {
        showHideBuckets(hidden: false)
        let remainder = addition % 13
        let buckets = (addition - remainder)/13
        print(addition)
        let activeColour: UIColor = UIColor.systemRed;
        
        if(remainder > 0)
        {
            plusSign.tintColor = activeColour
            bucketRemainderLabel.text = "\(remainder) L"
            bucketRemainderLabel.textColor = activeColour;
        }
        else
        {
            plusSign.isHidden = true
            bucketRemainderLabel.text = ""
        }
        
        if(buckets > 0)
        {
            switch buckets {
            case 1:
                
                bucketOne.tintColor = activeColour
            case 2:
                
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
            case 3:
                
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
            case 4:
                
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
                bucketFour.tintColor = activeColour
            case 5:
                
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
                bucketFour.tintColor = activeColour
                bucketFive.tintColor = activeColour
            case 6:
                
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
                bucketFour.tintColor = activeColour
                bucketFive.tintColor = activeColour
                bucketSix.tintColor = activeColour
            case 7:
                plusSign.tintColor = activeColour
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
                bucketFour.tintColor = activeColour
                bucketFive.tintColor = activeColour
                bucketSix.tintColor = activeColour
                bucketSeven.tintColor = activeColour
            case 8:
                bucketOne.tintColor = activeColour
                bucketTwo.tintColor = activeColour
                bucketThree.tintColor = activeColour
                bucketFour.tintColor = activeColour
                bucketFive.tintColor = activeColour
                bucketSix.tintColor = activeColour
                bucketSeven.tintColor = activeColour
                bucketEight.tintColor = activeColour
            default:
                break
            }
        }
    }
    
    func showHideBuckets (hidden: Bool)
    {
        bucketInfoLabel.isHidden = hidden
        bucketInfoLabel.textColor = UIColor.lightGray
        plusSign.tintColor = UIColor.lightGray
        plusSign.isHidden = hidden
        bucketRemainderLabel.text = ""
        bucketRemainderLabel.textColor = UIColor.lightGray
        bucketOne.isHidden = hidden
        bucketOne.tintColor = UIColor.lightGray
        bucketTwo.isHidden = hidden
        bucketTwo.tintColor = UIColor.lightGray
        bucketThree.isHidden = hidden
        bucketThree.tintColor = UIColor.lightGray
        bucketFour.isHidden = hidden
        bucketFour.tintColor = UIColor.lightGray
        bucketFive.isHidden = hidden
        bucketFive.tintColor = UIColor.lightGray
        bucketSix.isHidden = hidden
        bucketSix.tintColor = UIColor.lightGray
        bucketSeven.isHidden = hidden
        bucketSeven.tintColor = UIColor.lightGray
        bucketEight.isHidden = hidden
        bucketEight.tintColor = UIColor.lightGray
    }
    
    func showHideAddition(hidden: Bool) {
        bigAdditionPlus.isHidden = hidden
        bigAdditionLabel.text = ""
        
    }
    
    func setupKeyboardToolbars()
    {
        let keyboardToolBar = UIToolbar()
        
        keyboardToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.done,target:self, action: #selector(doneClicked))
        
        doneButton.tintColor = UIColor.systemRed
        keyboardToolBar.setItems([doneButton], animated: false)
        
        batchSizeTextField.inputAccessoryView = keyboardToolBar
        targetBrixTextField.inputAccessoryView = keyboardToolBar
        measuredBrixTextField.inputAccessoryView = keyboardToolBar
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
        if(!batchSizeTextField.text!.isEmpty && !measuredBrixTextField.text!.isEmpty && !targetBrixTextField.text!.isEmpty)
        {
            calculateButtonPressed(self)
        }
    }
}

