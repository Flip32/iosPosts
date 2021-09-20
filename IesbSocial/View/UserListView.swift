import SwiftUI

struct UserListView: View {
    
    @ObservedObject
    var viewModel: UserViewModel
    
    @StateObject
    var postViewModel = PostViewModel()
    
    @State
    private var showForm = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    loading()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: PostListView(user: user)) {
                                VStack(alignment: .leading) {
                                    Text(user.name).font(.title2)
                                    Text(user.email).font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Usuários")
            .navigationBarItems(
                            trailing: Button("\(Image(systemName: "person.crop.circle.badge.plus"))") {
                                showForm.toggle()
                            }.font(Font.title.weight(.bold))
                        )
        }
        .environmentObject(postViewModel)
        .onAppear {
            viewModel.newFetchUsers()
            
        }
        .sheet(isPresented: $showForm) {
            FormUserView(userViewModel: UserViewModel())
        }
    }
    
    @ViewBuilder
    private func loading() -> some View {
        VStack {
            ProgressView()
            Text("Aguarde... carregando...")
        }
    }
}
