//
//  Platform.swift
//  Nante
//
//  Created by 谷内洋介 on 2023/09/03.
//

import Foundation


struct PlatformSelector: Selector {
    func select(host: String) -> Platform?{
        switch host {
        case "podcasts.apple.com":
            return ApplePodCast()
        default:
            return nil
        }
    }
}
