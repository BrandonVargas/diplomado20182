//
//  ChatViewControllwe.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 25/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift


class ChatViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let CELL_SENDER = "MessageSenderTableViewCell"
    let CELL_RECEIVER = "MessageReceiverTableViewCell"
    let disposeBag = DisposeBag()
    var chat: Chat? = nil {
        didSet {
            getMessagesForChat(chatId: (chat?.id ?? ""))
        }
    }
    var messageList: [Message] = [] {
        didSet {
            messagesTableView.reloadData()
        }
    }
    var offer: Offer? = nil
    let chatRepo = ChatRepository()
    
    fileprivate var recipientsUid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.dataSource = self
        chatRepo.getChat(offerId: (offer?.id ?? ""))
            .subscribe(onNext: { cht in
                self.chat = cht
            }, onError: { error in
                print("Error getting chat: \(error)")
                self.chatRepo.createChat(offerId: (self.offer?.id ?? ""))
                    .subscribe(onNext: { cht in
                        self.chat = cht
                    }, onError: { error in
                        print("Error creating chat: \(error)")
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        if let text = messageTextField.text {
            let message = Message(message: text, senderId: (Auth.auth().currentUser?.uid ?? ""))
            chatRepo.sendMessage(chatId: chat!.id, message: message)
        }
    }
    
    func getMessagesForChat(chatId: String) {
        chatRepo.getMessagesForChat(chatId: chatId)
            .subscribe(onNext: { mssgs in
                print("MessagesResponse: \(String(describing: mssgs))")
                self.messageList = mssgs
                print("MessagesResponse: \(String(describing: self.messageList))")
            }, onError: { error in
                print("Hubo un error al obtener los mensajes: \(error)")
            }).disposed(by: disposeBag)
    }
}

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messageList[indexPath.row]
        print("MessageCell: \(message.message) / \(indexPath.row)")
        if (message.senderId == Auth.auth().currentUser?.uid ?? ""){
            print("MessageCellSender: \(message.senderId)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_SENDER, for: indexPath) as? MessageSenderTableViewCell else {
                fatalError("The dequeued cell is not an instance of OfferTableViewCell.")
            }
            cell.messageLabel.text = message.message
            return cell
        } else {
            print("MessageCellReceiver: \(message.senderId)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_RECEIVER, for: indexPath) as? MessageReceiverTableViewCell else {
                fatalError("The dequeued cell is not an instance of OfferTableViewCell.")
            }
            cell.messageLabel.text = message.message
            return cell
        }
    }
}
