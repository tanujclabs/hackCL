package com.hackcl.smiyc;

import java.io.File;

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
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
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

public class MainScreen extends Activity implements ImageChooserListener {
	private Bundle bundle;
	ImageView userImg;
	TextView likes, dislikes, name;
	private TextView appStatus;
	Button indictor;

	private static final int PIC_CROP = 3;

	private ImageChooserManager imageChooserManager;

	private String filePath;

	private int chooserType;
	private AlertDialog alert;
	RelativeLayout surpriseParent;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main_screen);
		new ASSL(MainScreen.this, (ViewGroup) findViewById(R.id.root), 1184,
				720, true);

		userImg = (ImageView) findViewById(R.id.userImg);
		likes = (TextView) findViewById(R.id.likes);
		dislikes = (TextView) findViewById(R.id.dislike);
		name = (TextView) findViewById(R.id.name);
		appStatus = (TextView) findViewById(R.id.appStatus);
		surpriseParent = (RelativeLayout) findViewById(R.id.surpriseParent);
		indictor = (Button) findViewById(R.id.indictor);

		Intent intent = getIntent();
		String action = intent.getAction();
		String type = intent.getType();

		if (Intent.ACTION_SEND.equals(action) && type != null) {
			if (type.startsWith("image/")) {
				setfields(CommonUtil.getUserData(getApplicationContext()));
				handleSendImage(intent); // Handle single image being sent
			}

		} else {

			// Handle other intents, such as being started from the home
			// screen

			bundle = getIntent().getExtras();

			if (getIntent().hasExtra("data")) {
				String data = bundle.getString("data");

				setfields(data);

			}
		}

	}

	public void parentClick(View view) {
		Animation anim = AnimationUtils.loadAnimation(getApplicationContext(),
				R.anim.anim_compress);
		anim.setAnimationListener(new AnimationListener() {

			@Override
			public void onAnimationStart(Animation animation) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationRepeat(Animation animation) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onAnimationEnd(Animation animation) {
				Handler handler = new Handler();
				handler.postDelayed(new Runnable() {

					@Override
					public void run() {
						choose(null);
					}
				}, 200);
			}
		});
		surpriseParent.startAnimation(anim);
	}

	public void setfields(String data) {
		try {
			JSONObject js = new JSONObject(data);
			JSONArray jsArry = js.getJSONArray("data");

			Picasso.with(getApplicationContext())
					.load(jsArry.getJSONObject(0).getString("image"))
					.error(R.drawable.user_image)
					.transform(new utils.CircleTransform()).fit()
					.placeholder(R.drawable.user_image).into(userImg);

			likes.setText(jsArry.getJSONObject(0).getString("like"));
			dislikes.setText(jsArry.getJSONObject(0).getString("dislike"));
			name.setText(jsArry.getJSONObject(0).getString("username"));

			if (CommonUtil.getStatus(getApplicationContext()).equals("1")) {
				appStatus.setText("Disable Surprizes");
				indictor.setBackgroundResource(R.drawable.green);
			} else {
				appStatus.setText("Enable Surprizes");
				indictor.setBackgroundResource(R.drawable.red);
			}

		} catch (Exception e) {
			Log.v("error", e.toString());
		}
	}

	void handleSendImage(Intent intent) {
		Uri imageUri = (Uri) intent.getParcelableExtra(Intent.EXTRA_STREAM);
		if (imageUri != null) {
			// Update UI to reflect image being shared
			performCrop(imageUri);

		}
	}

	public void choose(View v) {

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

	public void status(View v) {
		if (CommonUtil.getStatus(getApplicationContext()).equalsIgnoreCase("1")) {
			AppStatus("0");
		} else {
			AppStatus("1");
		}
	}

	public void AppStatus(final String status) {

		if (!AppStatus.getInstance(getApplicationContext()).isOnline(
				getApplicationContext())) {
			CommonUtil.noInternetDialog(MainScreen.this);
			return;
		}

		CommonUtil.loading_box(this, "Please wait...");

		RequestParams rv = new RequestParams();

		rv.put("status", status);
		rv.put("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));

		Log.v("useraccesstoken", Data.regid);

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "setnotification", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {
						CommonUtil.loading_box_stop();
						Log.v("response = ", response + ",");

						CommonUtil.saveStatus(status, getApplicationContext());
						if (CommonUtil.getStatus(getApplicationContext())
								.equals("1")) {
							appStatus.setText("Disable Surprizes");
							indictor.setBackgroundResource(R.drawable.green);
						} else {
							appStatus.setText("Enable Surprizes");
							indictor.setBackgroundResource(R.drawable.red);
						}

					}

					@Override
					public void onFailure(Throwable e) {
						CommonUtil.loading_box_stop();
						Log.v("onFailure = ", e.toString());

					}

				});
	}

	public void frnds(View v) {

		Intent i = new Intent(getApplicationContext(), FbFriendsList.class);
		startActivity(i);
	}

	public void recent(View v) {
		Intent i = new Intent(getApplicationContext(), pastSurprizes.class);
		startActivity(i);
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
				Log.v("PIC_CROP", "PIC_CROP");
				// if (data != null) {
				// Log.v("PIC_CROP ! null", "PIC_CROP !null");
				// // get the returned data
				// Bundle extras = data.getExtras();
				// // get the cropped bitmap
				// Bitmap selectedBitmap = extras.getParcelable("data");
				// selectedBitmap = Bitmap
				// .createScaledBitmap(
				// selectedBitmap,
				// 400,
				// (int) (((float) selectedBitmap.getHeight() / (float)
				// selectedBitmap
				// .getWidth()) * 400), false);
				//
				// CommonUtil.saveTempImage(selectedBitmap);
				// Log.v("startActivity", "startActivity");
				// Intent i = new Intent(getApplicationContext(),
				// SelectFriends.class);
				// startActivity(i);
				//
				// }

				Intent i = new Intent(getApplicationContext(),
						SelectFriends.class);
				startActivity(i);
			} else {
				Log.v("In no one", "in no one");
			}
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

				Toast.makeText(MainScreen.this, reason, Toast.LENGTH_LONG)
						.show();
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
