package com.hackcl.smiyc;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import rmn.androidscreenlibrary.ASSL;

import utils.AppStatus;
import utils.CommonUtil;
import utils.Data;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class SelectFriends extends Activity {

	AddedFriendAdapter addedFriendsAdapter;
	private ListView friendsList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_select_friends);
		new ASSL(SelectFriends.this, (ViewGroup) findViewById(R.id.container),
				1184, 720, true);
		friendsList = (ListView) findViewById(R.id.friendList);
		friendsList.setAdapter(addedFriendsAdapter);
		getFriendsList();
	}

	public void onClick(View view) {
		StringBuilder builder = new StringBuilder();
		for (int i = 0; i < addedFriendsAdapter.isSelected.length; i++) {
			if (addedFriendsAdapter.isSelected[i]) {
				builder.append(addedFriendsAdapter.friendList.get(i).id + ",");
			}
		}
		if (builder.length() == 0) {
			Toast.makeText(getApplicationContext(),
					"Please select atleast friend.", Toast.LENGTH_SHORT).show();
		} else {
			sendSurprise(builder.substring(0, builder.length() - 1).toString());
		}
	}

	public void sendSurprise(String friendIdList) {
		try {
			
			if (!AppStatus.getInstance(getApplicationContext()).isOnline(
					getApplicationContext())) {
				CommonUtil.noInternetDialog(SelectFriends.this);
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
								JSONObject js=new JSONObject(response);
								if(js.has("log"))
								{
								
								CommonUtil.commonDialog(SelectFriends.this, "Done", js.getString("log"));
								
								}
								else if(js.has("error"))
								{
									Toast.makeText(getApplicationContext(), js.getString("error"),
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
							CommonUtil.commonErrorDialog(SelectFriends.this,
									"An error occurred. Please try later.");
						}

					});
		} catch (Exception e) {
			Log.v("hello error", e.toString());
		}
	}

	public void getFriendsList() {

		if (!AppStatus.getInstance(getApplicationContext()).isOnline(
				getApplicationContext())) {
			CommonUtil.noInternetDialog(this);
			return;
		}

		CommonUtil.loading_box(this, "Please wait...");

		RequestParams rv = new RequestParams();
		rv.put("fb_id", CommonUtil.getFBID(getApplicationContext()));
		rv.put("fbaccesstoken", CommonUtil.getfbToken(getApplicationContext()));
		rv.put("useraccesstoken",
				CommonUtil.getAccessToken(getApplicationContext()));

		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "registrationStatus", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {
						try {
							CommonUtil.loading_box_stop();
							parseFbFriends(new JSONObject(response));
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());
						CommonUtil.loading_box_stop();
						CommonUtil.commonErrorDialog(SelectFriends.this,
								"An error occurred. Please try later.");
					}
				});
	}

	private void parseFbFriends(JSONObject data) throws JSONException {
		List<FbFriend> friends = new ArrayList<FbFriend>();
		JSONObject fbFrnd;
		JSONArray registeredFbFriends = data.getJSONArray("registered");
		for (int i = 0; i < registeredFbFriends.length(); i++) {
			fbFrnd = registeredFbFriends.getJSONObject(i);
			if (fbFrnd.getInt("block") == 0) {
				friends.add(new FbFriend(fbFrnd.getString("name"), fbFrnd
						.getString("fb_id"), fbFrnd.getString("image"), fbFrnd
						.getInt("like"), fbFrnd.getInt("dislike"), false, true));
			}
		}

		addedFriendsAdapter = new AddedFriendAdapter(SelectFriends.this,
				friends);
		friendsList.setAdapter(addedFriendsAdapter);
	}

}
