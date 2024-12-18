
import CoreData

class PersistenceController {
	let persistentContainer: NSPersistentContainer
	
	init() {
		persistentContainer = NSPersistentContainer(name: "UserDataModel")
		persistentContainer.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}
}
