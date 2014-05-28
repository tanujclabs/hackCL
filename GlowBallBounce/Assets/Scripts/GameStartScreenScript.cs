using UnityEngine;
using System.Collections;

public class GameStartScreenScript : MonoBehaviour {
	public System.Net.IPAddress _ipAddr;
	ConnectivityTest _TEST = new ConnectivityTest();
	GameObject MuteObject,g;
	public AudioSource a1;
	AudioClip f1;
	JSONObject fbresult_object;
	// Use this for initialization
	void Start () 
	{
		if (PlayerPrefs.GetString ("Sound").CompareTo ("") == 0) 
		{
			PlayerPrefs.SetString ("Sound", "On");
		}
		_TEST._IP = "54.225.98.2";
		_TEST._port = 80;
		FB.Init(null);
		MuteObject = GameObject.Find ("SoundButton")as GameObject;
		a1 = (AudioSource)gameObject.AddComponent("AudioSource");
		a1.volume = 1.0f;
		f1 = (AudioClip)Resources.Load("bg music menu");
		a1.clip = f1;
		a1.loop = true;
		a1.Play();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void GameStart()
	{
		g = Resources.Load ("ReadyPanel")as GameObject;
		NGUITools.AddChild (GameObject.Find ("UI Root")as GameObject, g);
		Destroy (this.gameObject);
		//Code for Tutorial Screen..
	}
	void Sound()
	{
		if (PlayerPrefs.GetString("Sound").CompareTo("Off")==0) 
		{
			AudioListener.volume=1f;
			PlayerPrefs.SetString("Sound","On");
			MuteObject.GetComponent<UIImageButton> ().normalSprite="sound-on-click";
			MuteObject.GetComponent<UIImageButton> ().pressedSprite="sound-on-click-pressed";
			MuteObject.GetComponent<UIImageButton> ().disabledSprite="sound-on-click";
			MuteObject.GetComponent<UIImageButton> ().hoverSprite="sound-on-click";
		} 
		else 
		{
			PlayerPrefs.SetString("Sound","Off");
			AudioListener.volume=0f;
			MuteObject.GetComponent<UIImageButton> ().normalSprite="sound-off";
			MuteObject.GetComponent<UIImageButton> ().pressedSprite="sound-off-on-click";
			MuteObject.GetComponent<UIImageButton> ().disabledSprite="sound-off";
			MuteObject.GetComponent<UIImageButton> ().hoverSprite="sound-off";
		}
	}

	private void CallFBLogin()
	{
		if ((_TEST.CheckConnectionViaTCPSocket()))
		{
			FB.Init(null);
			FB.Login("email,publish_actions", LoginCallback);
		} 
		else
		{
			//GameObject me = Resources.Load("notification")as GameObject;
			//			NGUITools.AddChild(GameObject.Find("NGUIButtons"), me);
			//			GameObject.Find("Label").GetComponent<UILabel>().text = "NO INTERNET CONNECTION";
		}
	}
	void LoginCallback(FBResult result)
	{
//		if (result.Error != null) 
//		{
//			Debug.Log ("Login Failed due to : " + result.Error.ToString ());
//		} 
//		else if (!FB.IsLoggedIn) 
//		{
//			Debug.Log ("Login cancelled by Player");
//		} 
//		else 
//		{
//			Debug.Log ("LOgin Complete");
//			fbresult_object = new JSONObject(result.Text);
//			user_id = fbresult_object.GetField("data")[0].GetField("user_id").ToString().Replace("\"", "");
//		}

	}
	void Leader()
	{
		GameObject.Find ("LoginButton").transform.collider.enabled = false;
		GameObject.Find ("PlayButton").transform.collider.enabled = false;
		GameObject.Find ("SoundButton").transform.collider.enabled = false;
		GameObject.Find ("LeaderBoardButton").transform.collider.enabled = false;
		g = Resources.Load ("LeaderBoardPanel")as GameObject;
		NGUITools.AddChild(GameObject.Find ("UI Root") as GameObject,g);
	}

}
