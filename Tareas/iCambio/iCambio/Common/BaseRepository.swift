//
//  BaseRepository.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 02/05/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import RxFirebase

class BaseRepository {
    let db = Firestore.firestore()
    let storage = Storage.storage(url: "gs://icambio-0.appspot.com")
    
    init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
}
