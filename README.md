<h5>Build FAT Cocoa Touch Framework at once. (Script with quide + Example )</h5>

In 2015 AppStore has changed rules. Fat/Universal binaries(binary with Simulator(i386,x86_64) and Device(armv7,armv7s,arm64) are no longer passing validation!. Your app must contain framework with only “Release” Device arhitectures.
Because of this script makes FAT binary only for develop configuration.(If you want also for release see below)

<h5>1. Quick option - already created </h5>
 -Check example and just rename project to whatever ...

<h5>2. Create with quide </h5>
In this quick quide you will make universal cocoa touch framework which creates fat build for develop configuraton and is compatible with Xcode 6 and iOS 8. (For release see below)</br>

<b>IMPORTANT</b>: In Xcode always select Simulator and run, script will make Device and Universal build behind the scenes.(If Device is selected script fails because of “Code=53 Simulator verification failed” error in xcodebuild command. Until Apple don’t fix this issue just build with simulator! )

1. Open Xcode and create fresh Cocoa Touch Framework.
2. In project navigator select project / file (menu bar) / project settings / change derived data location to Project-relative with name DerivedData
3. Select project / build settings / Build Active Architecture = NO
4. Select project / build settings / Arhitectures / Other/ + / add armv7s . Old post : goo.gl/bnKWB5
5. Select project / build settings / Valid Architectures / should be arm64 armv7 armv7s
6. Create new Xcode aggregate target – (this target /script will delete current build for device and simulator in derivedData! Yes it will be called twice (You need to understand script that makes universal build )
  6.1. Select project / + / select iOS / other / Aggregate .. name it DeleteBuildDir
  6.2. Select main target / build phases / target dependencies / + / select DeleteBuildDir
  6.3. Select DeleteBuildDir target / Build setttings/ paste code from ZDFrameworkDeleteBuildDataAsAggregateTarget.sh script

7. Select project /main target / run script and paste code from ZDFrameworkXcodeScript.sh script – currently this script is executed only when configration=Debug , If you want to make universal Release framework delete [ ${CONFIGURATION} = “Debug”] then” on start and “fi” at end of code. When Making release version via Archive add back this case or comment all script =).

<b>Path to release,debug, universal framework</b> 
Path to Universal,device,simulator frameworks: /DerivedData/{ProjectName}/Build/Products/

<b>Making Archive</b> 
If you removed put back [ ${CONFIGURATION} = “Debug”] then” on start and “fi” at end of script OR comment all script!.

<b>Path to Archive framework</b>
/DerivedData//Build/Intermediates /ArchiveIntermediates /{ProjectName} /IntermediateBuildFilesPath/ UninstalledProducts /Release-iphoneos

<b>Importing universal framework to app project</b> 
Drag universial framework file /DerivedData/{ProjectName}/Build/Products/ Debug-universal/ZDFramework.framework inside App project. 2. Select project main target

General tab and add framework to Embedded binaries and Linked Frameworks and libraries( ensure that it’s not duplicated) In Build Phases tab check that framework is added to Link Binary with Libraries In Build Settings tab / Framework Search paths / check that path points to currect universial framework file (if same path is duplicated remove one)

<b>Framework code is not visible inside app project </b>
SWIFT: In swift everything is Internal by default which means all code is visible only inside mudul. Because framework is modul all external code needs to be explicit defined with public modifier.
OBJECTIVE-C: Headers are project visible by default. Select main project target / Build phases / Headers / move header to public.For compatibility with Swift (Calling ObjC code from Swift) add new import in FrameworkName.h autogenerated file.

<h5> SCRIPT OUTPUT</h5>
![alt tag](https://github.com/zdrole/ZDFatCocoaTouchFramework/blob/master/CocoaTouchFramework.png)

