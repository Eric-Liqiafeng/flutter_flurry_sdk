package br.com.rsmarques.flutter_flurry_sdk;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.flurry.android.FlurryAgent;
import com.flurry.android.FlurryPerformance;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterFlurrySdkPlugin */
public class FlutterFlurrySdkPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;
  private static final String DEBUG_NAME = "FlutterFlurrySDK";
  private static final String MESSAGE_CHANNEL = "flutter_flurry_sdk/message";
  private Activity activity;
  private Context context;
  private ActivityPluginBinding activityPluginBinding;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    setupChannels(binding.getFlutterEngine().getDartExecutor(), binding.getApplicationContext());
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
  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null) {
      // When a background flutter view tries to register the plugin, the registrar has no activity.
      // We stop the registration process as this plugin is foreground only.
      return;
    }

    FlutterFlurrySdkPlugin plugin = new FlutterFlurrySdkPlugin();
    plugin.setupChannels(registrar.messenger(), registrar.activity().getApplicationContext());
    plugin.setActivity(registrar.activity());
  }

  private void setupChannels(BinaryMessenger messenger, Context context) {
    this.context = context;
    methodChannel = new MethodChannel(messenger, MESSAGE_CHANNEL);
    methodChannel.setMethodCallHandler(this);
  }

  private void setActivity(Activity activity) {
    this.activity = activity;
  }

  private void teardownChannels() {
    this.activityPluginBinding = null;
    this.activity = null;
    this.context = null;
    methodChannel.setMethodCallHandler(null);
  }

  /**---------------------------------------------------------------------------------------------
   ActivityAware Interface Methods
   --------------------------------------------------------------------------------------------**/
  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.activityPluginBinding = activityPluginBinding;
    setActivity(activityPluginBinding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) {
    onAttachedToActivity(activityPluginBinding);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initialize")) {
      initialize(call, result);
    } else if (call.method.equals("logEvent")) {
      logEvent(call, result);
    } else if (call.method.equals("endTimedEvent")) {
      endTimedEvent(call, result);
    } else if (call.method.equals("userId")) {
      setUserId(call, result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    teardownChannels();
  }

  private void initialize(final MethodCall call, final Result result) {
    String apiKey = call.argument("api_key_android");
    boolean isLogEnabled = call.argument("is_log_enabled");
    boolean isPerfMetrics = call.argument("is_performance_metrics");
    String appVersion = call.argument("app_version");

    new FlurryAgent.Builder()
            .withDataSaleOptOut(false) //CCPA - the default value is false
            .withLogEnabled(isLogEnabled)
            .withCaptureUncaughtExceptions(true)
            .withContinueSessionMillis(10000)
            .withLogLevel(Log.VERBOSE)
            .withPerformanceMetrics(isPerfMetrics ? FlurryPerformance.ALL: FlurryPerformance.NONE)
            .build(this.activity, apiKey);

    if (appVersion != null) {
      FlurryAgent.setVersionName(appVersion);
    }

    result.success(null);
  }

  private void logEvent(final MethodCall call, final Result result) {
    String eventName = call.argument("event");
    Map<String, String> parameters = call.argument("parameters");

    if (eventName != null && parameters != null)
      FlurryAgent.logEvent(eventName, parameters);
    result.success(null);
  }

  private void endTimedEvent(final MethodCall call, final Result result) {
    String eventName = call.argument("event");

    if (eventName != null)
      FlurryAgent.endTimedEvent(eventName);
    result.success(null);
  }

  private void setUserId(final MethodCall call, final Result result) {
    String userId = call.argument("userId");

    if (userId != null)
      FlurryAgent.setUserId(userId);
    result.success(null);
  }
}
