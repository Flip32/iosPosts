//
//  FormUserView.swift
//  IesbSocial
//
//  Created by Filipe Lopes on 15/09/21.
//

import SwiftUI

struct FormUserView: View {
    
    @ObservedObject
    var userViewModel: UserViewModel
    
    @State private var showMessage = false
    @State private var name = ""
    @State private var email = ""
    
    var body: some View{
        VStack(alignment: .leading, spacing: nil){
            Form {
                TextField("Nome", text: $name)
                TextField("Email", text: $email)
            }
        }
        Button("Salvar"){
            // TODO - Resolver questao do id
            userViewModel.addUser(user: User(id: 1,name: name, email: email), bindingMsg: $showMessage)
            showMessage = true
        }
        .alert(isPresented: $showMessage){
            if let error = userViewModel.error {
                return Alert(title: Text("Oops!"), message: Text(error), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Sucesso"), message: Text("Usuário salvo com sucesso"), dismissButton: .default(Text("OK")))
            }
        }
        
    }
}
