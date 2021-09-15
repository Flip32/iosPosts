import SwiftUI

struct PostListView: View {
    
    @EnvironmentObject
    var viewModel: PostViewModel
    var user: User
    
    var body: some View {
        VStack {
            if viewModel.loading {
                loading()
            } else {
                List {
                    ForEach(viewModel.posts){ post in
                        VStack(alignment: .leading) {
                            Text(post.title).font(.title2)
                            Text(post.body).font(.subheadline)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .onAppear{
            viewModel.fetchPosts(for: user)
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
