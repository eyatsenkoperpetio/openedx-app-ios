//
//  AppDelegate.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import Core
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    
    private var assembler: Assembler?
    
    private var lastForceLogoutTime: TimeInterval = 0
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        initDI()
        
        Theme.Fonts.registerFonts()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RouteController()
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(forceLogoutUser),
            name: .onTokenRefreshFailed,
            object: nil
        )
        
        return true
    }
    
    private func initDI() {
        let navigation = UINavigationController()
        navigation.modalPresentationStyle = .fullScreen
        
        assembler = Assembler(
            [
                AppAssembly(navigation: navigation),
                NetworkAssembly(),
                ScreenAssembly()
            ],
            container: Container.shared
        )
    }
    
    @objc private func forceLogoutUser() {
        guard Date().timeIntervalSince1970 - lastForceLogoutTime > 5 else {
            return
        }
        lastForceLogoutTime = Date().timeIntervalSince1970
        
        Container.shared.resolve(AppStorage.self)?.clear()
        Container.shared.resolve(CoreDataHandlerProtocol.self)?.clear()
        window?.rootViewController = RouteController()
    }
    
}
