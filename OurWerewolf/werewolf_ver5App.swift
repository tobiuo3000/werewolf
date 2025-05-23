//
//  wolf_ver4App.swift
//  wolf_ver4
//
//  Created by Masanori Sudo on 2024/04/02.
//

import SwiftUI

@main
struct wolf_ver5App: App {
	let persistenceController = PersistenceController()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
				.environmentObject(GameStatusData())
				.environmentObject(GameProgress())
		}
	}
}

