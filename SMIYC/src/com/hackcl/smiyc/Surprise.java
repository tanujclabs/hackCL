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

import rmn.androidscreenlibrary.ASSL;
import utils.AppStatus;
import utils.CommonUtil;
import utils.Data;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.kbeanie.imagechooser.api.ChooserType;
import com.kbeanie.imagechooser.api.ChosenImage;
import com.kbeanie.imagechooser.api.ImageChooserListener;
import com.kbeanie.imagechooser.api.ImageChooserManager;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.squareup.picasso.Picasso;

public class Surprise extends Activity implements ImageChooserListener {
	private Bundle bundle;
	private ImageView imgView;
	String surprizeId = "";
	private ImageView senderImg;
	int likedStatus = 0;
	TextView name;
	LinearLayout bottomBar, topBar;
	private Button like;
	String url = "", path = "";

	Boolean likeStatusCheck = false;

	private static final int PIC_CROP = 3;

	private ImageChooserManager imageChooserManager;
	int animDuration = 400;
	private String filePath;

	Boolean doAnim = true;

	private int chooserType;
	private AlertDialog alert;
	private String senderId;
	RelativeLayout surpriseParent;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.surprise);
		new ASSL(Surprise.this, (ViewGroup) findViewById(R.id.root), 1184, 720,
				true);

		imgView = (ImageView) findViewById(R.id.imgView);
		senderImg = (ImageView) findViewById(R.id.senderImg);
		name = (TextView) findViewById(R.id.name);
		
		surpriseParent = (RelativeLayout)findViewById(R.id.surpriseParent);
		topBar = (LinearLayout) findViewById(R.id.topBar);
		bottomBar = (LinearLayout) findViewById(R.id.bottomBar);
		like = (Button) findViewById(R.id.likeAnim);
		like.setVisibility(8);
		bundle = getIntent().getExtras();
		if (getIntent().hasExtra("data")) {
			String data = bundle.getString("data");

			// Toast.makeText(getApplicationContext(), data, 50000).show();
			try {
				JSONObject js = new JSONObject(data);
				JSONArray jsArry = js.getJSONArray("data");
				surprizeId = jsArry.getJSONObject(0).getString("surprize_id");
				Picasso.with(getApplicationContext())
						.load(CommonUtil.getTempImageFile(surprizeId + ".png"))
						.error(R.drawable.bg1).placeholder(R.drawable.bg1)
						.into(imgView);

				Picasso.with(getApplicationContext())
						.load(jsArry.getJSONObject(0).getString("sender_image"))
						.error(R.drawable.user_image)
						.placeholder(R.drawable.user_image)
						.transform(new utils.CircleTransform()).fit()
						.into(senderImg);

				name.setText(jsArry.getJSONObject(0).getString("sender_name"));
				senderId = jsArry.getJSONObject(0).getString("sender_fb_id");
				url = jsArry.getJSONObject(0).getString("surprize_image");
				path = jsArry.getJSONObject(0).getString("surprize_id")
						+ ".png";
				if (!jsArry.getJSONObject(0).getString("surprize_like")
						.equalsIgnoreCase("2")) {
					bottomBar.setVisibility(8);
					likeStatusCheck = true;
				}

				// new DownloadWebPageTask().execute("");

			} catch (Exception e) {
				e.printStackTrace();
				Log.v("error", e.toString());
			}
		}
		CommonUtil.saveTempImage(BitmapFactory.decodeFile(CommonUtil
				.getTempImageFile(surprizeId + ".png").getAbsolutePath()));
	}

	public void info(View v) {
		if (doAnim) {
			if (topBar.getVisibility() == 8) {
				doAnim = false;
				// / topBar.setVisibility(0);
				// / bottomBar.setVisibility(0);

				topBar.clearAnimation();
				TranslateAnimation anim = new TranslateAnimation(0, 0, -200*ASSL.Yscale(), 0);
				anim.setDuration(animDuration);

				anim.setAnimationListener(new TranslateAnimation.AnimationListener() {

					@Override
					public void onAnimationStart(Animation animation) {
						topBar.setVisibility(0);
					}

					@Override
					public void onAnimationRepeat(Animation animation) {
					}

					@Override
					public void onAnimationEnd(Animation animation) {
						doAnim = true;
						topBar.clearAnimation();
					}
				});

				topBar.startAnimation(anim);

				bottomBar.clearAnimation();
				TranslateAnimation anim1 = new TranslateAnimation(0, 0, 120*ASSL.Yscale(), 0);
				anim1.setDuration(animDuration);

				anim1.setAnimationListener(new TranslateAnimation.AnimationListener() {

					@Override
					public void onAnimationStart(Animation animation) {
						bottomBar.setVisibility(0);
					}

					@Override
					public void onAnimationRepeat(Animation animation) {
					}

					@Override
					public void onAnimationEnd(Animation animation) {
						bottomBar.clearAnimation();

					}
				});
				if (!likeStatusCheck)
					bottomBar.startAnimation(anim1);

			} else {
				doAnim = false;

				// / topBar.setVisibility(0);
				// / bottomBar.setVisibility(0);

				topBar.clearAnimation();
				TranslateAnimation anim = new TranslateAnimation(0, 0, 0, -200*ASSL.Yscale());
				anim.setDuration(animDuration);

				anim.setAnimationListener(new TranslateAnimation.AnimationListener() {

					@Override
					public void onAnimationStart(Animation animation) {

					}

					@Override
					public void onAnimationRepeat(Animation animation) {
					}

					@Override
					public void onAnimationEnd(Animation animation) {
						doAnim = true;
						topBar.setVisibility(8);
						topBar.clearAnimation();
					}
				});

				topBar.startAnimation(anim);

				bottomBar.clearAnimation();
				TranslateAnimation anim1 = new TranslateAnimation(0, 0, 0, 120*ASSL.Yscale());
				anim1.setDuration(animDuration);

				anim1.setAnimationListener(new TranslateAnimation.AnimationListener() {

					@Override
					public void onAnimationStart(Animation animation) {

					}

					@Override
					public void onAnimationRepeat(Animation animation) {
					}

					@Override
					public void onAnimationEnd(Animation animation) {
						bottomBar.setVisibility(8);
						bottomBar.clearAnimation();

					}
				});
				if (!likeStatusCheck)
					bottomBar.startAnimation(anim1);
			}
		}
	}

	public void like(View v) {
		likedStatus = 1;
		like_dislike("1");
	}

	public void dislike(View v) {
		likedStatus = 0;
		like_dislike("0");
	}

	public void forward(View v) {

		Intent i = new Intent(getApplicationContext(), SelectFriends.class);
		startActivity(i);
	}

	public void reply(View v) {
		choose(v);
	}

	public void close(View v) {
		finish();
	}

	public void like_dislike(String likeStatus) {

		if (!AppStatus.getInstance(getApplicationContext()).isOnline(
				getApplicationContext())) {
			CommonUtil.noInternetDialog(Surprise.this);
			return;
		}
		
		if (likedStatus == 1) {
			like.setBackgroundResource(R.drawable.like_image);
			
		} else {
			like.setBackgroundResource(R.drawable.dislike_image);
			
		}
		like.setVisibility(0);
		Animation anim=AnimationUtils.loadAnimation(getApplicationContext(), R.anim.bounce);
		like.startAnimation(anim);
	//	CommonUtil.loading_box(this, "Please wait...");

		RequestParams rv = new RequestParams();
		// (0 for dislike,1for like)

		rv.put("like", likeStatus);
		rv.put("surprize_id", surprizeId);
		rv.put("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));

		Log.v("like", likeStatus);
		Log.v("surprize_id", surprizeId);
		Log.v("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "like_surprize", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {
						likeStatusCheck = true;
						//CommonUtil.loading_box_stop();
						bottomBar.setVisibility(4);
						if (likedStatus == 1) {
							like.setBackgroundResource(R.drawable.like_image);
							Toast.makeText(getApplicationContext(),
									"Liked Successfully", 5000).show();
						} else {
							like.setBackgroundResource(R.drawable.dislike_image);
							Toast.makeText(getApplicationContext(),
									"Disliked Successfully", 5000).show();
						}
						like.setVisibility(0);
						new Handler().postDelayed(new Runnable() {
							@Override
							public void run() {
								like.setVisibility(8);
								like.clearAnimation();
							}
						}, 1000);
						Log.v("like response = ", response + ",");

					}

					@Override
					public void onFailure(Throwable e) {
						CommonUtil.loading_box_stop();

						Log.v("like onFailure = ", e.toString());

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

	public void choose(View v) {

		//Animation anim = AnimationUtils.loadAnimation(getApplicationContext(), R.anim.bounce);
		//surpriseParent.startAnimation(anim);
		
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Choose")

				.setCancelable(true)
				.setPositiveButton("Camera",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {

								takePicture();
								alert.cancel();

							}
						})
				.setNegativeButton("Gallery",
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int id) {

								chooseImage();
								alert.cancel();

							}
						});
		alert = builder.create();
		alert.show();

	}

	private void chooseImage() {
		chooserType = ChooserType.REQUEST_PICK_PICTURE;
		imageChooserManager = new ImageChooserManager(this,
				ChooserType.REQUEST_PICK_PICTURE, "myfolder", true);
		imageChooserManager.setImageChooserListener(this);
		try {

			filePath = imageChooserManager.choose();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void takePicture() {
		chooserType = ChooserType.REQUEST_CAPTURE_PICTURE;
		imageChooserManager = new ImageChooserManager(this,
				ChooserType.REQUEST_CAPTURE_PICTURE, "myfolder", true);
		imageChooserManager.setImageChooserListener(this);
		try {

			filePath = imageChooserManager.choose();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == RESULT_OK) {
			Log.v("result ok", "result ok");
			if (requestCode == ChooserType.REQUEST_PICK_PICTURE
					|| requestCode == ChooserType.REQUEST_CAPTURE_PICTURE) {
				Log.v("requestCode", "requestCode");
				if (imageChooserManager == null) {
					reinitializeImageChooser();
				}
				imageChooserManager.submit(requestCode, data);
			} else if (requestCode == PIC_CROP) {
				sendSurprise(senderId);
			} else {
				Log.v("In no one", "in no one");
			}
		}
	}

	public void sendSurprise(String friendIdList) {
		try {

			if (!AppStatus.getInstance(getApplicationContext()).isOnline(
					getApplicationContext())) {
				CommonUtil.noInternetDialog(Surprise.this);
				return;
			}

			CommonUtil.loading_box(this, "Sending...");

			RequestParams rv = new RequestParams();
			rv.put("friend_id", friendIdList);
			rv.put("useraccesstoken",
					CommonUtil.getAccessToken(getApplicationContext()));
			rv.put("image", CommonUtil.getTempImageFile());

			Log.v("fb_id", friendIdList);
			Log.v("useraccesstoken",
					CommonUtil.getAccessToken(getApplicationContext()));
			Log.v("image", CommonUtil.getTempImageFile() + "");

			AsyncHttpClient client = new AsyncHttpClient();

			client.setTimeout(100000);
			client.post(Data.baseUrl + "send_surprize", rv,
					new AsyncHttpResponseHandler() {

						@Override
						public void onSuccess(String response) {
							CommonUtil.loading_box_stop();
							try {
								JSONObject js = new JSONObject(response);
								if (js.has("log")) {
									Toast.makeText(getApplicationContext(),
											js.getString("log"),
											Toast.LENGTH_SHORT).show();
								} else if (js.has("error")) {
									Toast.makeText(getApplicationContext(),
											js.getString("error"),
											Toast.LENGTH_SHORT).show();
								}
							} catch (Exception e) {
								// TODO: handle exception
							}

						}

						@Override
						public void onFailure(Throwable e) {
							Log.v("onFailure = ", e.toString());
							CommonUtil.loading_box_stop();
							CommonUtil.commonErrorDialog(Surprise.this,
									"An error occurred. Please try later.");
						}

					});
		} catch (Exception e) {
			Log.v("hello error", e.toString());
		}
	}

	private void performCrop(Uri picUri) {
		try {
			Intent cropIntent = new Intent("com.android.camera.action.CROP");
			// indicate image type and Uri
			cropIntent.setDataAndType(picUri, "image/*");
			// set crop properties
			cropIntent.putExtra("crop", "true");
			// indicate aspect of desired crop
			cropIntent.putExtra("aspectX", 1);
			cropIntent.putExtra("aspectY", 1.6);
			// indicate output X and Y
			cropIntent.putExtra("outputX", 400);
			cropIntent.putExtra("outputY", 640);
			// retrieve data on return
			cropIntent.putExtra("return-data", false);

			Uri destination;
			destination = Uri.fromFile(CommonUtil.getTempImageFile());
			// some code to retriev an valid Uri
			cropIntent.putExtra(MediaStore.EXTRA_OUTPUT, destination);

			// start the activity - we handle returning in onActivityResult
			startActivityForResult(cropIntent, PIC_CROP);
		}
		// respond to users whose devices do not support the crop action
		catch (ActivityNotFoundException anfe) {
			// display an error message
			String errorMessage = "Whoops - your device doesn't support the crop action!";
			Toast toast = Toast
					.makeText(this, errorMessage, Toast.LENGTH_SHORT);
			toast.show();
		}
	}

	@Override
	public void onImageChosen(final ChosenImage image) {
		runOnUiThread(new Runnable() {

			@Override
			public void run() {

				if (image != null) {

					performCrop(Uri.fromFile(new File(image
							.getFilePathOriginal())));
				}
			}
		});
	}

	@Override
	public void onError(final String reason) {
		runOnUiThread(new Runnable() {

			@Override
			public void run() {

				Toast.makeText(Surprise.this, reason, Toast.LENGTH_LONG).show();
			}
		});
	}

	// Should be called if for some reason the ImageChooserManager is null (Due
	// to destroying of activity for low memory situations)
	private void reinitializeImageChooser() {
		imageChooserManager = new ImageChooserManager(this, chooserType,
				"myfolder", true);
		imageChooserManager.setImageChooserListener(this);
		imageChooserManager.reinitialize(filePath);
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		outState.putInt("chooser_type", chooserType);
		outState.putString("media_path", filePath);
		super.onSaveInstanceState(outState);
	}

	@Override
	protected void onRestoreInstanceState(Bundle savedInstanceState) {
		if (savedInstanceState != null) {
			if (savedInstanceState.containsKey("chooser_type")) {
				chooserType = savedInstanceState.getInt("chooser_type");
			}

			if (savedInstanceState.containsKey("media_path")) {
				filePath = savedInstanceState.getString("media_path");
			}
		}
		super.onRestoreInstanceState(savedInstanceState);
	}
}
