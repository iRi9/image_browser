//
//  DetailCommentProvider.swift
//  Image Browser
//
//  Created by Giri Bahari on 05/02/23.
//

import Foundation
import CoreData

protocol DetailCommentProviderDelegagte {
    func saveDetailImageComment(_ detailComment: DetailComment, completion: @escaping(_ status: Bool) -> Void)
    func getDetailComments(by imageId: Int64, completion: @escaping(_ comments: [DetailComment]) -> Void)
    func deleteDetailImageComment(by id: UUID, completion: @escaping(_ status: Bool) -> Void)
}

class DetailCommentProvider: DetailCommentProviderDelegagte {
    private let backgroundContext: NSManagedObjectContext
    private let commentEntity = "Comments"

    init(backgroundContext: NSManagedObjectContext = CoreDataManager.shared.backgroundContext) {
        self.backgroundContext = backgroundContext
    }

    func saveDetailImageComment(_ detailComment: DetailComment, completion: @escaping(_ status: Bool) -> Void) {
        let taskContext = backgroundContext
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: commentEntity, in: taskContext) {
                let comments = NSManagedObject(entity: entity, insertInto: taskContext)
                comments.setValue(detailComment.id, forKey: "id")
                comments.setValue(detailComment.imageId, forKey: "imageId")
                comments.setValue(detailComment.authorInitialName, forKey: "authorInitialName")
                comments.setValue(detailComment.authorName, forKey: "authorName")
                comments.setValue(detailComment.comment, forKey: "comment")
                comments.setValue(detailComment.createdAt, forKey: "createdAt")
                do {
                    try taskContext.save()
                    completion(true)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                    completion(false)
                }

            }
        }
    }

    func getDetailComments(by imageId: Int64, completion: @escaping(_ comments: [DetailComment]) -> Void) {
        let taskContext = backgroundContext
        taskContext.perform { [weak self] in
            guard let self = self else { return }
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.commentEntity)
            fetchRequest.predicate = NSPredicate(format: "imageId == \(imageId)")
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let results = try taskContext.fetch(fetchRequest)
                var detailComments = [DetailComment]()

                for result in results {
                    let detailComment = DetailComment(id: result.value(forKey: "id") as! UUID,
                                                      imageId: result.value(forKey: "imageId") as! Int64,
                                                      authorInitialName: result.value(forKey: "authorInitialName") as! String,
                                                      authorName: result.value(forKey: "authorName") as! String,
                                                      comment: result.value(forKey: "comment") as! String,
                                                      createdAt: result.value(forKey: "createdAt") as! Date)
                    detailComments.append(detailComment)
                }
                completion(detailComments)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func deleteDetailImageComment(by id: UUID, completion: @escaping(_ status: Bool) -> Void) {
        let taskContext = backgroundContext
        taskContext.perform { [weak self] in
            guard let self = self else { return }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.commentEntity)
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeCount

            if let batchDeleteResult = try? taskContext.execute(deleteRequest) as? NSBatchDeleteResult, batchDeleteResult.result != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

struct DetailComment {
    let id: UUID
    let imageId: Int64
    let authorInitialName: String
    let authorName: String
    let comment: String
    let createdAt: Date
}
