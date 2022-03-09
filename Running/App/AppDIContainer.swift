//
//  AppDIContainer.swift
//  Running
//
//  Created by Maxime Maheo on 08/03/2022.
//

final class AppDIContainer {

    // MARK: - Services

    private lazy var healthKitService: HealthKitServiceProtocol = {
        HealthKitService()
    }()
    private lazy var formatterService: FormatterServiceProtocol = {
        FormatterService()
    }()
    private lazy var databaseService: DatabaseServiceProtocol = {
        DatabaseService()
    }()
    private lazy var importService: ImportServiceProtocol = {
        ImportService(healthKitService: healthKitService,
                      databaseService: databaseService)
    }()
    
    // MARK: - Containers
    
    lazy var analyseDIContainer: AnalyseDIContainerProtocol = {
        let dependencies = AnalyseDIContainer.Dependencies(healthKitService: healthKitService)
        
        return AnalyseDIContainer(dependencies: dependencies)
    }()
    lazy var settingsDIContainer: SettingsDIContainerProtocol = {
        let dependencies = SettingsDIContainer.Dependencies(formatterService: formatterService,
                                                            importService: importService,
                                                            databaseService: databaseService)
        
        return SettingsDIContainer(dependencies: dependencies)
    }()
}
