/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import Flutter
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, FlutterSceneLifeCycleProvider {
    var sceneLifeCycleDelegate: FlutterPluginSceneLifeCycleDelegate =
        FlutterPluginSceneLifeCycleDelegate()

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        sceneLifeCycleDelegate.scene(
            scene,
            willConnectTo: session,
            options: connectionOptions
        )

        guard let windowScene = scene as? UIWindowScene else { return }
        if let window = self.window {
            window.frame = windowScene.coordinateSpace.bounds
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        sceneLifeCycleDelegate.sceneDidDisconnect(scene)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        sceneLifeCycleDelegate.sceneWillEnterForeground(scene)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        sceneLifeCycleDelegate.sceneDidBecomeActive(scene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        sceneLifeCycleDelegate.sceneWillResignActive(scene)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        sceneLifeCycleDelegate.sceneDidEnterBackground(scene)
    }

    func scene(
        _ scene: UIScene,
        openURLContexts urlContexts: Set<UIOpenURLContext>
    ) {
        sceneLifeCycleDelegate.scene(scene, openURLContexts: urlContexts)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        sceneLifeCycleDelegate.scene(scene, continue: userActivity)
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        sceneLifeCycleDelegate.windowScene(
            windowScene,
            performActionFor: shortcutItem,
            completionHandler: completionHandler
        )
    }
}
