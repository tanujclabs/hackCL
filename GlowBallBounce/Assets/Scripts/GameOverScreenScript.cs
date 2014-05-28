using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GameOverScreenScript : MonoBehaviour {
	public System.Net.IPAddress _ipAddr;
	ConnectivityTest _TEST = new ConnectivityTest();
	JSONObject fbresult_object;
	int fl=0;
	string user_id;
	GameObject[] ar = new GameObject[50];
	GameObject a;
	GameObject s;
	public AudioSource a1;
	AudioClip f1;
	// Use this for initialization
	void Start () 
	{
		ar = GameObject.FindGameObjectsWithTag("Piller");
		foreach (GameObject g in ar) 
		{
			Destroy(g.gameObject);
		}
		Destroy (GameObject.Find ("GameController(Clone)") as GameObject);
		Destroy (GameObject.Find ("GamePlayPanel(Clone)") as GameObject);
		Destroy (GameObject.Find ("GlowBall(Clone)") as GameObject);
		Destroy (GameObject.Find ("GameStartPiller(Clone)")as GameObject);
		_TEST._IP = "54.225.98.2";
		_TEST._port = 80;
		FB.Init(null);
		if (StaticScript.Score > PlayerPrefs.GetInt ("HighScore")) 
		{
			PlayerPrefs.SetInt ("HighScore", StaticScript.Score);
			GameObject.Find ("GameOverPanel(Clone)/ScoreDisplay/HighScore").GetComponent<UILabel>().text=PlayerPrefs.GetInt ("HighScore").ToString();
		}
		else
			GameObject.Find ("GameOverPanel(Clone)/ScoreDisplay/HighScore").GetComponent<UILabel>().text=PlayerPrefs.GetInt ("HighScore").ToString();
		a1 = (AudioSource)gameObject.AddComponent("AudioSource");
		a1.volume = 1.0f;
		f1 = (AudioClip)Resources.Load("gameover");
		a1.clip = f1;
		a1.loop = true;
		a1.Play();
		s = GameObject.Find ("GameOverPanel(Clone)/ScoreDisplay/Score") as GameObject;
	}
	
	// Update is called once per frame
	void Update () 
	{
	 	if (fl < StaticScript.Score) 
		{
			s.GetComponent<UILabel>().text=fl.ToString();
			fl++;
		}

	}
	void Menu()
	{
		StaticScript.Score = 0;
		Application.LoadLevel ("GlowBallBounce");
	}
	void Reply()
	{
		StaticScript.Score = 0;
		a = Resources.Load ("ReadyPanel")as GameObject;
		NGUITools.AddChild (GameObject.Find ("UI Root")as GameObject, a);
		Destroy (this.gameObject);
	}

	private void CallFBLogin()
	{
		if (!(_TEST.CheckConnectionViaTCPSocket()) && !GameObject.Find("notification(Clone)"))
		{
//			GameObject me = Resources.Load("notification")as GameObject;
//			NGUITools.AddChild(GameObject.Find("NGUIButtons"), me);
//			GameObject.Find("Label").GetComponent<UILabel>().text = "NO INTERNET CONNECTION";
		} 
		else
		{
			FB.Init(null);
			FB.Login("email,publish_actions", LoginCallback);
		}
	}
	void LoginCallback(FBResult result)
	{
		if (result.Error != null) 
		{
			Debug.Log ("Login Failed due to : " + result.Error.ToString ());
		} 
		else if (!FB.IsLoggedIn) {
			Debug.Log ("Login cancelled by Player");
		} 
		else 
		{
			fbresult_object = new JSONObject(result.Text);
			user_id = fbresult_object.GetField("data")[0].GetField("user_id").ToString().Replace("\"", "");
		}
	}



	//Post Message on facebook
	
	
	
	void Share()
	{
		
		if (_TEST.CheckConnectionViaTCPSocket())
		{
			if (FB.IsLoggedIn)
			{
				string m = "I scored " + StaticScript.Score + " points in Glow Ball Bounce Game";
				var msg = new Dictionary<string, string>() {{"message", m}};
				FB.API("/me/feed", Facebook.HttpMethod.POST, Post_Message_Back, msg);
			} 
			else
			{
				CallFBLogin();
				string m = "I scored " + StaticScript.Score + " points in Glow Ball Bounce Game";
				var msg = new Dictionary<string, string>() {{"message", m}};
				FB.API("/me/feed", Facebook.HttpMethod.POST, Post_Message_Back, msg);
			}
		} 
		else
		{
			if(!GameObject.Find("notification(Clone)"))
			{
//				GameObject me = Resources.Load("notification")as GameObject;
//				NGUITools.AddChild(GameObject.Find("NGUIButtons"), me);
//				GameObject.Find("Label").GetComponent<UILabel>().text = "NO INTERNET CONNECTION";
			}
		}
	}
	
	
	void Post_Message_Back(FBResult result)
	{
		Debug.Log("Post Message Called");
		if (result.Error == null && !GameObject.Find("notification(Clone)")) 
		{
//			GameObject me = Resources.Load("notification")as GameObject;
//			NGUITools.AddChild(GameObject.Find("NGUIButtons"), me);
//			GameObject.Find("Label").GetComponent<UILabel>().text = "MESSAGE POSTED";
		} 
	}
}
