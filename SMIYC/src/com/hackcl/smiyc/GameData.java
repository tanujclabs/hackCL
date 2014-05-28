package com.hackcl.smiyc;

import java.io.File;
import java.util.List;

import utils.CommonUtil;
import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;

public class GameData {

	// public static String server =
	// "http://production.click-labs.com/puzzle-pics/";

	public static String server = "http://dev.puzzlepic.com/v1/";

	public static Bitmap photo;

	/* Login credentials */
	public static String userId = "";
	public static String userName;
	public static String email;
	public static String userImage;
	public static String phoneNo;
	public static int coins;
	public static String rank;
	public static int freezePowerCount;
	public static int magnetPowerCount;
	public static int goldenPuzzleCount;
	public static boolean contactAccess;
	public static String accessToken;
	public static Bitmap profilePic;
	public static int puzzlesSolved;
	public static MediaPlayer mp;
	public static String deviceToken;
	public static String fbId = "0";
	public static String fbName;

	public static List<FbFriend> fbFriends;

	public static int regStartFb;
	public static int unRegStartFb;
	public static int regStartCont;
	public static int unRegStartCont;

	public static File mFileTemp;

	// For Twitter
	public static Bundle resultData;
	public static boolean returnFromTwitter = false;
	public static boolean twitterTokenPresent = false;

	// Caching
	public static String gameJson;
	public static Bitmap gameImage;
	public static Bitmap opponentImage;

	public static boolean refreshData = false;
	public static int clicksound;
	public static boolean soundon = true;
	public static int open_game_sound;
	public static int camera_click;
	public static int drop_puzzle;
	public static int magnetlight;
	public static int whichSong = 0;

	public static boolean musicon = true;

	public static String hint = "";

	public static int currentCamera = 0;

	// public static boolean overlappSound=false;

	// 1 for main menu activity (user home)
	// 2 for shop screen
	// 3 for game play screen

	public static void checkOtherMusicIsOn(Context c) {
		AudioManager manager = (AudioManager) c
				.getSystemService(Context.AUDIO_SERVICE);
		Log.v("class= ", manager.getClass().getPackage() + ",");

		if (manager.isMusicActive()) { // do something - or do it not

			int k = 0;
			ActivityManager am = (ActivityManager) c
					.getSystemService(Context.ACTIVITY_SERVICE);
			List<ActivityManager.RunningServiceInfo> rs = am
					.getRunningServices(50);

			for (int i = 0; i < rs.size(); i++) {
				ActivityManager.RunningServiceInfo rsi = rs.get(i);
				// Log.i("Service", "Process " + rsi.process +
				// " with component " + rsi.service.getClassName());
				// Log.v("is foreground = ",rsi.foreground+",  "+rsi.clientPackage+",  "+rsi.describeContents()+",  "+rsi.getClass());
				if (rsi.foreground) {
					// Log.v("is foreground = ",
					// rsi.foreground + ",  " + rsi.clientPackage + ",  "
					// + rsi.describeContents() + ",  "
					// + rsi.getClass() + "," + rsi.clientCount
					// + ",opid =" + rsi.pid + ",");

					k = 1;

					if (rsi.process.toString().equalsIgnoreCase(
							"com.goldgorillastudios.puzzlepic.util")) {
						k = 0;
						break;
					}

				}

			}
			if (k == 1) {
				CommonUtil.setGameMusicOnOff(false, c);
				GameData.musicon = false;
			}

		}
	}
}
