################################################################################
#
# c.f. http://stackoverflow.com/questions/3520977/build-fat-static-library-device-simulator-using-xcode-and-sdk-4
#
# Version 2.7
#
# Latest Change:
# - Supports iPhone 5 / iPod Touch 5 (uses Apple's workaround to lipo bug)
# 
# Purpose:
#   Automatically create a Universal static library for iPhone + iPad + iPhone Simulator from within XCode
#
# Author: Adam Martin - http://twitter.com/t_machine_org
# Based on: original script from Eonil (main changes: Eonil's script WILL NOT WORK in Xcode GUI - it WILL CRASH YOUR COMPUTER)
############HOT TO RUN THIS XCODE SCRIPT FROM XCODE #############################
#
#Im not gona paste here Xcode run script.. sript have own repo for changes and it only "path linked"
#$SRCROOT         /our path to project
#dirname $SRCROOT  / dirname retuns path to file, in our case srcroot is folder so we go one folder back
#basename $file    / returns file name

#BUILDIND_WORSPACE_OR_PROJECT set to work correctly
#subPath="$(dirname $SRCROOT)"       #go one folder back from project directorij
#addPath= "$subPath/ZDStaticLibraryXcodeScript/ZDStaticLibraryXcodeScript.sh"     #go to script path
#echo $addPath      #run script
#################################################################################


set -e
set -o pipefail

#################[ Tests: helps workaround any future bugs in Xcode ]########
#
DEBUG_THIS_SCRIPT="true"

if [ $DEBUG_THIS_SCRIPT = "true" ]
then
echo "################################## ZIGAS ##################################################################"
echo "DEBUG: V XCODE VEDNO KO BUILDAS IZBER SIMULATOR - ZA DEVICE JE NEZNAN ERROR !!!!!"
echo "		 1.RUN:Debug universal framework: DerivedData/.../Products/Debug-universal"
echo "APPSTORE:  app more vsebovati samo iphoneOS release framework"
echo "		 1.RUN: Release iphoneOS framework_ DerivedData/.../Products/Release-iphoneos (edit sheme/run/release)..press run"
echo "		 2.ARCHIVE:Release iphoneOS framework_ DerivedData/<PROJECT_NAME>/Build/Intermediates/ArchiveIntermediates/<PROJECT_NAME>/IntermediateBuildFilesPath/UninstalledProducts/Release-iphoneos (Product/Archive)""
echo "################################# COMMAND GET ALL VARIABLES,BUILD SETTINGS ####################################"
echo "terminal: go to project.xcodeproj -> xcodebuild -project ZDFramework.xcodeproj -target ZDFramework -showBuildSettings"
#xcodebuild -project "${PROJECT_NAME}.xcodeproj" -target "${PROJECT_NAME}" -showBuildSettings"
echo "################################# XCODE PRINTING SOME PATHS, VARIABLES ########################################"
echo "BUILDING_WORSPACE_OR_PROJECT = value 'WORKSPACE' OR 'PROJECT' "
echo "ACTION = $ACTION"
echo "TARGET_NAME = $TARGET_NAME"
echo "EXECUTABLE_NAME = $EXECUTABLE_NAME"
echo "PROJECT_NAME = $PROJECT_NAME"
echo "SRCROOT = $SRCROOT"
echo "BUILD_DIR  = $BUILD_DIR"
echo "BUILD_ROOT = $BUILD_ROOT"
echo "SYMROOT    = $SYMROOT"
echo "OBJROOT    = $OBJROOT"
echo "CONFIGURATION_BUILD_DIR = $CONFIGURATION_BUILD_DIR"
echo "BUILT_PRODUCTS_DIR = $BUILT_PRODUCTS_DIR"
echo "TARGET_BUILD_DIR = $TARGET_BUILD_DIR"
echo "CONFIGURATION_TEMP_DIR = $CONFIGURATION_TEMP_DIR"
echo "CONFIGURATION = $CONFIGURATION"
echo "################# FROM WEB: HOW THEY DID  ###################"
echo "URL:https://kodmunki.wordpress.com/2015/03/04/cocoa-touch-frameworks-for-ios8-remix/"
echo "Framework for archive-appstore builds at path: DerivedData/<PROJECT_NAME>/Build/Intermediates/ArchiveIntermediates/<PROJECT_NAME>/IntermediateBuildFilesPath/UninstalledProducts/"
echo "Kuko so na webu nardil za testing+appstore-> path/Debug   =(debug iphonesimulator(debug-iphoneos framework) + release iphoneos(framework iz zgrornje poti))" 
echo "										       path/Release =(ipshoneos(framework iz zgrornje poti))" 
echo "Nastavi project build settings tab -> Runpath Search Paths & Framework Search Paths: path/$(CONFIGURATION) ...configuration je Release ali Debug" 
echo "Nastavi project general tab -> Embedded Binaries & Linked Frameworks and Libraries samo fremork iz Release!!! -Appstore validacija!!!"
echo "################################################################################################################"

fi

BUILDING_WORSPACE_OR_PROJECT="PROJECT"

#####################[ part 1 ]##################
# First, work out the BASESDK version number (NB: Apple ought to report this, but they hide it)
#    (incidental: searching for substrings in sh is a nightmare! Sob)

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '.\{3\}$')

# Next, work out if we're in SIM or DEVICE

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
OTHER_SDK_TO_BUILD=iphoneos${SDK_VERSION}
else
OTHER_SDK_TO_BUILD=iphonesimulator${SDK_VERSION}
fi
echo "################################# XCODE SELECTED SDK, SCRIPT CREATES OTHER  #################################"
echo "XCODE HAS SELECTED PLATFORM: ${PLATFORM_NAME} , VERSION: ${SDK_VERSION} (iOS Deployment Target: ${IPHONEOS_DEPLOYMENT_TARGET})"
echo "SCRIPT CREATING BUILD FOR, OTHER_SDK_TO_BUILD = ${OTHER_SDK_TO_BUILD}"
#
#####################[ end of part 1 ]##################

#####################[ part 2 ]##################
#
# IF this is the original invocation, invoke WHATEVER other builds are required
#
# Xcode is already building ONE target...
#
# ...but this is a LIBRARY, so Apple is wrong to set it to build just one.
# ...we need to build ALL targets
# ...we MUST NOT re-build the target that is ALREADY being built: Xcode WILL CRASH YOUR COMPUTER if you try this (infinite recursion!)
#
#
# So: build ONLY the missing platforms/configurations.

echo "################################# XCODE TRYS ROOT INVOCATION  #################################"
if [ "true" == ${ALREADYINVOKED:-false} ]
then
echo "RECURSION: I am NOT the root invocation, so I'm NOT going to recurse"   # zaklucis ce xcode builda!, kot synhronize,one thread
else
#code to the end

# CRITICAL:
# Prevent infinite recursion (Xcode sucks)
export ALREADYINVOKED="true"    #das mu vedet da si glavni, 

echo "SUCCEED: I am the root ... recursing all missing build targets NOW..."


#BUILDING_WORSPACE_OR_PROJECT="WORKSPACE" set in xcode build settings/user-defined/variable before this file is called
if [ -z "$BUILDING_WORSPACE_OR_PROJECT" ]
then
echo "Varible BUILDING_WORSPACE_OR_PROJECT is not setted. You must set it to build correctly!!"
exit 1
else
if [ "$BUILDING_WORSPACE_OR_PROJECT" == "PROJECT" ]
then
#echo "BUILDING: invoking: xcodebuild -configuration \"${CONFIGURATION}\" -project \"${PROJECT_NAME}.xcodeproj\" -target \"${TARGET_NAME}\" -sdk \"${OTHER_SDK_TO_BUILD}\" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO" BUILD_DIR=\"${BUILD_DIR}\" BUILD_ROOT=\"${BUILD_ROOT}\" SYMROOT=\"${SYMROOT}\"
#xcodebuild -configuration "${CONFIGURATION}" -project "${PROJECT_NAME}.xcodeproj" -target "${TARGET_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" &>/dev/null || die "xcodebuild project command failed!!"

#POZOR - ne uporabit SYMROOT="${SYMROOT} ker naredi odvecen buidl folder "ZDFramework.build"
#POZOR - ${ACTION} = build -> vedno prej klici "clean" sele nato "build"
echo "BUILDING: invoking: xcodebuild -configuration \"${CONFIGURATION}\" -project \"${PROJECT_NAME}.xcodeproj\" -target \"${TARGET_NAME}\" -sdk \"${OTHER_SDK_TO_BUILD}\" RUN_CLANG_STATIC_ANALYZER=NO ONLY_ACTIVE_ARCH=NO BUILD_DIR=\"${BUILD_DIR}\" BUILD_ROOT=\"${BUILD_ROOT}\" clean build"
xcodebuild -configuration "${CONFIGURATION}" -project "${PROJECT_NAME}.xcodeproj" -target "${PROJECT_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" RUN_CLANG_STATIC_ANALYZER=NO ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build &>/dev/null || die "xcodebuild workspace command failed!!"
fi
if [ "$BUILDING_WORSPACE_OR_PROJECT" == "WORKSPACE" ]
then
#echo "BUILDING: invoking: xcodebuild -configuration \"${CONFIGURATION}\" -workspace \"${PROJECT_NAME}.xcworkspace\" -scheme \"${PROJECT_NAME}\" -sdk \"${OTHER_SDK_TO_BUILD}\" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO" BUILD_DIR=\"${BUILD_DIR}\" BUILD_ROOT=\"${BUILD_ROOT}\" SYMROOT=\"${SYMROOT}\"
xcodebuild -configuration "${CONFIGURATION}" -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${PROJECT_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" &>/dev/null || die "xcodebuild workspace command failed!!"
else
echo "BUILDING_WORSPACE_OR_PROJECT wrong string!!!!"
fi
fi

ACTION="build"

#Merge all platform binaries as a fat binary for each configurations.

# Calculate where the (multiple) built files are coming from:
CURRENTCONFIG_DEVICE_DIR=${SYMROOT}/${CONFIGURATION}-iphoneos
CURRENTCONFIG_SIMULATOR_DIR=${SYMROOT}/${CONFIGURATION}-iphonesimulator

echo "################################# XCODE TAKING BUILDS FROM PATH #################################"
echo "Taking device build from: ${CURRENTCONFIG_DEVICE_DIR}"
echo "Taking simulator build from: ${CURRENTCONFIG_SIMULATOR_DIR}"

echo "################################# XCODE LIPO,CREATING .a LIB #################################"

CREATING_UNIVERSAL_DIR=${SYMROOT}/${CONFIGURATION}-universal

# ... remove the products of previous runs of this script
#      NB: this directory is ONLY created by this script - it should be safe to delete!

if [ -d "${CREATING_UNIVERSAL_DIR}" ]
then
echo "UNIVERSAL directory: alredy created, deleting everything from ${CREATING_UNIVERSAL_DIR}"
rm -rf "${CREATING_UNIVERSAL_DIR}/"
fi
echo "UNIVERSAL directory: creating fresh folder: ${CREATING_UNIVERSAL_DIR}"
mkdir -p "${CREATING_UNIVERSAL_DIR}"

echo "UNIVERSAL directory: Copying everything from iphonesimulator to universal including swift modules"
cp -r "${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}.framework" "${CREATING_UNIVERSAL_DIR}"
echo "UNIVERSAL directory: Copying swift modules from iphoneos to universal"
cp -r "${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}.framework/Modules/${EXECUTABLE_NAME}.swiftmodule/" "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}.framework/Modules/${EXECUTABLE_NAME}.swiftmodule"

echo "UNIVERSAL: LIPO :current configuration (${CONFIGURATION})"
echo "UNIVERSAL: LIPO :output file at path: ${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}.framework/${EXECUTABLE_NAME}"
lipo -create "${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}.framework/${EXECUTABLE_NAME}" "${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}.framework/${EXECUTABLE_NAME}" -output "${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}.framework/${EXECUTABLE_NAME}"
#xcrun -sdk iphoneos lipo...

echo "########################### NOTE about arhitectures  ###########################"
echo "Current arhitectures:suported devices" 
echo "x86_64 :Simulator,PCs,32&64 bit processors."
echo "i386   :Simulator,PCs,32 bit processors."
echo "ARMv8 / ARM64  == (16777228) cpusubtype (0):  ==>  iPhone6, iPhone6+, iPhone 5s, iPad Air, Retina iPad Mini"
echo "ARMv7s == cputype (12) cpusubtype (11)  ==> iPhone 5, iPhone 5c, iPad 4"
echo "ARMv7  ==> iPhone 3GS, iPhone 4, iPhone 4S, iPod 3G/4G/5G, iPad, iPad 2, iPad 3, iPad Mini"
echo "ARMv6  ==> iPhone, iPhone 3G, iPod 1G/2G "

echo "Library file at path: ${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"
echo "Included arhitectures:"
file ${CREATING_UNIVERSAL_DIR}/${EXECUTABLE_NAME}.framework/${EXECUTABLE_NAME}

fi