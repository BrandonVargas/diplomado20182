//
//  ChatRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 26/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import RxSwift
import Firebase
import CodableFirebase

class ChatRepository: BaseRepository, ChatRepositoryDelegate{
    
    private var disposeBag = DisposeBag()
    
    func getChat(offerId: String) -> Observable<Chat> {
        return Observable.create({ observer in
            self.db.collection("chats")
            .whereField("offerId", isEqualTo: offerId)
            .rx
            .getDocuments()
            .map( { query in query.documents.first } )
            .subscribe(onNext: { document in
                if (document != nil) {
                    let chat: Chat = try! FirebaseDecoder().decode(Chat.self, from: document!.data())
                    observer.onNext(chat)
                } else {
                    observer.onError(RxError.noElements)
                }
            }, onError: { error in
                print("Hubo un error a obtener chat: \(error)")
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func getMessagesForChat(chatId: String) -> Observable<Array<Message>> {
        return Observable.create({ observer in
            self.db.collection("chats")
                .document(chatId)
                .collection("messages")
                .order(by: "createdAt")
                .rx
                .listen()
                .subscribe(onNext: { snap in
                    var messages = Array<Message>()
                    for doc in snap.documents {
                        let message = try! FirebaseDecoder().decode(Message.self, from: doc.data())
                        print("Message \(message.message) / \(message.senderId)")
                        messages.append(message)
                    }
                    observer.onNext(messages)
                }, onError: {error in
                    
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func sendMessage(chatId: String, message: Message) {
        var messageData = try! FirestoreEncoder().encode(message)
        messageData["createdAt"] = Timestamp()
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: messageData)
    }
    
    func createChat(offerId: String) -> Observable<Chat> {
        var chat = Chat(id: offerId, offerId: offerId)
        let chatData = try! FirestoreEncoder().encode(chat)
        return Observable.create({ observer in
            self.db.collection("chats")
                .rx
                .addDocument(data: chatData)
                .subscribe(onNext: { document in
                    self.addChatId(document.documentID).subscribe(onNext: {updated in
                        if (updated) {
                            chat.id = document.documentID
                            observer.onNext(chat)
                        } else {
                            observer.onError(RxError.unknown)
                        }
                    }).disposed(by: self.disposeBag)
                }, onError: { error in
                    print("Error al crear chat: \(error)")
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
    
    func addChatId(_ chatId: String) -> Observable<Bool> {
        return Observable.create({ observer in
            self.db.collection("chats")
                .document(chatId)
                .rx
                .updateData(["id": chatId])
                .subscribe(onNext: { _ in
                    observer.onNext(true)
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}

protocol ChatRepositoryDelegate {
    func getChat(offerId: String) -> Observable<Chat>
    func sendMessage(chatId: String, message: Message)
}
