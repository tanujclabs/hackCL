///*******************************************************************************
// * Copyright 2013 Kumar Bibek
// *
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *    
// * http://www.apache.org/licenses/LICENSE-2.0
// * 	
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// *******************************************************************************/
//
//package com.hackcl.smiyc;
//
//import java.io.File;
//
//import utils.CommonUtil;
//
//import android.app.Activity;
//import android.content.ActivityNotFoundException;
//import android.content.Intent;
//import android.graphics.Bitmap;
//import android.net.Uri;
//import android.os.Bundle;
//import android.view.View;
//import android.view.View.OnClickListener;
//import android.widget.Button;
//import android.widget.ImageView;
//import android.widget.ProgressBar;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import com.kbeanie.imagechooser.api.ChooserType;
//import com.kbeanie.imagechooser.api.ChosenImage;
//import com.kbeanie.imagechooser.api.ImageChooserListener;
//import com.kbeanie.imagechooser.api.ImageChooserManager;
//
//public class ImageChooserActivity extends Activity implements
//		ImageChooserListener {
//
//	private static final int PIC_CROP = 3;
//
//	private ImageView imageViewThumbnail;
//
//	private ImageView imageViewThumbSmall;
//
//	private TextView textViewFile;
//
//	private ImageChooserManager imageChooserManager;
//
//	private ProgressBar pbar;
//
//	private String filePath;
//
//	private int chooserType;
//
//	@Override
//	protected void onCreate(Bundle savedInstanceState) {
//		super.onCreate(savedInstanceState);
//		setContentView(R.layout.activity_image_chooser);
//
//		Button buttonTakePicture = (Button) findViewById(R.id.buttonTakePicture);
//		buttonTakePicture.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				takePicture();
//			}
//		});
//		Button buttonChooseImage = (Button) findViewById(R.id.buttonChooseImage);
//		buttonChooseImage.setOnClickListener(new OnClickListener() {
//
//			@Override
//			public void onClick(View v) {
//				chooseImage();
//			}
//		});
//
//		imageViewThumbnail = (ImageView) findViewById(R.id.imageViewThumb);
//		imageViewThumbSmall = (ImageView) findViewById(R.id.imageViewThumbSmall);
//		textViewFile = (TextView) findViewById(R.id.textViewFile);
//
//		pbar = (ProgressBar) findViewById(R.id.progressBar);
//		pbar.setVisibility(View.GONE);
//
//	}
//
//	private void chooseImage() {
//		chooserType = ChooserType.REQUEST_PICK_PICTURE;
//		imageChooserManager = new ImageChooserManager(this,
//				ChooserType.REQUEST_PICK_PICTURE, "myfolder", true);
//		imageChooserManager.setImageChooserListener(this);
//		try {
//			pbar.setVisibility(View.VISIBLE);
//			filePath = imageChooserManager.choose();
//		} catch (IllegalArgumentException e) {
//			e.printStackTrace();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//
//	private void takePicture() {
//		chooserType = ChooserType.REQUEST_CAPTURE_PICTURE;
//		imageChooserManager = new ImageChooserManager(this,
//				ChooserType.REQUEST_CAPTURE_PICTURE, "myfolder", true);
//		imageChooserManager.setImageChooserListener(this);
//		try {
//			pbar.setVisibility(View.VISIBLE);
//			filePath = imageChooserManager.choose();
//		} catch (IllegalArgumentException e) {
//			e.printStackTrace();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}
//
//	@Override
//	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//		if (resultCode == RESULT_OK) {
//			if (requestCode == ChooserType.REQUEST_PICK_PICTURE
//					|| requestCode == ChooserType.REQUEST_CAPTURE_PICTURE) {
//				if (imageChooserManager == null) {
//					reinitializeImageChooser();
//				}
//				imageChooserManager.submit(requestCode, data);
//			} else if (requestCode == PIC_CROP) {
//				if (data != null) {
//					// get the returned data
//					Bundle extras = data.getExtras();
//					// get the cropped bitmap
//					Bitmap selectedBitmap = extras.getParcelable("data");
//					CommonUtil.saveTempImage(selectedBitmap);
//				}
//			}
//		} else {
//			pbar.setVisibility(View.GONE);
//		}
//	}
//
//	private void performCrop(Uri picUri) {
//		try {
//			Intent cropIntent = new Intent("com.android.camera.action.CROP");
//			// indicate image type and Uri
//			cropIntent.setDataAndType(picUri, "image/*");
//			// set crop properties
//			cropIntent.putExtra("crop", "true");
//			// indicate aspect of desired crop
//			cropIntent.putExtra("aspectX", 1);
//			cropIntent.putExtra("aspectY", 1.5);
//			// indicate output X and Y
//			cropIntent.putExtra("outputX", 128);
//			cropIntent.putExtra("outputY", 192);
//			// retrieve data on return
//			cropIntent.putExtra("return-data", true);
//			// start the activity - we handle returning in onActivityResult
//			startActivityForResult(cropIntent, PIC_CROP);
//		}
//		// respond to users whose devices do not support the crop action
//		catch (ActivityNotFoundException anfe) {
//			// display an error message
//			String errorMessage = "Whoops - your device doesn't support the crop action!";
//			Toast toast = Toast
//					.makeText(this, errorMessage, Toast.LENGTH_SHORT);
//			toast.show();
//		}
//	}
//
//	@Override
//	public void onImageChosen(final ChosenImage image) {
//		runOnUiThread(new Runnable() {
//
//			@Override
//			public void run() {
//				pbar.setVisibility(View.GONE);
//				if (image != null) {
//					textViewFile.setText(image.getFilePathOriginal());
//					imageViewThumbnail.setImageURI(Uri.parse(new File(image
//							.getFileThumbnail()).toString()));
//					imageViewThumbSmall.setImageURI(Uri.parse(new File(image
//							.getFileThumbnailSmall()).toString()));
//					performCrop(Uri.fromFile(new File(image
//							.getFilePathOriginal())));
//				}
//			}
//		});
//	}
//
//	@Override
//	public void onError(final String reason) {
//		runOnUiThread(new Runnable() {
//
//			@Override
//			public void run() {
//				pbar.setVisibility(View.GONE);
//				Toast.makeText(ImageChooserActivity.this, reason,
//						Toast.LENGTH_LONG).show();
//			}
//		});
//	}
//
//	// Should be called if for some reason the ImageChooserManager is null (Due
//	// to destroying of activity for low memory situations)
//	private void reinitializeImageChooser() {
//		imageChooserManager = new ImageChooserManager(this, chooserType,
//				"myfolder", true);
//		imageChooserManager.setImageChooserListener(this);
//		imageChooserManager.reinitialize(filePath);
//	}
//
//	@Override
//	protected void onSaveInstanceState(Bundle outState) {
//		outState.putInt("chooser_type", chooserType);
//		outState.putString("media_path", filePath);
//		super.onSaveInstanceState(outState);
//	}
//
//	@Override
//	protected void onRestoreInstanceState(Bundle savedInstanceState) {
//		if (savedInstanceState != null) {
//			if (savedInstanceState.containsKey("chooser_type")) {
//				chooserType = savedInstanceState.getInt("chooser_type");
//			}
//
//			if (savedInstanceState.containsKey("media_path")) {
//				filePath = savedInstanceState.getString("media_path");
//			}
//		}
//		super.onRestoreInstanceState(savedInstanceState);
//	}
//}
