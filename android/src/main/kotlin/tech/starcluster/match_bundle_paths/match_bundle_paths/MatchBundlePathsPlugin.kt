package tech.starcluster.match_bundle_paths.match_bundle_paths

import android.app.Activity
import android.app.PendingIntent.getActivity
import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File


/** MatchBundlePathsPlugin */
public class MatchBundlePathsPlugin(dataDirPath: String? = null): FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var dataDirPath: String? = dataDirPath;

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "match_bundle_paths")
    channel.setMethodCallHandler(this);
    val context = flutterPluginBinding.getApplicationContext();
    this.dataDirPath = context.getPackageManager().getApplicationInfo(context.getPackageName(), 0).dataDir
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "match_bundle_paths")
      var dataDirPath = registrar.activity().packageManager.getApplicationInfo(registrar.activity().packageName, 0).dataDir
      channel.setMethodCallHandler(MatchBundlePathsPlugin(dataDirPath))
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "matchBundlePaths") {
      if (call.arguments !is String) {
        result.error("Argument", "Function call argument is not String", null);
        return;
      }

      try {
        var regex = (call.arguments as String).toRegex();

        val matchedPaths = mutableListOf<String>()

        if (this.dataDirPath != null) {
          File(this.dataDirPath!!).walk().forEach {
            if (it.isFile && regex.containsMatchIn(it.absolutePath)) {
              matchedPaths.add(it.absolutePath);
            }
          }
          result.success(matchedPaths);
        }else {
          result.error("Missing data dir", "Could not resolve datadir path",null);
        }

      } catch (e: Exception) {
        result.error("Error", e.localizedMessage,null);
      }
      } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
