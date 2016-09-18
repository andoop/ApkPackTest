package cn.andoop.apkpacktest;

import android.app.Application;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

/**
 * Created by andoop on 2016/9/13.
 */
public class MApplication extends Application{
    //渠道信息
    public static String channel;
    @Override
    public void onCreate() {
        super.onCreate();
        initChannel();
    }

    /**
     * 初始化渠道信息
     */
    private void initChannel() {
        channel=getChannel();
    }

    private String getChannel() {
        try {
            PackageManager pm = getPackageManager();
            ApplicationInfo appInfo = pm.getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            return appInfo.metaData.getString("UMENG_CHANNEL");
        } catch (PackageManager.NameNotFoundException ignored) {
        }
        return "";

    }
}
