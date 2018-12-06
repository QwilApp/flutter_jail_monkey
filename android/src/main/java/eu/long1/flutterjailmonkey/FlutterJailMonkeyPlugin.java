package eu.long1.flutterjailmonkey;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterJailMonkeyPlugin
 */
public class FlutterJailMonkeyPlugin implements MethodCallHandler {

    private final Context context;


    private FlutterJailMonkeyPlugin(Context context) {
        this.context = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_jail_monkey");
        channel.setMethodCallHandler(new FlutterJailMonkeyPlugin(registrar.context().getApplicationContext()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "isJailBroken":
                result.success(isJailBroken());
                break;
            case "canMockLocation":
                result.success(isMockLocationOn(context));
                break;
            case "isOnExternalStorage":
                result.success(isOnExternalStorage(context));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private boolean isSuperuserPresent() {
        // Check if /system/app/Superuser.apk is present
        String[] paths = {
                "/system/app/Superuser.apk",
                "/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/data/local/su"
        };

        for (String path : paths) {
            if (new File(path).exists()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Checks if the device is rooted.
     *
     * @return <code>true</code> if the device is rooted, <code>false</code> otherwise.
     */
    private boolean isJailBroken() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
                ? (checkRootMethod1() || checkRootMethod2())
                : (isSuperuserPresent() || canExecuteCommand());
    }

    private boolean checkRootMethod1() {
        String[] paths = {"/system/app/Superuser.apk", "/sbin/su", "/system/bin/su", "/system/xbin/su", "/data/local/xbin/su", "/data/local/bin/su", "/system/sd/xbin/su",
                "/system/bin/failsafe/su", "/data/local/su"};
        for (String path : paths) {
            if (new File(path).exists()) return true;
        }
        return false;
    }

    private boolean checkRootMethod2() {
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(new String[]{"/system/xbin/which", "su"});
            BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
            return in.readLine() != null;
        } catch (Throwable t) {
            return false;
        } finally {
            if (process != null) process.destroy();
        }
    }

    // executes a command on the system
    private boolean canExecuteCommand() {
        boolean executeResult;
        try {
            Process process = Runtime.getRuntime().exec("/system/xbin/which su");
            executeResult = process.waitFor() == 0;
        } catch (Exception e) {
            executeResult = false;
        }

        return executeResult;
    }

    //returns true if mock location enabled, false if not enabled.
    @SuppressWarnings( "deprecation" )
    private boolean isMockLocationOn(Context context) {
        return !Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ALLOW_MOCK_LOCATION).equals("0");
    }

    /**
     * Checks if the application is installed on the SD card.
     *
     * @return <code>true</code> if the application is installed on the sd card
     */
    private boolean isOnExternalStorage(Context context) {
        PackageManager pm = context.getPackageManager();
        try {
            PackageInfo pi = pm.getPackageInfo(context.getPackageName(), 0);
            ApplicationInfo ai = pi.applicationInfo;
            return (ai.flags & ApplicationInfo.FLAG_EXTERNAL_STORAGE) == ApplicationInfo.FLAG_EXTERNAL_STORAGE;
        } catch (PackageManager.NameNotFoundException e) {
            // ignore
        }


        return false;
    }
}
