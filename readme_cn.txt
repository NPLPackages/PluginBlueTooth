����mod��������
������lua��mod��ʼ����ͨ��Mod\PluginBlueTooth\main.luaע����lua��java/oc�Ļ�����Ȼ��Ϳ�����lua����java/oc�������ӿڴ�����

android��ע��:
NPL.call("LuaJavaBridge.cpp", {})

lua����andorid�����ӿ�����:
LuaJavaBridge.callJavaStaticMethod("plugin/Bluetooth/InterfaceBluetooth" , "registerLuaCall", sigs, args)

sigs�Ĳ����������£��������Ͽ���ȥ����google luaj callJavaStaticMethod�ȹؼ��֣������ճ���cocos2dx����Ҫʵ����LuaJavaBridge.cpp�У�������jni��toluaʵ����lua��java��cpp�Ľ���

FieldDescriptor JavaLanguageType
Z boolean
B byte
C char
S short
I int
J long
F float
D double
Ps: �����Ҫ���õķ����ǿղ������򷽷�ǩ���� ��()V��

java����lua��
�ؼ�������callBaseBridge������ʵ�ֶ���õ�id���ַ��������õ����������ѹ�����ֽ�������lua������lua�н�ѹ����������lua�е��á�

��InterfaceBluetooth.java�У�����ParaEngineLuaJavaBridge.nplActivate(filePath, mergeData) ��ͨ��jni������c++

��ParaEngineLuaJavaBridge.cpp��Java_com_tatfook_paracraft_ParaEngineLuaJavaBridge_nplActivate������Ӧ��jni���������NPL_Activate��������filePath���ڵ�lua�ļ�����Ӧ��lua�ļ��ͻ����NPL.this��

ios��ע��:
NPL.call("LuaObjcBridge.cpp", {});

lua����ios�����ӿ�����:
LuaObjcBridge.callStaticMethod("InterfaceBluetooth", "registerLuaCall", args)

luaObjcBridge��ҪҲ�ǳ���cocos2dx����Ҫ������Ѷ�����Լ���  luaoc callStaticMethod��ʵ���ļ���Ҫ��LuaObjcBridge.cpp����android���ƣ�������Ҫ���sig���͡�

objc����lua:
��������Ȼ��callBaseBridge����InterfaceBluetooth.mm�У���andorid��ͬ����ͬʵ�֣���Ҫ��ѹjson�ַ��������亯����


�߼����ű��߼���
�μ�Mod\LogitowMonitor\LogitowMonitor.lua��Mod\LogitowMonitor\main.lua
�Լ�InterfaceBluetooth.java
1.һ��ʼ�趨��Ҫ���ӵ������豸��������������
2.�豸��������������᲻�������豸���豸��Ϣͨ��checkDevice������ȡ��
3.checkDevice���ж������Ƿ�Ϊ�����ȣ��Լ��������ǿ��rssi�����ͨ����ִ�����Ӻ���LinkDevice
4.���ӳɹ���lua����յ�SET_BLUE_STATUS�Ļص�������Ϊ1�����ӳɹ������������������֪ͨ
5.�����������������֪ͨ������Ӳ���иı�ʱ����ͨ��ON_CHARACTERISTIC��������lua��Ӳ������ı仯�͵�����������仯��
6.lua��ȡ������Ϊ16�����ַ���������仯ʱ��һ����14λ����1~6λ�Ƿ���id��7~8λ�������棬9~14λ����id
7.�������С��14����4�����ǵ������ݣ�������ʽΪ��1~2λ��ȡ����a��3~4λ��ȡ����b,���һ��С���������ٷֱ� = ((a.b - 1.5) * 100)/60
8.��ȡ������Ҫ��updateÿ�ζԸ�����������д��һ���ض�ֵ����ѯ������Ϊ��LogitowMonitor.pluginBlueTooth:writeToCharacteristic(BlueConstants.WRITE_BLOCK_CONFIG, BlueConstants.WRITE_CHARACTERISTIC_CONFIG, writeData);

��ƽ̨ʹ�õ������⣺
ios�� https://github.com/coolnameismy/BabyBluetooth
android��BluetoothGatt
���ǻ���ble 4.0��