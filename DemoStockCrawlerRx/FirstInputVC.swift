//
//  FirstInputVC.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8 4:23 PM.
//

import UIKit
import RxSwift
import RxCocoa

class FirstInputVC: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    private let datePicker = UIDatePicker()
    
    private let viewModel = FirstInputVM()
    
    private var task: Task<Void, Never>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        bindings()
    }
    // MARK: - Binding Use RxMoya
    func bindings() {
        viewModel.completeGetDataObs.subscribe(with: self) { owner, firstModel in
//            let vc = ShowStockVC(data: firstModel)
            let vc = ShowStockDiffableVC(data: firstModel)
            Tools.presentWithUINavigationOnTop(vc)
        }.disposed(by: disposeBag)
    }

    // MARK: - Use Async/Await
    func fetchData() {
        Task.detached { @MainActor in
            self.task = Task {
                do {
                    try await self.viewModel.getData(dateStr: self.textField.text ?? "")
//                    let vc = ShowStockVC(data: self.viewModel.data)
                    let vc = ShowStockDiffableVC(data: self.viewModel.data)
                    Tools.presentWithUINavigationOnTop(vc)
                } catch APIError.message(let msg) {
                    Tools.showMessage(title: "Notice", message: msg, buttonList: ["got it"], completion: nil)
                } catch APIError.cancel {
                    print("API Cancel do notthing")
                } catch let error {
                    print(error)
                    Tools.showMessage(title: "Notice", message: error.localizedDescription, buttonList: ["got it"], completion: nil)
                }
            }
        }
    }

    @IBAction func confirmBtnPressed(_ sender: Any) {
        guard textField.text != "" else {
            Tools.showMessage(title: "Notice", message: "please input Date", buttonList: ["got it"])
            return
        }
        //MARK: Async/await FetData
//        fetchData()
        //MARK: Moya FetData
        viewModel.moyaGetData(dateStr: self.textField.text ?? "")
    }
    

}

// MARK: - DatePicker Created
extension FirstInputVC {
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        // 加入toolbar的按鈕跟中間的空白
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(submit(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel(_:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        // 設定toolBar可以使用
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        // assign date picker to the text field
        // setup date picker
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        self.datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        
        textField.inputView = datePicker
        
        
    }
    
    @objc func submit(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        if self.textField.text == "" {
            
            self.textField.text = formatter.string(from: Date())
        }else{
            let dateString = self.textField.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            guard let date = dateFormatter.date(from: dateString) else {
                self.textField.resignFirstResponder()
                return }
            
            self.textField.text = formatter.string(from: date)
        }
        textField?.resignFirstResponder()
    }
    @objc func cancel(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { [self] in
            textField?.resignFirstResponder()
        }
    }
    
    /// DatePicker value change
    @objc private func datePickerValueChanged(sender: UIDatePicker){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        var text: String = ""
        text = formatter.string(from: sender.date)
        self.textField.text = text
        
    }
}
