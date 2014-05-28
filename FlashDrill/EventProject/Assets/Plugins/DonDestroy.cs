using UnityEngine;
using System.Collections;
using GooglePlayGames;
using UnityEngine.SocialPlatforms;using GooglePlayGames.BasicApi;
using GooglePlayGames.OurUtils;
using GooglePlayGames.BasicApi.Multiplayer;
public class DonDestroy : MonoBehaviour {
	MultiplayerListener listener;
	public static DonDestroy _instance;
	// Use this for initialization
	void Start () {
		_instance = this;
		DontDestroyOnLoad (transform);
	}


	public void StartMulti(MultiplayerListener listener)
	{


		PlayGamesPlatform.Activate();
		Social.localUser.Authenticate((bool success) => {
			// handle success or failure
			if(success)
			{
				
				//PlayGamesPlatform.Instance.RealTime.
				const int MinOpponents = 1, MaxOpponents = 3;
				const int GameVariant = 0;
				PlayGamesPlatform.Instance.RealTime.CreateQuickGame(MinOpponents, MaxOpponents,
				                                                    GameVariant, listener);
				
			}
			else
			{
				Debug.Log("failed To Authenticate");
				
			}
		});
	}


	
	// Update is called once per frame
	void Update () {
	
	}
}
