//
//  ArticlesRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 02/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import CodableFirebase
import RxSwift

class ArticlesRepository: BaseRepository, ArticlesRepositoryDelegate {
    
    let disposeBag = DisposeBag()
    private let articlesSubject = PublishSubject<Article>()
    
    override init() {
        super.init()
    }
    
    func addArticle(article: Article) -> Observable<DocumentReference> {
        var articleData = try! FirestoreEncoder().encode(article)
        articleData["updatedAt"] = Timestamp()
        return db.collection("articles")
            .rx
            .addDocument(data: articleData)
    }
    
    func listenAriticlesUpdates(){
        db.collection("articles")
            .order(by: "updatedAt", descending: false)
            .rx
            .listen()
            .subscribe(onNext: { snapshot in
                print("New articles: \(snapshot.documentChanges.count)")
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New article: \(diff.document.data())")
                        let article: Article = try! FirestoreDecoder().decode(Article.self, from: diff.document.data())
                        self.articlesSubject.onNext(article)
                    }
                    if (diff.type == .modified) {
                        print("Modified article: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed article: \(diff.document.data())")
                    }
                }
            }, onError: { error in
                print("Error fetching snapshots: \(error)")
            }).disposed(by: disposeBag)
    }
    
    func uploadImages(_ imagesURLs: Array<String>, completion: @escaping (_ urls: Array<String>, _ error: Error?) -> Void) {
        var uploadedImagesUrls: Array<String> = []
        
        let uploadSingleCallback: (_: URL?, _ error: Error?) -> Void = { url, error in
            if let url = url {
                uploadedImagesUrls.append(url.absoluteString)
                if imagesURLs.count == uploadedImagesUrls.count {
                    completion(uploadedImagesUrls, nil)
                }
            } else {
                completion(uploadedImagesUrls, error)
            }
        }
        
        if (imagesURLs.count > 0) {
            for imageURL in imagesURLs {
                uploadImage(imageURL, completion: uploadSingleCallback)
            }
        } else {
            completion(uploadedImagesUrls, nil)
        }
    }
    
    func uploadImage(_ imageURL: String, completion: @escaping (_ url: URL?, _ error: Error?) -> Void )  {
        let storageRef = storage.reference().child("articles/\(imageURL.hashValue)")
        // Local file you want to upload
        let localFile = URL(string: imageURL)!
        
        // Create the file metadata
        let metadata = StorageMetadata(dictionary: ["contentType" : "image/jpeg"])
        //metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            snapshot.reference.downloadURL(completion: { (url, error) in
                completion(url, error)
            })
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    func getArticlesSubject() -> PublishSubject<Article> {
        return articlesSubject
    }
}

protocol ArticlesRepositoryDelegate {
    func addArticle(article: Article) -> Observable<DocumentReference>
    func listenAriticlesUpdates()
    func getArticlesSubject() -> PublishSubject<Article>
}
