//
//  classSelectionViewModel.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import Foundation
import FirebaseFirestore

class classSelectionViewModel:ObservableObject{
    @Published var model = classSelectionList()
    private var db = Firestore.firestore()
    
    init(){
        getAllOfferedClasses()
    }
    
    var classList:Array<classSelection>{
        model.selectedClasses
    }
    
    var onlySelected:Array<String>{
        let filtered_classes = model.selectedClasses.filter({$0.isSelected})
        return filtered_classes.map{
            $0.id
        }
    }
    
    func update_selection(_ selection:classSelection){
        model.select(selection)
    }
    
    func getAllOfferedClasses(){
        db.collection("classesAvailable").document("classes").getDocument{result, err in
            if let result = result, result.exists{
                let data = result.data()!
                let availableClasses = data["classes"] as! Array<String>
                let classesAvailable = availableClasses.map{ selection in
                    classSelection(id: selection)
                }
                self.model.create(classesAvailable)
            }
            else{
                print("No available classes were found")
            }
        }
    }
}

struct classSelection:Identifiable{
    var id: String
    var isSelected = false
}

struct classSelectionList{
    var selectedClasses: Array<classSelection> = []
    
    mutating func create(_ available:Array<classSelection>){
        selectedClasses = available
    }
    
    mutating func select(_ selection:classSelection){
        if let chosenIndex = selectedClasses.firstIndex(where: {$0.id == selection.id}){
            self.selectedClasses[chosenIndex].isSelected.toggle()
        }
    }
}
