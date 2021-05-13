//
//  ViewController.swift
//  SAPDemoApp
//
//  Created by Dipak Pandey on 03/05/21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fruitDetail: FruitsDetail?
    var selectedFruit: Fruit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FruitCell", bundle: nil), forCellReuseIdentifier: "FruitCell")
        loadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let imageVC = segue.destination as? ImageViewController,
            segue.identifier == "showImageView" {
            imageVC.fruit = selectedFruit
        }
    }

    
    @IBAction func removeDuplicateAction(_ sender: Any) {
        let temArray: [String] = fruitDetail?.list ?? []
        let withoutDuplicate = Set(temArray)
        print("WithoutDuplicate: \(withoutDuplicate)")
    }
    
    private func loadData() {
        fruitDetail = getFruitDetail()
        fruitDetail?.fruits.sort(by: {$0.name < $1.name})
    }
    
    private func getFruitDetail() -> FruitsDetail? {
        if let url = Bundle.main.url(forResource: "Fruits", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FruitsDetail.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruitDetail?.fruits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath) as! FruitCell
        
        if let fruit = fruitDetail?.fruits[indexPath.row] {
            cell.lblName.text = fruit.name
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFruit = fruitDetail?.fruits[indexPath.row]
        self.performSegue(withIdentifier: "showImageView", sender: self)
    }
}
