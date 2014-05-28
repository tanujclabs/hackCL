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
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ListView;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class FbFriendsList extends Activity {

	FbFriendsAdapter fbFriendsAdapter;
	private ListView friendsList;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_fb_friends);
		new ASSL(FbFriendsList.this, (ViewGroup) findViewById(R.id.container), 1184,
				720, true);
		getFriendsList();
		fbFriendsAdapter = new FbFriendsAdapter(FbFriendsList.this,
				new ArrayList<FbFriend>());
		friendsList = (ListView) findViewById(R.id.friendsList);
		friendsList.setFastScrollEnabled(true);
		friendsList.setDivider(null);
		friendsList.setDividerHeight(0);
		friendsList.setAdapter(fbFriendsAdapter);
		final EditText searchBox = (EditText) findViewById(R.id.searchPeople);
		searchBox.addTextChangedListener(new TextWatcher() {
			public void afterTextChanged(Editable s) {
			}

			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				((FbFriendsAdapter) friendsList.getAdapter()).filter(searchBox
						.getText().toString());
			}
		});
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
						CommonUtil.loading_box_stop();
						try {
							parseFbFriends(new JSONObject(response));
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}

					@Override
					public void onFailure(Throwable e) {
						CommonUtil.loading_box_stop();
						Log.v("onFailure = ", e.toString());
						CommonUtil.commonErrorDialog(FbFriendsList.this,
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
			friends.add(new FbFriend(fbFrnd.getString("name"), fbFrnd
					.getString("fb_id"), fbFrnd.getString("image"), fbFrnd
					.getInt("like"), fbFrnd.getInt("dislike"), fbFrnd
					.getInt("block") == 1, true));
			fbFriendsAdapter.idMap.put(fbFrnd.getString("fb_id"),
					fbFrnd.getInt("block") == 1);
		}

		int regSize = friends.size();

		JSONArray unRegisteredFb = data.getJSONArray("unregistered");

		for (int i = 0; i < unRegisteredFb.length(); i++) {
			fbFrnd = unRegisteredFb.getJSONObject(i);
			friends.add(new FbFriend(fbFrnd.getString("name"), fbFrnd
					.getString("fb_id"), fbFrnd.getString("image"), fbFrnd
					.getInt("like"), fbFrnd.getInt("dislike"), fbFrnd
					.getInt("block") == 1, false));
		}

		if (regSize != 0) {
			friends.get(0).setShowHeader('r');
		}
		if (friends.size() > regSize) {
			friends.get(regSize).setShowHeader('u');
		}

		fbFriendsAdapter.setFriendList(friends);
		fbFriendsAdapter.notifyDataSetChanged();
	}
}
