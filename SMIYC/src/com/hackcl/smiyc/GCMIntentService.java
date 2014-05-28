package com.hackcl.smiyc;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import org.apache.http.util.ByteArrayBuffer;
import org.json.JSONArray;
import org.json.JSONObject;

import utils.CommonUtil;
import utils.Data;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Vibrator;
import android.util.Log;

import com.google.android.gcm.GCMBaseIntentService;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class GCMIntentService extends GCMBaseIntentService

{

	/*
	 * public GCMIntentService(String senderId) {
	 * 
	 * super(senderId); Log.d("GCMIntentService", senderId);
	 * 
	 * }
	 */

	MediaPlayer mp;
	protected Vibrator v;
	protected String url;
	protected String path;
	protected String response;

	protected void onError(Context arg0, String arg1) {

		Log.e("Registration", "Got an error1!");

		Log.e("Registration", arg0.toString() + arg1.toString());

	}

	protected boolean onRecoverableError(Context context, String errorId) {

		Log.d("onRecoverableError", errorId);

		return false;
	}

	protected void onMessage(Context context, final Intent arg1) {

		Log.e("Registration", "Got an error2!");

		Log.e("MESSAGE", "" + arg1.toString());

		if (!arg1.hasExtra("like_status")) {

			Handler mHandler = new Handler(getMainLooper());
			mHandler.post(new Runnable() {
				@Override
				public void run() {
					// Toast.makeText(getApplicationContext(), "test",
					// Toast.LENGTH_SHORT).show();
					getSurprise(arg1.getStringExtra("surprize_id"));

				}
			});
		} else {
			notificationManager(context, arg1.getStringExtra("like_status"));
		}
		// notificationManager(context, arg1.getStringExtra("message"));

		// Intent notificationIntent = new Intent(getApplicationContext(),
		// splash.class);
		// notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
		// notificationIntent.setAction(Intent.ACTION_MAIN);
		// notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// startActivity(notificationIntent);

	}

	protected void onRegistered(Context arg0, String arg1) {

		Log.e("Registration", "Got an error3!");

		Log.e("Registration", arg0.toString() + arg1.toString());
		Data.regid = arg1.toString();

	}

	protected void onUnregistered(Context arg0, String arg1) {

		Log.e("Registration", "Got an error4!");

		Log.e("Registration", arg0.toString() + arg1.toString());

	}

	private void notificationManager(Context context, String message)

	{
		try {
			v = (Vibrator) getApplicationContext().getSystemService(
					Context.VIBRATOR_SERVICE);
			// Vibrate for 500 milliseconds
			v.vibrate(500);
		} catch (Exception e) {
			// TODO: handle exception
		}
		long when = System.currentTimeMillis();

		NotificationManager notificationManager = (NotificationManager) context

		.getSystemService(Context.NOTIFICATION_SERVICE);

		@SuppressWarnings("deprecation")
		Notification notification = new Notification(R.drawable.logo,

		"SMIYC", when);

		String title = "SMIYC";

		// Intent notificationIntent = new Intent(context,

		// UserHome.class);
		//
		// PackageManager pm = getPackageManager();
		// Intent notificationIntent = pm
		// .getLaunchIntentForPackage(getApplicationContext()
		// .getPackageName());
		//
		// // set intent so it does not start a new activity
		//
		// notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
		//
		// | Intent.FLAG_ACTIVITY_SINGLE_TOP);

		// Intent notificationIntent = new Intent(context, Splash.class);
		//
		// notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
		// notificationIntent.setAction(Intent.ACTION_MAIN);
		// notification.flags = Notification.FLAG_AUTO_CANCEL;
		//
		// PendingIntent intent = PendingIntent.getActivity(context, 0,
		//
		// notificationIntent, 0);

		notification.setLatestEventInfo(context, title, message, null);

		notification.flags |= Notification.FLAG_AUTO_CANCEL;

		notificationManager.notify(0, notification);

	}

	public void getSurprise(String surpise_id) {

		RequestParams rv = new RequestParams();

		rv.put("surprize_id", surpise_id);
		rv.put("useraccesstoken", CommonUtil.getAccessToken(getBaseContext()));

		Log.v("surprize_id", surpise_id);
		Log.v("useraccesstoken", CommonUtil.getAccessToken(getBaseContext()));

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "fetch_surprize", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String res) {
						try {
							response = res;
							Log.v("surprize response", res);
							JSONObject js = new JSONObject(res);
							if (!js.has("error")) {

								Log.v("response = ", res + ",");
								JSONArray jsnArry =js.getJSONArray("data");
								url = jsnArry.getJSONObject(0).getString(
										"surprize_image");
								path = jsnArry.getJSONObject(0).getString(
										"surprize_id")+ ".png";

								new DownloadWebPageTask().execute("");

							}

						} catch (Exception e) {
Log.v("exception e = ", e.toString());
						}

					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());

					}

				});
	}

	private class DownloadWebPageTask extends AsyncTask<String, Void, String> {
		@Override
		protected String doInBackground(String... urls) {

			DownloadFromUrl(url, path);

			return "";
		}

		@Override
		protected void onPostExecute(String result) {
			try {
				v = (Vibrator) getApplicationContext().getSystemService(
						Context.VIBRATOR_SERVICE);
				// Vibrate for 500 milliseconds
				v.vibrate(300);
			} catch (Exception e) {
				// TODO: handle exception
			}

			Intent notificationIntent = new Intent(getApplicationContext(),
					Surprise.class);
			notificationIntent.putExtra("data", response);
			notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
			notificationIntent.setAction(Intent.ACTION_MAIN);
			notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
					| Intent.FLAG_ACTIVITY_CLEAR_TASK);
			startActivity(notificationIntent);
			
			
		}
	}

	private final String PATH = CommonUtil.GAME_IMAGE_DIR; // put the downloaded
															// file here

	public void DownloadFromUrl(String imageURL, String fileName) { // this is
																	// the
																	// downloader
																	// method
		try {
			URL url = new URL(imageURL); // you can write here any link
			File file = CommonUtil.getTempImageFile(fileName);

			long startTime = System.currentTimeMillis();
			Log.d("ImageManager", "download begining");
			Log.d("ImageManager", "download url:" + url);
			Log.d("ImageManager", "downloaded file name:" + fileName);
			/* Open a connection to that URL. */
			URLConnection ucon = url.openConnection();

			/*
			 * Define InputStreams to read from the URLConnection.
			 */
			InputStream is = ucon.getInputStream();
			BufferedInputStream bis = new BufferedInputStream(is);

			/*
			 * Read bytes to the Buffer until there is nothing more to read(-1).
			 */
			ByteArrayBuffer baf = new ByteArrayBuffer(50);
			int current = 0;
			while ((current = bis.read()) != -1) {
				baf.append((byte) current);
			}

			/* Convert the Bytes read to a String. */
			FileOutputStream fos = new FileOutputStream(file);
			fos.write(baf.toByteArray());
			fos.close();
			Log.d("ImageManager",
					"download ready in"
							+ ((System.currentTimeMillis() - startTime) / 1000)
							+ " sec");

		} catch (IOException e) {
			Log.d("ImageManager", "Error: " + e);
		}

	}

}