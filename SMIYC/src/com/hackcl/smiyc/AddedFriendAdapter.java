package com.hackcl.smiyc;

import java.util.List;

import rmn.androidscreenlibrary.ASSL;

import android.app.ActionBar.LayoutParams;
import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.RelativeLayout;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.TextView;

import com.androidquery.AQuery;
import com.androidquery.callback.ImageOptions;
import com.squareup.picasso.Picasso;

public class AddedFriendAdapter extends BaseAdapter {

	public List<FbFriend> friendList;
	AQuery query;
	int headerVar;
	Activity activity;
	int previous;
	ImageOptions options;
	public boolean[] isSelected;

	public AddedFriendAdapter(Activity activity, List<FbFriend> data) {
		this.friendList = data;
		this.activity = activity;
		query = new AQuery(activity);
		options = new ImageOptions();
		options.round = 20;
		options.fileCache = true;
		options.memCache = true;
		options.targetWidth = 100;
		options.fallback = R.drawable.ic_launcher;
		isSelected = new boolean[data.size()];
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
		public TextView likes;
		public TextView disLikes;
		public ImageView friendImage;
		public CheckBox selectFriend;
		RelativeLayout root;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {

		final ViewHolder holder;

		final FbFriend friend = friendList.get(position);

		if (convertView == null) {
			LayoutInflater inflater = (LayoutInflater) activity
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = inflater.inflate(R.layout.added_friend, null);
			holder = new ViewHolder();
			
			
			holder.root=(RelativeLayout)convertView.findViewById(R.id.gameFrndParent);
			holder.root.setLayoutParams(new AbsListView.LayoutParams(720,
					190));
		
			ASSL.DoMagic(holder.root);
			
			holder.name = (TextView) convertView.findViewById(R.id.friendNameA);
			holder.selectFriend = (CheckBox) convertView
					.findViewById(R.id.selectFrndA);
			holder.likes = (TextView) convertView.findViewById(R.id.noOfLikesA);
			holder.disLikes = (TextView) convertView
					.findViewById(R.id.noOfDisLikesA);
			holder.friendImage = (ImageView) convertView
					.findViewById(R.id.friendImageA);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.selectFriend.setChecked(isSelected[position]);
	//	AQuery fbQuery = new AQuery(convertView);
		holder.name.setText(friendList.get(position).getName());
//		fbQuery.id(holder.friendImage).image(friendList.get(position).imageUrl,
//				options);
//		
		
		Picasso.with(activity)
		.load(friendList.get(position).imageUrl)
		.error(R.drawable.user_image)
		.placeholder(R.drawable.user_image)
		.transform(new utils.CircleTransform()).fit()
		.into(holder.friendImage);
		
		
		
		holder.likes.setText(friend.like + "");
		holder.disLikes.setText(friend.dislike + "");
		holder.selectFriend
				.setOnCheckedChangeListener(new OnCheckedChangeListener() {
					@Override
					public void onCheckedChanged(CompoundButton buttonView,
							boolean isChecked) {
						isSelected[position] = isChecked;
					}
				});
		return convertView;
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
	}

}
