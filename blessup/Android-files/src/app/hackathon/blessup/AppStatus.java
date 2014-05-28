package app.hackathon.blessup;

/**
 * This file is used by all the other classes to check Internet connection 
 * 
 * Project Name: - Tobuy
 * Developed by ClickLabs. Developer: Gurmail Singh Kang
 * Link: http://www.click-labs.com/
 */

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

public class AppStatus {

	private static AppStatus instance = new AppStatus();
	static Context context;
	ConnectivityManager connectivityManager;
	NetworkInfo wifiInfo, mobileInfo;
	boolean connected = false;

	/**
	 * 
	 * @param ctx Context of the Activity.
	 * @return Instance of the class.
	 */
	public static AppStatus getInstance(Context ctx) {
		context = ctx;
		return instance;
	}

	/** 
	 * To check the Internet connection.
	 * @param con Context
	 * @return true if Online else false.
	 */
	public boolean isOnline(Context con) {
		try {
			connectivityManager = (ConnectivityManager) con
					.getSystemService(Context.CONNECTIVITY_SERVICE);

			NetworkInfo networkInfo = connectivityManager
					.getActiveNetworkInfo();
			connected = networkInfo != null && networkInfo.isAvailable()
					&& networkInfo.isConnected();
			return connected;

		} catch (Exception e) {
			System.out
					.println("CheckConnectivity Exception: " + e.getMessage());
			Log.v("connectivity", e.toString());
		}
		return connected;
	}
}


