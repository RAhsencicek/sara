import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // Telefon numarasına doğrulama kodu gönderme
    func sendVerificationCode(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let verificationID = verificationID {
                completion(.success(verificationID))
            }
        }
    }
    
    // Doğrulama kodunu kontrol etme ve giriş yapma
    func verifyCode(_ code: String, verificationID: String, completion: @escaping (Result<User, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        auth.signIn(with: credential) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let firebaseUser = result?.user {
                // Kullanıcı modelini oluştur
                let user = User.fromFirebaseUser(firebaseUser)
                
                // Firestore'a kaydet
                self?.saveUserToFirestore(user, uid: firebaseUser.uid) { result in
                    switch result {
                    case .success(let savedUser):
                        completion(.success(savedUser))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // Kullanıcıyı Firestore'a kaydetme
    private func saveUserToFirestore(_ user: User, uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { [weak self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if snapshot?.exists == true {
                // Kullanıcı zaten var, güncelle
                userRef.updateData([
                    "updatedAt": Date()
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            } else {
                // Yeni kullanıcı oluştur
                userRef.setData(user.toFirestore()) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            }
        }
    }
    
    // Çıkış yapma
    func signOut() throws {
        try auth.signOut()
    }
    
    // Mevcut kullanıcıyı alma
    var currentUser: User? {
        return auth.currentUser.map { User.fromFirebaseUser($0) }
    }
}
