//
//  SwiftTest.swift
//  ZDFramework
//
//  Created by ziga drole on 2/1/15.
//  Copyright (c) 2015 ziga drole. All rights reserved.
//

import Foundation

/* MODULES
-A module is a single unit of code distribution—a framework or application that is built and shipped as a single unit and that can be imported by another module with Swift’s import keyword.
-Each build target (such as an app bundle or framework) in Xcode is treated as a separate module in Swift. If you group together aspects of your app’s code as a stand-alone framework—perhaps to encapsulate and reuse that code across multiple applications—then everything you define within that framework will be part of a separate module when it is imported and used within an app, or when it is used within another framework.

-Xcode 6 does not support building distributable Swift frameworks at this time and that Apple likely won't build this functionality into Xcode until its advantageous for then to do so. Right now, Frameworks are meant to be embedded in your app's project, rather than distributed.

*/
import Foundation

public class SwiftTest {
 
    public class func printTest (){
        println("Testing swift function inside ZDFramework ");
    }
    
}