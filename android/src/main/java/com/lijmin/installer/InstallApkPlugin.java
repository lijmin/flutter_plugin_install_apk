package com.lijmin.installer;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;
import androidx.core.content.FileProvider;

import androidx.annotation.NonNull;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** InstallApkPlugin */
public class InstallApkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "install_apk");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("installApk")) {
      Map<String, Object> map = (Map<String, Object>) call.arguments;
      String filePath = map.get("filePath").toString();
      installAPK(filePath);
      Map<String, Object> resp = new HashMap<>();
      resp.put("code", 1);
      resp.put("msg", "installApk call success");
      result.success(resp);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

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
}
