# Flutter调用android原生代码（插件开发）

本文主要记录flutter插件开发，使用flutter调用android原生代码，android插件使用java语言，实现一个安装apk功能。
[插件地址Github](https://github.com/lijmin/flutter_plugin_install_apk),

## 创建flutter插件

`flutter create --platforms=android -a java --template=plugin install_apk`
只需要android平台，使用语言是java

## 添加dart接口

lib目录下
install_apk_platform_interface.dart 添加接口
```dart
  Future<Map> installApk(String filePath) {
  throw UnimplementedError('installApk() has not been implemented.');
}
```
install_apk_method_channel.dart 添加接口实现，调用android的installApk方法
```dart
@override
Future<Map> installApk(String filePath) async {
  Map<dynamic, dynamic> map = {"filePath":filePath};
  return await methodChannel.invokeMethod('installApk', map);
}
```

## android installApk方法实现

从onAttachedToEngine方法获取context
```java
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        ...
        context = flutterPluginBinding.getApplicationContext();
    }
```
onMethodCall是方法入口，根据方法名称分发，并获取参数。
```java
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("installApk")) {
            Map<String, Object> map = (Map<String, Object>) call.arguments;
            String filePath = map.get("filePath").toString();
            Log.e("TAG", filePath);
            installAPK(filePath);
            Map<String, Object> resp = new HashMap<>();
            resp.put("code", 1);
            resp.put("msg", "install success");
            result.success(resp);
        }
    }
```
实现安装方法installAPK
```java
  private void installAPK(String filePath) {
    Intent intent = new Intent(Intent.ACTION_VIEW);
    Uri uri;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
      uri = FileProvider.getUriForFile(context, "com.lijmin.installer.provider", new File(filePath));
    } else {
      uri = Uri.fromFile(new File(filePath));
    }
    intent.setDataAndType(uri,"application/vnd.android.package-archive");
    context.startActivity(intent);
  }
```
AndroidManifest.xml添加provider
```xml
<manifest>
    <application>
        ...
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.lijmin.installer.provider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>
        ...
    </application>
</manifest>
```
添加file_paths资源文件
```xml
<?xml version="1.0" encoding="utf-8"?>
<files-path path="" name="name" />
```
内部的element可以是files-path，cache-path，external-path，external-files-path，external-cache-path，
分别对应Context.getFilesDir()，Context.getCacheDir()，Environment.getExternalStorageDirectory()，Context.getExternalFilesDir()，Context.getExternalCacheDir()等几个方法。

添加安装apk权限
```xml
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES"/>
```

