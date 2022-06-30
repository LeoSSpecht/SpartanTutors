//
//  classSelectionView.swift
//  SpartanTutors
//
//  Created by Leo on 6/30/22.
//

import SwiftUI

struct classSelectionView: View {
    @ObservedObject var allClassesViewModel:classSelectionViewModel
    var body: some View {
        List(allClassesViewModel.classList){ classObject in
            Button(action: {allClassesViewModel.update_selection(classObject)}){
                classSelectionRow(classObject: classObject)
            }
        }
    }
}

struct classSelectionRow: View{
    var classObject: classSelection
    var body: some View{
        HStack{
            Text(classObject.id)
            if classObject.isSelected{
                Spacer()
                Image(systemName: "checkmark")
            }
        }
    }
}
