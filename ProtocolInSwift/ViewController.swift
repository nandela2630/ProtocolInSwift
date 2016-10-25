//
//  ViewController.swift
//  ProtocolInSwift
//
//  Created by wflogin on 24/10/16.
//  Copyright © 2016 wflogin. All rights reserved.
//

import UIKit
import PassKit
class ViewController: UIViewController, CustomTableViewCellDelegate {

    @IBOutlet var tableView: UITableView!
    
    let stylesImagesArray = ["Style1","Style2","Style3","Style4","Style5","Style6"];
    
    let stylePriceArray = ["11.29","12.29","13.39","14.49","15.59","16.69"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //self.automaticallyAdjustsScrollViewInsets = false
    }

    
    func buyTapped(cell:CustomTableViewCell)
    {
    
        let indexPath = tableView.indexPath(for: cell) //as! NSIndexPath
        
        let item = stylePriceArray[(indexPath?.row)!] 
        
        print(item)
        
        
        payThroughApplePay(itemPrice: item)
        
        
        print("Tapped Buy Button")
        
    }
    
    
    //# MARK: - Pay
    func payThroughApplePay(itemPrice:String) {
        
        let paymentNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
        
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            // Pay is available!
            print("Apple pay is available")
            let request = PKPaymentRequest()
            request.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
            request.countryCode = "US"
            request.currencyCode = "USD"
            request.merchantIdentifier = "merchant.com.applePayDemoTest.company"
            request.merchantCapabilities = .capability3DS
            
            request.requiredShippingAddressFields = PKAddressField.postalAddress
            
            
            let wax = PKPaymentSummaryItem(label: "Item Price", amount: NSDecimalNumber(string:itemPrice))
            
            let discount = PKPaymentSummaryItem(label: "Discount", amount: NSDecimalNumber(string: "-1.00"))
            
            
            let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: "5.00"))
            
            
            let totalAmount = wax.amount.adding(discount.amount)
                .adding(shipping.amount)
            let total = PKPaymentSummaryItem(label: "To Sanvi", amount: totalAmount)
            request.paymentSummaryItems = [wax, discount, shipping, total]
            
            let viewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            viewController.delegate = self
            present(viewController, animated: true, completion: nil)
            
        }else{
            
            showAlert(title: "Pay is not available!", message: "Can't Make Payments from your device")
            
            
        }
    }

    
    //# MARK: - Show Alert Funnction
    func showAlert(title:String, message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive) { (alerAction) in
            
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true) {
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylesImagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! CustomTableViewCell
        
        cell.styleImageView.image = UIImage(named: stylesImagesArray[ indexPath.row])
        
        cell.priceLbl.text = "$\(stylePriceArray[indexPath.row])"
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}
extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        print("Did authorize : \(payment)")
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("Did finish")
        controller.dismiss(animated: true , completion: nil)
    }
    
    
    
    
}

