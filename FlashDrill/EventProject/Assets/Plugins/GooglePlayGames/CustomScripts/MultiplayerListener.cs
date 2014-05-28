using UnityEngine;
using System.Collections;
using GooglePlayGames;
using UnityEngine.SocialPlatforms;
using GooglePlayGames.BasicApi;
using GooglePlayGames.OurUtils;
using GooglePlayGames.BasicApi.Multiplayer;



public class MultiplayerListener : MonoBehaviour,RealTimeMultiplayerListener {
	public GUIText currentState;
	// Use this for initialization
	
	// Update is called once per frame

	void Start()
	{
		DonDestroy._instance.StartMulti (this);
	}


	public void OnRoomSetupProgress(float percent)
	{

	}

	public void OnRoomConnected(bool success)
	{

	}

	public void OnLeftRoom()
	{

	}

	public void OnPeersConnected(string[] participantIds)
	{

	}

	public void OnPeersDisconnected(string[] participantIds)
	{

	}


	public void OnRealTimeMessageReceived(bool isReliable, string senderId, byte[] data)
	{

	}
}
