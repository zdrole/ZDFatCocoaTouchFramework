#!/bin/bash


#This code  is called before Xcode builds target ( new target is added and setted in main target as dependency).
#How to add new PRE BUILD - target
#1. project > target > ios > other > Aggregate
#2.  main target > build pahases > target dependencies > add new target / Aggregate

#This code is called two times : 1. Xcode makes build ( type= iphoneos OR iphoneos-simulator)
#                                2. Script makes build (xcodebuild command , type=other from XCode)
#Both times dependency is called but in  Xcode console LOG from this script is only from XCode
#For debug is removed DerivedData/ZDPods/Build/Products/Debug-iphonesimulator && Debug-iphoneos
#For release is removed DerivedData/ZDPods/Build/Products/Release-iphonesimulator && Release-iphoneos

TARGET_B_D="$TARGET_BUILD_DIR"
echo "Deleting all from path: $TARGET_B_D"
rm -rf $TARGET_B_D

