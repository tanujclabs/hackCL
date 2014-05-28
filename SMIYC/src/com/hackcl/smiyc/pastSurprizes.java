package com.hackcl.smiyc;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;

import org.json.JSONObject;

import rmn.androidscreenlibrary.ASSL;
import utils.AppStatus;
import utils.CommonUtil;
import utils.Data;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.squareup.picasso.Picasso;

public class pastSurprizes extends Activity {

	ArrayList<String> f = new ArrayList<String>();// list of file paths
	File[] listFile;
	private countryAdapter countiesadepter;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.past);
		new ASSL(this, (ViewGroup) findViewById(R.id.root), 1184, 720, true);

		getFromSdcard();

	}

	public void getFromSdcard() {
		File file = new File(CommonUtil.GAME_IMAGE_DIR);

		if (file.isDirectory()) {
			listFile = file.listFiles();

			for (int i = 0; i < listFile.length; i++) {

				f.add(listFile[i].getName());
				Log.v("images = ", listFile[i].getName());

			}
			
			Collections.reverse(f);
			GridView list = (GridView) findViewById(R.id.grid);
			countiesadepter = new countryAdapter(f, this);
			list.setAdapter(countiesadepter);

		}
	}

	public class countryAdapter extends BaseAdapter {
		Context context;

		ArrayList<String> names = new ArrayList<String>();

		private LayoutInflater inflater;

		public countryAdapter(ArrayList<String> name, Context c) {
			context = c;
			names = name;

			inflater = (LayoutInflater) c
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		}

		public int getCount() {
			// TODO Auto-generated method stub
			return names.size();
		}

		@Override
		public Object getItem(int arg0) {
			// TODO Auto-generated method stub
			return names.get(arg0);
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return arg0;
		}

		class ViewHolder {
			ImageView img;
			RelativeLayout rlt;
			int p;
		}

		@Override
		public View getView(int arg0, View convertView, ViewGroup arg2) {

			final ViewHolder holder;

			if (convertView == null) {
				LayoutInflater inflater = (LayoutInflater) context
						.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				convertView = inflater.inflate(R.layout.country_listitem, null);
				holder = new ViewHolder();
				// if (arg1 == null)

				holder.rlt = (RelativeLayout) convertView
						.findViewById(R.id.root);

				holder.img = (ImageView) convertView.findViewById(R.id.img);

				holder.rlt.setLayoutParams(new AbsListView.LayoutParams(360,
						360));
			
				ASSL.DoMagic(holder.rlt);
				holder.p = arg0;
				holder.rlt.setTag(holder);
				convertView.setTag(holder);

				holder.rlt.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						ViewHolder holder1 = (ViewHolder) v.getTag();

						 

						getSurprise(names.get(holder1.p).split(".png")[0]);

					}
				});

			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.p = arg0;

			Picasso.with(context)
					.load(CommonUtil.getTempImageFile(names.get(arg0))).resize(300, 300).centerCrop()
					.into(holder.img);

			return convertView;
		}

	}

	public void getSurprise(String surpise_id) {

		if (!AppStatus.getInstance(getApplicationContext()).isOnline(
				getApplicationContext())) {
			CommonUtil.noInternetDialog(this);
			return;
		}

		CommonUtil.loading_box(this, "Loading...");

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
					public void onSuccess(String response) {
						try {
							CommonUtil.loading_box_stop();
							Log.v("surprize response", response);
							JSONObject js = new JSONObject(response);
							if (!js.has("error")) {
								Log.v("response = ", response + ",");

								Intent notificationIntent = new Intent(
										getApplicationContext(), Surprise.class);
								notificationIntent.putExtra("data", response);

								startActivity(notificationIntent);

							}

						} catch (Exception e) {

						}

					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());
						CommonUtil.loading_box_stop();
					}

				});
	}

}
