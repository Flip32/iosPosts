import SwiftUI

struct UserListView: View {
    
    @ObservedObject
    var viewModel: UserViewModel
    
    @StateObject
    var postViewModel = PostViewModel()
    
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
        }
        .environmentObject(postViewModel)
        .onAppear {
            viewModel.newFetchUsers()
            
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
