package com.hackcl.smiyc;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import org.json.JSONArray;
import org.json.JSONObject;

import rmn.androidscreenlibrary.ASSL;
import utils.CommonUtil;
import utils.Data;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.ViewGroup;

import com.facebook.LoggingBehavior;
import com.facebook.Request;
import com.facebook.Request.GraphUserCallback;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.SessionLoginBehavior;
import com.facebook.SessionState;
import com.facebook.Settings;
import com.facebook.model.GraphUser;
import com.google.android.gcm.GCMRegistrar;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class Splash extends Activity {
	public String SENDERID = "913957400701";
	private Session session;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);
		new ASSL(Splash.this, (ViewGroup) findViewById(R.id.root), 1184, 720,
				true);
		
		 PackageInfo info;
		 try {
		 info = getPackageManager().getPackageInfo("com.nurdymuny.paperchasex",
		 PackageManager.GET_SIGNATURES);
		 for (Signature signature : info.signatures) {
		 MessageDigest md;
		 md = MessageDigest.getInstance("SHA");
		 md.update(signature.toByteArray());
		 String something = new String(Base64.encode(md.digest(), 0));
		 //String something = new String(Base64.encodeBytes(md.digest()));
		 Log.e("hash key", something);
		 }
		 } catch (NameNotFoundException e1) {
		 Log.e("name not found", e1.toString());
		 } catch (NoSuchAlgorithmException e) {
		 Log.e("no such an algorithm", e.toString());
		 } catch (Exception e) {
		 Log.e("exception", e.toString());
		 }
		 CommonUtil.getTempImageFile();
		registerGCM(Splash.this);
		if (CommonUtil.getAccessToken(getApplicationContext()).isEmpty()) {
			fbLogin();
		} else {
			loginTokenMethod();
		}

	}

	public void registerGCM(Context cont) {
		try { // registering GCM services
			GCMRegistrar.checkManifest(cont);
			Data.regid = GCMRegistrar.getRegistrationId(cont);
			if (Data.regid.equals("")) {
				GCMRegistrar.register(cont, SENDERID);
				Data.regid = GCMRegistrar.getRegistrationId(cont);
				// Toast.makeText(getApplicationContext(), ""+Data.regId,
				// 1000).show();
				Log.e("reg_id in if.......", " >" + Data.regid + " ");
			} else {
				Log.v("GCM", "Already registered");
				Log.e("reg_id..............in else........", " >" + Data.regid
						+ " ");
				Log.e("reg_id....length", Data.regid.length() + " ");

			}
		} catch (Exception e) {
			Log.e("exception GCM", e.toString() + " " + e.toString());
		}
	}

	public void fbLogin() {

		session = new Session(Splash.this);
		Session.setActiveSession(session);
		Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_RAW_RESPONSES);
		// Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);

		Session.OpenRequest openRequest = null;

		openRequest = new Session.OpenRequest(Splash.this);
		openRequest.setPermissions(Arrays.asList("email", "user_friends",
				"user_photos"));
		try {
			if (isSystemPackage(getPackageManager().getPackageInfo(
					"com.facebook.katana", 0))) {
				openRequest.setLoginBehavior(SessionLoginBehavior.SUPPRESS_SSO);
			} else {

			}
		} catch (NameNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		openRequest.setCallback(new Session.StatusCallback() {

			@Override
			public void call(final Session session, SessionState state,
					Exception exception) {
				if (session.isOpened()) {
					String accessToken = session.getAccessToken();

					Log.v("accessToken ", accessToken);
					// if (isLoginScreen)
					// loginServerFacebook(accessToken);
					// else
					// SignUpServerFacebook(accessToken);
					// Toast.makeText(getApplicationContext(), accessToken,
					// 5000).show();
					fbPost();
					// Request user data and show the results
					// Request.newMeRequest(Session.getActiveSession(),
					// new GraphUserCallback() {
					// @Override
					// public void onCompleted(GraphUser user,
					// Response response) {
					// if (null != user) {
					// // Display the parsed user info
					// Log.v("Response : ", response + "");
					// Log.v("UserID : ", user.getId() + "");
					// Log.v("User FirstName : ",
					// user.getFirstName() + "");
					// //session.closeAndClearTokenInformation();
					// fbPost();
					// // loginMethod(user.getId(),
					// // user.getFirstName()+" "+user.getLastName());
					//
					//
					//
					// //ghj
					//
					//
					// }
					// }
					// }).executeAsync();
				}

			}

		});
		session.openForRead(openRequest);
	}

	private boolean isSystemPackage(PackageInfo pkgInfo) {
		return ((pkgInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0) ? true
				: false;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		Session.getActiveSession().onActivityResult(this, requestCode,
				resultCode, data);

	}

	public void fbPost() {

		Session session = new Session(Splash.this);
		Session.setActiveSession(session);
		Session.OpenRequest openRequest = null;
		openRequest = new Session.OpenRequest(Splash.this);
		openRequest.setPermissions(Arrays.asList("publish_actions"));

		try {

			if (isSystemPackage(Splash.this.getPackageManager().getPackageInfo(
					"com.facebook.katana", 0))) {
				openRequest.setLoginBehavior(SessionLoginBehavior.SUPPRESS_SSO);
			} else {
			}

		} catch (NameNotFoundException e) {

			// TODO Auto-generated catch block

			e.printStackTrace();

		}

		openRequest.setCallback(new Session.StatusCallback() {

			@Override
			public void call(Session session, SessionState state,

			Exception exception) {

				Log.v("callback = ", "callback");

				if (session.isOpened()) {
					if (session.isOpened()) {
						final String accessToken = session.getAccessToken();

						CommonUtil.savefbToken(accessToken,
								getApplicationContext());
						Log.v("accessToken ", accessToken);
						// if (isLoginScreen)
						// loginServerFacebook(accessToken);
						// else
						// SignUpServerFacebook(accessToken);
						// Toast.makeText(getApplicationContext(), accessToken,
						// 5000).show();

						// Request user data and show the results
						Request.newMeRequest(Session.getActiveSession(),
								new GraphUserCallback() {
									@Override
									public void onCompleted(GraphUser user,
											Response response) {
										if (null != user) {
											// Display the parsed user info
											Log.v("Response : ", response + "");
											Log.v("UserID : ", user.getId()
													+ "");
											Log.v("User FirstName : ",
													user.getFirstName() + "");
											// session.closeAndClearTokenInformation();
											// fbPost();

											CommonUtil.saveFBID(user.getId(),
													getApplicationContext());
											loginMethod(
													accessToken,
													user.getId(),
													user.getFirstName()
															+ " "
															+ user.getLastName());

										}
									}
								}).executeAsync();
					}
				}

			}

		});

		session.openForPublish(openRequest);

	}

	public void loginMethod(String token, String fb_id, String fbname) {

		RequestParams rv = new RequestParams();

		rv.put("fb_id", fb_id);
		rv.put("fbname", fbname);
		rv.put("devicetoken", Data.regid);
		rv.put("fbaccesstoken", token);

		Log.v("fb_id", fb_id);
		Log.v("fbname", fbname);
		Log.v("devicetoken", Data.regid);

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "fblogin", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {

						Log.v("response = ", response + ",");

						try {
							JSONObject js = new JSONObject(response);
							JSONArray jsArry = js.getJSONArray("data");

							CommonUtil.saveAccessToken(jsArry.getJSONObject(0)
									.getString("accesstoken"),
									getApplicationContext());

							CommonUtil.saveStatus(jsArry.getJSONObject(0)
									.getString("status"),
									getApplicationContext());
							CommonUtil.setUserData(response, getApplicationContext());
							Intent intent = new Intent(getApplicationContext(),
									MainScreen.class);
							intent.putExtra("data", response);
							startActivity(intent);
							finish();

						} catch (Exception e) {
							Log.v("error in parsing", "");
						}

					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());

						CommonUtil.commonErrorDialog(Splash.this,
								"An error occurred. Please try later.");

					}

				});
	}

	public void loginTokenMethod() {

		RequestParams rv = new RequestParams();

		rv.put("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));
		rv.put("devicetoken", Data.regid);

		Log.v("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));
		Log.v("devicetoken", Data.regid);

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "accesstokenlogin", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {

						Log.v("response = ", response + ",");

						try {
							JSONObject js = new JSONObject(response);

							if (!js.has("error")) {

								JSONArray jsArry = js.getJSONArray("data");

								CommonUtil.saveAccessToken(
										jsArry.getJSONObject(0).getString(
												"accesstoken"),
										getApplicationContext());

								CommonUtil.saveStatus(jsArry.getJSONObject(0)
										.getString("status"),
										getApplicationContext());

								
								
								CommonUtil.setUserData(response, getApplicationContext());
								
								Intent intent = new Intent(
										getApplicationContext(),
										MainScreen.class);
								intent.putExtra("data", response);
								startActivity(intent);
								finish();
							} else {

								fbLogin();
							}

						} catch (Exception e) {
							Log.v("error in parsing", "");
						}

					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());

						CommonUtil.commonErrorDialog(Splash.this,
								"An error occurred. Please try later.");

					}

				});
	}

}
