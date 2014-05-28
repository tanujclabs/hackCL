package com.hackcl.smiyc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import rmn.androidscreenlibrary.ASSL;

import utils.AppStatus;
import utils.CommonUtil;
import utils.Data;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActionBar.LayoutParams;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.ImageOptions;
import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.Session;
import com.facebook.SessionState;
import com.facebook.widget.WebDialog;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.squareup.picasso.Picasso;

public class FbFriendsAdapter extends BaseAdapter {

	List<FbFriend> friendList;
	List<FbFriend> friendListTemp;
	List<FbFriend> searchResults;
	AQuery query;
	int headerVar;
	Activity activity;
	int previous;
	ImageOptions options;
	private WebDialog dialog;
	public Map<String, Boolean> idMap;

	public FbFriendsAdapter(Activity activity, List<FbFriend> data) {
		this.friendList = data;
		this.activity = activity;
		searchResults = new ArrayList<FbFriend>();
		query = new AQuery(activity);
		options = new ImageOptions();
		options.round = 20;
		options.fileCache = true;
		options.memCache = true;
		options.targetWidth = 100;
		options.fallback = R.drawable.ic_launcher;
		idMap = new HashMap<String, Boolean>();
	}

	@Override
	public int getCount() {
		return friendList.size();
	}

	@Override
	public FbFriend getItem(int position) {
		return friendList.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public static class ViewHolder {
		public TextView name;
		public TextView nameUnreg;
		public TextView likes;
		public TextView disLikes;
		public ImageView friendImage;
		public Button header;
		public Button invite,poke;
		RelativeLayout root;
		LinearLayout likeHead,dislikeHead;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {

		final ViewHolder holder;

		final FbFriend friend = friendList.get(position);

		if (convertView == null) {
			LayoutInflater inflater = (LayoutInflater) activity
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.fb_friend_item, null);
			
			holder = new ViewHolder();
			holder.root=(RelativeLayout)convertView.findViewById(R.id.root);
			holder.root.setLayoutParams(new AbsListView.LayoutParams(720,
					LayoutParams.WRAP_CONTENT));
		
			ASSL.DoMagic(holder.root);
			
			
			holder.likeHead = (LinearLayout) convertView.findViewById(R.id.likesHead);
			holder.dislikeHead = (LinearLayout) convertView.findViewById(R.id.DisLikesHead);
			
			
			holder.name = (TextView) convertView.findViewById(R.id.friendName);
			holder.nameUnreg = (TextView) convertView
					.findViewById(R.id.friendNameUnReg);
			holder.likes = (TextView) convertView.findViewById(R.id.noOfLikes);
			holder.disLikes = (TextView) convertView
					.findViewById(R.id.noOfDisLikes);
			holder.friendImage = (ImageView) convertView
					.findViewById(R.id.friendImage);
			holder.header = (Button) convertView.findViewById(R.id.header);
			holder.invite = (Button) convertView.findViewById(R.id.inviteReg);
			holder.poke = (Button) convertView.findViewById(R.id.poke);
			
			holder.poke.setTag(holder);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.invite.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {

				if (!AppStatus.getInstance(activity.getApplicationContext())
						.isOnline(activity.getApplicationContext())) {
					CommonUtil.commonErrorDialog(activity,
							"Please check your internet connectivity.");
					return;
				}

				if (friend.registered) {
					blocktoggle(friend, friend.block ? 0 : 1, holder);
				} else {
					Bundle params = new Bundle();
					params.putString("message", "Hey " + friend.getName()
							+ " check out SMIYC and surprise your friends!!");
					params.putString("to", friend.getId());
					showDialogWithoutNotificationBar("apprequests", params);
				}
			}
		});
		
		if (!friend.registered)
			holder.poke.setVisibility(8);
		else
			holder.poke.setVisibility(0);
		
		

		holder.poke.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				ViewHolder holder11=(ViewHolder)v.getTag();
				if (!AppStatus.getInstance(activity.getApplicationContext())
						.isOnline(activity.getApplicationContext())) {
					CommonUtil.commonErrorDialog(activity,
							"Please check your internet connectivity.");
					return;
				}
				
				if (friend.registered) {
					holder11.poke.setVisibility(8);
					poke(friend.id);
				}
			}
		});

	//	AQuery fbQuery = new AQuery(convertView);
		holder.name.setText(friendList.get(position).getName());
	//	fbQuery.id(holder.friendImage).image(friendList.get(position).imageUrl,
	//			options);

		
		Picasso.with(activity)
		.load(friendList.get(position).imageUrl)
		.error(R.drawable.user_image)
		.placeholder(R.drawable.user_image)
		.transform(new utils.CircleTransform()).fit()
		.into(holder.friendImage);
		
		
		
		toggleVisibilities(holder, friend);
		if (friend.getShowHeader() == 'r') {
			holder.header.setVisibility(View.VISIBLE);
			holder.header.setText("Registered Users");
		} else if (friend.getShowHeader() == 'u') {
			holder.header.setVisibility(View.VISIBLE);
			holder.header.setText("Unregistered Users");
		} else {
			holder.header.setVisibility(View.GONE);
		}
		return convertView;
	}

	private void toggleVisibilities(ViewHolder holder, FbFriend friend) {
		if (friend.registered) {
			holder.name.setVisibility(View.VISIBLE);
			holder.nameUnreg.setVisibility(View.GONE);
			holder.likes.setVisibility(View.VISIBLE);
			holder.disLikes.setVisibility(View.VISIBLE);
			holder.likes.setText(friend.like + "");
			holder.disLikes.setText(friend.dislike + "");
			if (idMap.get(friend.id) == null || !idMap.get(friend.id)) {
				holder.invite.setText("Block");
			} else {
				holder.invite.setText("Unblock");
			}
			holder.dislikeHead.setVisibility(0);
			holder.likeHead.setVisibility(0);

		} else {
			holder.nameUnreg.setVisibility(View.VISIBLE);
			holder.nameUnreg.setText(friend.name);
			holder.name.setVisibility(View.GONE);
			holder.likes.setVisibility(View.GONE);
			holder.disLikes.setVisibility(View.GONE);
			holder.invite.setText("Invite");
			holder.dislikeHead.setVisibility(8);
			holder.likeHead.setVisibility(8);
		}
	}

	public void blocktoggle(final FbFriend friend, final int blockStatus,
			final ViewHolder holder) {

		RequestParams rv = new RequestParams();

		rv.put("friend_id", friend.id);
		rv.put("useraccesstoken", CommonUtil.getAccessToken(activity));
		rv.put("block", blockStatus + "");
		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "blockfriend", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {
						try {
							JSONObject json = new JSONObject(response);
							if (json.has("error")) {
								Toast.makeText(activity,
										"Unable to perform operation.",
										Toast.LENGTH_SHORT).show();
							} else {
								friend.block = blockStatus == 1;
								idMap.put(friend.id, friend.block);
								holder.invite
										.setText(blockStatus == 1 ? "Unblock"
												: "Block");
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}

					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());
						CommonUtil.commonErrorDialog(activity,
								"An error occurred. Please try later.");

					}

				});
	}
	
	
	public void poke(String friendId) {

		RequestParams rv = new RequestParams();

		rv.put("friend_id", friendId);
		rv.put("useraccesstoken", CommonUtil.getAccessToken(activity));
		
		AsyncHttpClient client = new AsyncHttpClient();

		client.setTimeout(100000);
		client.post(Data.baseUrl + "poke", rv,
				new AsyncHttpResponseHandler() {

					@Override
					public void onSuccess(String response) {
						Log.v("onSuccess = ",response);
					}
					@Override
					public void onFailure(Throwable e) {
						Log.v("onFailure = ", e.toString());
						
					}

				});
	}

	
	

	/**
	 * @return the friendList
	 */
	public List<FbFriend> getFriendList() {
		return friendList;
	}

	/**
	 * @param friendList
	 *            the friendList to set
	 */
	public void setFriendList(List<FbFriend> friendList) {
		this.friendList = friendList;
		friendListTemp = friendList;
	}

	private void showDialogWithoutNotificationBar(final String action,
			final Bundle params) {

		if (!AppStatus.getInstance(activity).isOnline(activity)) {
			CommonUtil.noInternetDialog(activity);
			return;
		}

		com.facebook.AccessToken accessToken = com.facebook.AccessToken
				.createFromExistingAccessToken(CommonUtil.getfbToken(activity), null, null,
						null, null);
		Session.openActiveSessionWithAccessToken(activity, accessToken,
				new Session.StatusCallback() {

					@Override
					public void call(Session session, SessionState state,
							Exception exception) {
						// TODO Auto-generated method stub
						if (session != null && session.isOpened()) {
							Session.setActiveSession(session);

							dialog = new WebDialog.Builder(activity, Session
									.getActiveSession(), action, params)
									.setOnCompleteListener(
											new WebDialog.OnCompleteListener() {
												@Override
												public void onComplete(
														Bundle values,
														FacebookException error) {
													if (error != null
															&& !(error instanceof FacebookOperationCanceledException)) {
														CommonUtil
																.noInternetDialog(activity);
													} else if (error == null
															&& !values
																	.isEmpty()) {
														// Toast.makeText(activity,
														// "Invite Send",
														// Toast.LENGTH_SHORT).show();
														Log.v("value= ",
																values.toString()
																		+ ",");
														CommonUtil
																.commonDialog(
																		activity,
																		
																		"Game Invite","Game invite sent Succesfully.");

													}

													dialog = null;
												}
											}).build();

							dialog.show();

						}
					}
				});
	}

	@SuppressLint("DefaultLocale")
	public void filter(String query) {
		searchResults.clear();
		boolean regStart = false;
		boolean unRegStart = false;
		for (FbFriend friend : friendListTemp) {
			friend.setShowHeader(' ');
			if (friend.getName().toLowerCase().startsWith(query.toLowerCase())) {
				if (!regStart) {
					regStart = true;
					if (friend.registered) {
						friend.setShowHeader('r');
					} else {
						unRegStart = true;
						friend.setShowHeader('u');
					}
				} else if (!unRegStart) {
					if (!friend.registered) {
						unRegStart = true;
						regStart = true;
						friend.setShowHeader('u');
					}
				}
				searchResults.add(friend);
			}
		}

		friendList = searchResults;
		this.notifyDataSetChanged();
	}

}
