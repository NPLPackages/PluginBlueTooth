蓝牙mod的启动：
首先是lua的mod初始化，通过Mod\PluginBlueTooth\main.lua注册了lua和java/oc的互调，然后就可以在lua调用java/oc的蓝牙接口代码了

android的注册:
NPL.call("LuaJavaBridge.cpp", {})

lua调用andorid蓝牙接口用例:
LuaJavaBridge.callJavaStaticMethod("plugin/Bluetooth/InterfaceBluetooth" , "registerLuaCall", sigs, args)

sigs的参数含义如下，更多资料可以去自行google luaj callJavaStaticMethod等关键字，代码照抄自cocos2dx，主要实现在LuaJavaBridge.cpp中，利用了jni和tolua实现了lua、java、cpp的交互

FieldDescriptor JavaLanguageType
Z boolean
B byte
C char
S short
I int
J long
F float
D double
Ps: 如果需要调用的方法是空参数，则方法签名是 “()V”

java调用lua：
关键函数是callBaseBridge，传入实现定义好的id和字符串（更好的替代方法，压缩成字节流传给lua，再在lua中解压），即可在lua中调用。

在InterfaceBluetooth.java中，调用ParaEngineLuaJavaBridge.nplActivate(filePath, mergeData) ，通过jni来到了c++

在ParaEngineLuaJavaBridge.cpp中Java_com_tatfook_paracraft_ParaEngineLuaJavaBridge_nplActivate函数响应了jni，这里调用NPL_Activate来启动了filePath所在的lua文件，对应的lua文件就会调用NPL.this。

ios的注册:
NPL.call("LuaObjcBridge.cpp", {});

lua调用ios蓝牙接口用例:
LuaObjcBridge.callStaticMethod("InterfaceBluetooth", "registerLuaCall", args)

luaObjcBridge主要也是抄自cocos2dx，想要更多资讯可以自己搜  luaoc callStaticMethod，实现文件主要在LuaObjcBridge.cpp，与android类似，但不需要标记sig类型。

objc调用lua:
函数名依然叫callBaseBridge，在InterfaceBluetooth.mm中，与andorid的同名不同实现，主要靠压json字符串来传输函数。


逻辑塔脚本逻辑：
参见Mod\LogitowMonitor\LogitowMonitor.lua和Mod\LogitowMonitor\main.lua
以及InterfaceBluetooth.java
1.一开始设定好要链接的蓝牙设备名和蓝牙特征号
2.设备如果开启蓝牙，会不断搜索设备，设备信息通过checkDevice函数读取。
3.checkDevice中判断名字是否为蓝牙度，以及检测蓝牙强度rssi，如果通过就执行链接函数LinkDevice
4.链接成功后，lua会接收到SET_BLUE_STATUS的回调，参数为1则连接成功，开启设置特征码的通知
5.由于设置了特征码的通知，当有硬件有改变时，会通过ON_CHARACTERISTIC传参数给lua，硬件方块的变化和电量都在这里变化。
6.lua获取的数据为16进制字符串，方块变化时候一共有14位数，1~6位是方块id，7~8位是链接面，9~14位是子id
7.如果长度小于14又是4，则是电量数据，电量公式为：1~2位提取的数a，3~4位提取的数b,组成一个小数，电量百分比 = ((a.b - 1.5) * 100)/60
8.获取电量需要在update每次对给定的特征号写入一个特定值来查询，代码为：LogitowMonitor.pluginBlueTooth:writeToCharacteristic(BlueConstants.WRITE_BLOCK_CONFIG, BlueConstants.WRITE_CHARACTERISTIC_CONFIG, writeData);

各平台使用的蓝牙库：
ios： https://github.com/coolnameismy/BabyBluetooth
android：BluetoothGatt
均是基于ble 4.0的