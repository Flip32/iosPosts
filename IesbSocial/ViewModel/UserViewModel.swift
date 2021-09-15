import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    
    private let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    @Published
    private(set) var loading = false
    
    @Published
    private(set) var users = [User]() {
        didSet {
            loading = false
        }
    }
    
    @Published
    private(set) var error: String?
    
    private var userCancellationToken: AnyCancellable?
    
    
    func newFetchUsers() {
        if let url = URL(string: "\(kBaseURL)/users") {
            let session = URLSession.shared
            let request = URLRequest(url: url)
            
            loading = true
            
            userCancellationToken = session.dataTaskPublisher(for: request)
                .tryMap(session.map(_:))
                .decode(type: [User].self, decoder: JSONDecoder())
                .breakpointOnError()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { self.sinkError($0) { self.loading = false }}) { self.users = $0 }
                
        }
    }
    

    func fetchUsers() {
        let session = URLSession.shared
        
        if let url = URL(string: "\(kBaseURL)/users") {
            session.dataTask(with: url) { (data, response, error) in
                if let resp = response as? HTTPURLResponse,
                   resp.statusCode >= 200, resp.statusCode < 300,
                   let json = data {
                    DispatchQueue.main.async {
                        self.users = try! JSONDecoder().decode([User].self, from: json)
                    }
                }
            }.resume()
        }
        
    }
    
    func addUser(user: User, bindingMsg: Binding<Bool>) {
        if let url = URL(string: "\(kBaseURL)/users") {
            
            let session = URLSession.shared
            var request = URLRequest(url:  url)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let body = try JSONEncoder().encode(user)
                loading = true
                
                session.uploadTask(with: request, from: body){ data, response, error in
                    DispatchQueue.main.async {
                        if let requestError = error {
                            self.error = requestError.localizedDescription
                        }
                        
                        guard let resp = response as? HTTPURLResponse,
                              resp.statusCode >= 200,
                              resp.statusCode < 300 else {
                            self.error = "Não foi possível salvar usuário"
                            return
                        }
                        self.users.append(user)
                        bindingMsg.wrappedValue = true
                    }
                }.resume()
            } catch {
                bindingMsg.wrappedValue = true
                self.error = "Não foi possível salvar usuário"
                return
            }
        }
    }
    
    
}
