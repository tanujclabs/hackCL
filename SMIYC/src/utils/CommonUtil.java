package utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicInteger;

import com.hackcl.smiyc.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.util.Base64;
import android.util.Log;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class CommonUtil {

	private static ProgressDialog pd_st;
	public static String GAME_IMAGE_NAME = "userImage.png";
	// public static final String GAME_IMAGE_NAME1 = "gameImage1.jpg";
	public static String GAME_IMAGE_DIR = Environment
			.getExternalStorageDirectory() + "/SMIYC";
	public static String GAME_IMAGE_DIR1 = Environment
			.getExternalStorageDirectory() + "/SMIYC1";
	// static Typeface customFontLight;
	// static Typeface customFontBold;
	// static Typeface customFontBoldItalic;
	// static Typeface customFontItalic;
	// static Typeface customFontRegular;
	// static Typeface customFontSemibold;
	public static int[] creditsValue = { 0, 10, 25, 50, 100, 500, 1000 };

	// public static Typeface getFontLight(Context appContext) {
	// if (customFontLight == null) {
	// customFontLight = Typeface.createFromAsset(appContext.getAssets(),
	// "fonts/OpenSans-Light.ttf");
	// }
	// return customFontLight;
	// }
	//
	// public static Typeface getFontBold(Context appContext) {
	// if (customFontBold == null) {
	// customFontBold = Typeface.createFromAsset(appContext.getAssets(),
	// "fonts/OpenSans-Bold.ttf");
	// }
	// return customFontBold;
	// }
	//
	// public static Typeface getFontItalic(Context appContext) {
	// if (customFontItalic == null) {
	// customFontItalic = Typeface.createFromAsset(appContext.getAssets(),
	// "fonts/OpenSans-Italic.ttf");
	// }
	// return customFontItalic;
	// }
	//
	// public static Typeface getFontBoldItalic(Context appContext) {
	// if (customFontBoldItalic == null) {
	// customFontBoldItalic = Typeface.createFromAsset(
	// appContext.getAssets(), "fonts/OpenSans-BoldItalic.ttf");
	// }
	// return customFontBoldItalic;
	// }
	//
	// public static Typeface getFontRegular(Context appContext) {
	// if (customFontRegular == null) {
	// customFontRegular = Typeface.createFromAsset(
	// appContext.getAssets(), "fonts/OpenSans-Regular.ttf");
	// }
	// return customFontRegular;
	// }
	//
	// public static Typeface getFontSemiBold(Context appContext) {
	// if (customFontSemibold == null) {
	// customFontSemibold = Typeface.createFromAsset(
	// appContext.getAssets(), "fonts/OpenSans-Semibold.ttf");
	// }
	// return customFontSemibold;
	// }

	public static boolean isValidEmail(String target) {
		if (target == null) {
			return false;
		} else {
			return android.util.Patterns.EMAIL_ADDRESS.matcher(target)
					.matches();
		}
	}

	public static void saveAccessToken(String token, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("accessToken", token);
		editor.commit();
	}

	public static String getAccessToken(Context context) {
		if (Data.AccessToken.isEmpty()) {
			SharedPreferences pref = PreferenceManager
					.getDefaultSharedPreferences(context);
			return pref.getString("accessToken", "");
		}
		return Data.AccessToken;
	}

	public static void saveScreenName(String userName, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("userName", userName);
		editor.commit();
		Data.userName = userName;
	}

	public static String getScreenName(Context context) {
		if (Data.userName.isEmpty()) {
			SharedPreferences pref = PreferenceManager
					.getDefaultSharedPreferences(context);
			return pref.getString("userName", "");
		}
		return Data.userName;
	}

	public static void saveStatus(String AppStatus, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("AppStatus", AppStatus);
		editor.commit();
	}

	public static String getStatus(Context context) {

		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		return pref.getString("AppStatus", "");

	}

	public static void saveAdsLogin(String adsJson, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("adsJSONLogin", adsJson);
		editor.commit();
	}

	public static String getAdsLogin(Context context) {

		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		return pref.getString("adsJSONLogin", "");

	}

	public static void saveFBID(String FBID, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("FBID", FBID);
		editor.commit();
	}

	public static String getFBID(Context context) {

		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		return pref.getString("FBID", "");

	}

	public static void savefbToken(String fbToken, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("fbToken", fbToken);
		editor.commit();
	}

	public static String getfbToken(Context context) {

		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		return pref.getString("fbToken", "");

	}

	public static void setUserData(String setUserData, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putString("setUserData", setUserData);
		editor.commit();
	}

	public static String getUserData(Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);

		return pref.getString("setUserData", "");
	}

	public static void setGameMusicOnOff(boolean token, Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor editor = pref.edit();
		editor.putBoolean("GameMusicOnOff", token);
		editor.commit();
	}

	public static Boolean getGameMusicOnOff(Context context) {
		SharedPreferences pref = PreferenceManager
				.getDefaultSharedPreferences(context);

		return pref.getBoolean("GameMusicOnOff", true);
	}

	public static void commonErrorDialog(Context ctx, String msg) {
		AlertDialog dialog;
		AlertDialog.Builder builder = new AlertDialog.Builder(ctx);
		builder.setTitle("Error");
		builder.setMessage(msg).setPositiveButton("Ok",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						dialog.dismiss();
					}
				});
		// Create the AlertDialog object and return it
		dialog = builder.create();
		dialog.show();
	}

	public static void commonGameErrorDialog(Context ctx, String msg) {
		if (!((Activity) ctx).isFinishing()) {
			AlertDialog dialog;
			AlertDialog.Builder builder = new AlertDialog.Builder(ctx);
			builder.setTitle("Error");
			builder.setMessage(msg).setPositiveButton("Ok",
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int id) {
							dialog.dismiss();
						}
					});
			// Create the AlertDialog object and return it
			dialog = builder.create();
			dialog.show();
		}
	}

	public static void commonDialog(Context ctx, String title, String msg) {
		AlertDialog dialog;
		AlertDialog.Builder builder = new AlertDialog.Builder(ctx);
		builder.setTitle(title);
		builder.setMessage(msg).setPositiveButton("Ok",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						dialog.dismiss();
					}
				});
		// Create the AlertDialog object and return it
		dialog = builder.create();
		dialog.show();
	}

	public static void noInternetDialog(Context ctx) {
		AlertDialog dialog;
		AlertDialog.Builder builder = new AlertDialog.Builder(ctx);
		builder.setMessage("Please check your internet connection.")
				.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						dialog.dismiss();
					}
				});
		// Create the AlertDialog object and return it
		dialog = builder.create();
		dialog.show();
		//
		// Intent i = new Intent(ctx, offline.class);
		// ctx.startActivity(i);

		// overridePendingTransition(R.anim.from_top, R.anim.hold);

	}

	public static File getTempImageFile(String name) {
		File folder = new File(GAME_IMAGE_DIR);
		boolean success = true;
		if (!folder.exists()) {
			success = folder.mkdir();
		}
		if (success) {
			// Do something on success
		} else {
			// Do something else on failure
		}
		File file = new File(folder, name);
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return file;
	}

	public static void copyStream(InputStream input, OutputStream output)
			throws IOException {

		byte[] buffer = new byte[1024];
		int bytesRead;
		while ((bytesRead = input.read(buffer)) != -1) {
			output.write(buffer, 0, bytesRead);
		}
	}

	// public static Bitmap getUserImage(Context c) {
	// if (Data.userBitmap == null) {
	// return BitmapFactory.decodeFile(getTempImageFile()
	// .getAbsolutePath());
	// }
	// return Data.userBitmap;
	// }

	public static void loading_box(Context c, String msg) {

		pd_st = new ProgressDialog(c,
				android.R.style.Theme_Translucent_NoTitleBar_Fullscreen);
		// pd_st.getWindow().setWindowAnimations(
		// R.style.Animations_progressFadeInOut);
		pd_st.show();
		pd_st.setCancelable(false);

		// pd1_static.requestWindowFeature();

		pd_st.setContentView(R.layout.loading_box);

		// FrameLayout fl1 = (FrameLayout) pd_st.findViewById(R.id.rv);
		// new AndroidScreenSize(c, fl1, 800, 480);

		TextView t1 = (TextView) pd_st.findViewById(R.id.loadtext);

		// t1.setTypeface(CommonUtil.customFontSemibold);
		t1.setText(msg);

		// pd_st.findViewById(R.id.rlt).setAlpha(0.9f);
		((RelativeLayout) pd_st.findViewById(R.id.rlt)).setAlpha(0.9f);
	}

	public static void loading_box_stop() {
		if (pd_st != null)
			if (pd_st.isShowing())
				pd_st.dismiss();

	}

	public static Boolean is_loading_showing() {
		if (pd_st != null)
			if (pd_st.isShowing())
				return true;
		return false;

	}

	public static Bitmap decodeBase64(String input) {
		byte[] decodedByte = Base64.decode(input, 0);
		return BitmapFactory
				.decodeByteArray(decodedByte, 0, decodedByte.length);
	}

	public static String getExpirationTimeTodisplay(String expirationTime) {

		expirationTime = expirationTime.replace("T", "");
		Calendar current = Calendar.getInstance(TimeZone.getTimeZone("UTC"));

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-ddHH:mm:ss");
		sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
		try {
			cal.setTime(sdf.parse(expirationTime));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		long diffInMilis = cal.getTimeInMillis() - current.getTimeInMillis();
		long diffInSecond = diffInMilis / 1000;
		long prefix;
		String suffix;
		if (diffInSecond >= 60) {
			long diffInMinute = diffInSecond / 60;
			if (diffInMinute >= 60) {
				long diffInHour = diffInMinute / 60;
				if (diffInHour >= 24) {
					long diffInDays = diffInHour / 24;
					if (diffInDays > 365) {
						long diffInYears = diffInDays / 365;
						prefix = diffInYears;
						suffix = " year" + (diffInYears == 1 ? "" : "s");
					} else {
						prefix = diffInDays;
						suffix = " day" + (diffInDays == 1 ? "" : "s");
					}
				} else {
					prefix = diffInHour;
					suffix = " hour" + (diffInHour == 1 ? "" : "s");
				}
			} else {
				prefix = diffInMinute;
				suffix = " minute" + (diffInMinute == 1 ? "" : "s");
			}
		} else {
			prefix = diffInSecond;
			suffix = " seconds";
		}

		return prefix + suffix;
	}

	private static final AtomicInteger sNextGeneratedId = new AtomicInteger(1);

	/**
	 * Generate a value suitable for use in {@link #setId(int)}. This value will
	 * not collide with ID values generated at build time by aapt for R.id.
	 * 
	 * @return a generated ID value
	 */
	public static int generateViewId() {
		for (;;) {
			final int result = sNextGeneratedId.get();
			// aapt-generated IDs have the high byte nonzero; clamp to the range
			// under that.
			int newValue = result + 1;
			if (newValue > 0x00FFFFFF)
				newValue = 1; // Roll over to 1, not 0.
			if (sNextGeneratedId.compareAndSet(result, newValue)) {
				return result;
			}
		}
	}

	public static void saveTempImage(Bitmap bitmap) {
		OutputStream outStream = null;

		File folder = new File(GAME_IMAGE_DIR1);
		boolean success = true;
		if (!folder.exists()) {
			success = folder.mkdir();
		}
		File file = new File(folder, GAME_IMAGE_NAME);
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		File cacheDir = new File(

		GAME_IMAGE_DIR1);
		File tempFile = new File(cacheDir, GAME_IMAGE_NAME);
		if (!cacheDir.exists())
			cacheDir.mkdirs();

		try {
			outStream = new FileOutputStream(tempFile);
			bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);
			outStream.flush();
			outStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	public static File getTempImageFile() {
		File cacheDir = new File(GAME_IMAGE_DIR1);

		File file = new File(cacheDir, GAME_IMAGE_NAME);
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return file;
	}

	
	public static File createFile() {
		File cacheDir = new File(GAME_IMAGE_DIR1);

		File file = new File(cacheDir, "tempImgsm.jpg");
		if (!file.exists()) {
			try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return file;
	}
}
