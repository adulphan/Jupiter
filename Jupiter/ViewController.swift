//
//  ViewController.swift
//  Jupiter
//
//  Created by adulphan youngmod on 11/8/18.
//  Copyright © 2018 goldbac. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class ViewController: UIViewController, CoreDataForAdmin, OperationCloudKit {
    var accountsDictionary: [String : Account] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        
        let predicate = NSPredicate(value: true)

        let userQuery = CKQuery(recordType: "UserID", predicate: predicate)
        CloudKit.publicDatabase.perform(userQuery, inZoneWith: nil) { (records, error) in
            if error != nil { print(error!) }
            if records?.count != 0 {
                for record: CKRecord in records! {
                    print(record.recordType," : ",record.recordID.recordName)
                    
                    let reference = record.value(forKey: "systemUser") as! CKReference
                    print(reference.recordID.recordName)
                }
            } else {
                print("no user")
            }
        }

    
        
        

        
        
 
//        let recordID = CKRecordID(recordName: "_65ba514557c3b89ea6e413f8a376330c")
//        let lookupInfo = CKUserIdentityLookupInfo(userRecordID: recordID)
//
//        let operation = CKFetchShareParticipantsOperation(userIdentityLookupInfos: [lookupInfo])
//        operation.shareParticipantFetchedBlock = { participant in
//            print(participant.userIdentity.userRecordID?.recordName ?? "no name", " is found")
//            print(participant)
//            let shareRecordID = CKRecordID(recordName: "Share-D23BAE3D-7C08-44EA-9BA8-214BE40758BD", zoneID: CloudKit.financialDataZoneID)
//
//            CloudKit.privateDatabase.fetch(withRecordID: shareRecordID) { (record, error) in
//                if error != nil { print(error!) }
//                let share = record as! CKShare
//                share.addParticipant(participant)
//
//                CloudKit.privateDatabase.save(share, completionHandler: { (record, error) in
//                    if error != nil { print(error!) }
//
//                    print("participant is added")
//                })
//
//            }
//
//
//        }
//        operation.fetchShareParticipantsCompletionBlock = { error in
//            if error != nil { print(error!) }
//            print("finished")
//
//        }
//
//        CKContainer.default().add(operation)
        
        
        
//        let record = CKRecord(recordType: "Company")
//        let anotherRecord = CKRecord(recordType: "Company")
//
//        let share = CKShare(rootRecord: record)
//
//        let anotherShare = CKShare(rootRecord: anotherRecord)
//
//        share.addParticipant(<#T##participant: CKShareParticipant##CKShareParticipant#>)
//        print(share.owner)
//
//        print(anotherShare.owner)
        
//        let participant = share.owner
//        print(participant.description)

//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.requiresSecureCoding = true
//        participant.encode(with: archiver)
//        archiver.finishEncoding()
//
//
//        let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
//        unarchiver.requiresSecureCoding = true
//
//        let decoded = CKShareParticipant(coder: unarchiver)
//
//        print("")
//        print(decoded?.description ?? "no description")
        
        
//
//        let record = CKRecord(recordType: "Transaction")
//        record.setValue("public transaction", forKey: "name")
//
//        CloudKit.publicDatabase.save(record) { (record, error) in
//            if error != nil { print(error!) }
//            print(record?.recordID.recordName ?? "no name", " is saved to public database")
//        }
        
        
//
//        let record = CKRecord(recordType: "Company")
//        let share = CKShare(rootRecord: record)
//
//        print(share.owner)
//
//        let current = share.currentUserParticipant
//
//        share.addParticipant(current!)
        
//        let shareURL = URL(string: "https://www.icloud.com/share/03VcwrrhWPpTxTC-StBbBeFMA")!
//        let fetchShareOperation = CKFetchShareMetadataOperation(shareURLs: [shareURL])
//
//        fetchShareOperation.perShareMetadataBlock = { (_,metaData,error) in
//            if error != nil { print(error!) }
//            print(metaData ?? "no meta")

//            let acceptShare = CKAcceptSharesOperation(shareMetadatas: [metaData!])
//            acceptShare.perShareCompletionBlock = { (_,share,error) in
//                if error != nil { print(error!) }
//
//                if let share = share {
//
//
//
//                }
//
//            }
//
//            CKContainer.default().add(acceptShare)
//        }
//
//        fetchShareOperation.fetchShareMetadataCompletionBlock = { error in
//            if error != nil { print(error!) }
//            print("finished")
//        }
//
//        CKContainer.default().add(fetchShareOperation)
//
        
//        let container = CKContainer.default()
//        container.fetchUserRecordID() {
//            recordID, error in
//            if error != nil {
//                print(error!.localizedDescription)
//
//            } else {
//                print("fetched ID \(recordID?.recordName)")
//            }
//        }
        
//        CloudKit.sharedDatabase.
//
//        let recordID = CKRecordID(recordName: "Share-D23BAE3D-7C08-44EA-9BA8-214BE40758BD", zoneID: CloudKit.financialDataZoneID)
//
//        CloudKit.sharedDatabase.fetch(withRecordID: recordID) { (record, error) in
//            if error != nil { print(error!) }
//
//            print(record?.recordID.recordName ?? "nope", " is fetched")
//            //let share = record as! CKShare
//
//        }
        
        
        
//        CloudKit.privateDatabase.fetch(withRecordID: recordID) { (record, error) in
//            if error != nil { print(error!) }
//
//            print(record?.recordID.recordName ?? "nope", " is fetched")
//            //let share = record as! CKShare
//
//        }
        
        
        
        
    
        
        
        
        
        

//        let company = workingCompany!
//        let record = company.recordToUpload()
//
//        let share = CKShare(rootRecord: record)
//
//        let operation = CKModifyRecordsOperation()
//        operation.database = CloudKit.privateDatabase
//        operation.recordsToSave = [record, share]
//
//        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedIDs, error) in
//            if error != nil { print(error!) }
//            print("finished")
//
//
//
//        }
//
//        CloudKit.privateDatabase.add(operation)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loopTransaction(interval: Double, times: Int) {
        
        var count: Int = 0
        _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            print(Date(), "  count : \(count)")
            count += 1
            
            let wallet = self.ExistingAccount(name: "Wallet")!
            let grocery = self.ExistingAccount(name: "Grocery")!
            
            let transaction = wallet.transactions.first!
            CoreData.context.delete(transaction)

            let update = wallet.transactions.last!
            update.name = "Update: " + Date().description

            
            let newTransaction = Transaction(context: CoreData.context)
            newTransaction.name = "Creates: " + Date().description
            newTransaction.identifier = UUID()
            newTransaction.date = Date()
            newTransaction.modifiedLocal = Date()
            newTransaction.accounts = [wallet, grocery]
            newTransaction.flows = [-888, 888]
 
            self.saveCoreData()

            if count == times {
                
//                let wallet = self.ExistingAccount(name: "Wallet")!
//
//                let transaction = wallet.transactions.last!
//                transaction.name = "New name 33"
//
//                self.saveCoreData()
//
//                CoreData.context.delete(transaction)
//
                //self.saveCoreData()
                
                print("finish timer loop")
                t.invalidate()
                
            }
            
        }
    }

}

