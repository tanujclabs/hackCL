package com.hackcl.smiyc;

public class FbFriend {

	String name;

	String id;

	String imageUrl;

	char showHeader;

	int like;

	int dislike;

	boolean block;

	boolean registered;

	// 0 : unreg
	// 1 : reg
	// 2 : req sent
	// 3 : Reg Header
	// 4 : Unreg Header

	public FbFriend(String name, String id, String imageUrl, int like,
			int dislike, boolean block, boolean registered) {
		this.name = name;
		this.id = id;
		this.imageUrl = imageUrl;
		this.like = like;
		this.dislike = dislike;
		this.block = block;
		this.registered = registered;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public char getShowHeader() {
		return showHeader;
	}

	public void setShowHeader(char showHeader) {
		this.showHeader = showHeader;
	}

	public int getLike() {
		return like;
	}

	public void setLike(int like) {
		this.like = like;
	}

	public int getDislike() {
		return dislike;
	}

	public void setDislike(int dislike) {
		this.dislike = dislike;
	}

	public boolean isBlock() {
		return block;
	}

	public void setBlock(boolean block) {
		this.block = block;
	}

}
