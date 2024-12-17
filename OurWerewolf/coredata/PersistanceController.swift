
import CoreData

class PersistenceController {
	static let shared = PersistenceController()
	
	let persistentContainer: NSPersistentContainer
	
	init() {
		persistentContainer = NSPersistentContainer(name: "UserDataModel")
		persistentContainer.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
}
