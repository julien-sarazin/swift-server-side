//
//  Result.swift
//  Evocation
//
//  Created by Julien Sarazin on 26/01/2017.
//  Copyright © 2017 Digipolitan. All rights reserved.
//

import Foundation

open class Result<T> {
    public var metadata: [String: AnyObject]?
    public var data: T?
    public var error: Error?

    init(metadata: [String: AnyObject]? = nil, data: T? = nil, error: Error? = nil) {
        self.metadata = metadata
        self.data = data
        self.error = error
    }
}
