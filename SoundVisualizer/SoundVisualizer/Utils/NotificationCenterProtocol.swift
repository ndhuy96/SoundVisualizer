//
//  NotificationCenterProtocol.swift
//  SoundVisualizer
//
//  Created by Nguyen Duc Huy on 4/11/20.
//  Copyright © 2020 sun. All rights reserved.
//

public typealias Observer = (_ name: String, _ data: Any) -> Void

protocol NotificationCenterProtocol{
    func addObserver(forName name: String, usingBlock block: @escaping Observer)
    func removeObserver(forName name: String)
}
