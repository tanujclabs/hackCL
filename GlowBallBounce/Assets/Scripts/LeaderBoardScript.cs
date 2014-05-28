using UnityEngine;
using System.Collections;
using System.IO;

public class LeaderBoardScript : MonoBehaviour {
	public System.Net.IPAddress _ipAddr;
	ConnectivityTest _TEST = new ConnectivityTest();
	string geturl;
	WWW www;
	string[] PlayerScores = new string[10];
	string[] PlayerNames = new string[10];
	// Use this for initialization
	void Start () {
		_TEST._IP = "54.225.98.2";
		_TEST._port = 80;
		Debug.Log ("Facebook id : "+FB.UserId);
		geturl = "http://production.click-labs.com/crappy/crappy_block/index.php?action=getGlobalScores";
		getdata ();
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}

	void goback()
	{
//		GameObject.Find ("LoginButton").transform.collider.enabled = true;
//		GameObject.Find ("PlayButton").transform.collider.enabled = true;
//		GameObject.Find ("SoundButton").transform.collider.enabled = true;
//		GameObject.Find ("LeaderBoardButton").transform.collider.enabled = true;
//		Destroy (this.gameObject);
		Application.LoadLevel ("GlowBallBounce");
	}


	void getdata()
	{
		if ((_TEST.CheckConnectionViaTCPSocket ())) 
		{
			www = new WWW (geturl);
			StartCoroutine (Getwait (www));
		}
		else 
		{
			File.WriteAllLines(Application.persistentDataPath + "/highscores.dat" , PlayerScores);
			PlayerScores= File.ReadAllLines(Application.persistentDataPath + "/highscores.dat");
			File.WriteAllLines(Application.persistentDataPath + "/highname.dat" , PlayerNames);
			PlayerNames= File.ReadAllLines(Application.persistentDataPath + "/highname.dat");
			for(int f=0;f<9;f++)
			{
				GameObject.Find("Name"+(f+1)).GetComponent<UILabel>().text=PlayerNames[f];
				GameObject.Find("Score"+(f+1)).GetComponent<UILabel>().text= PlayerScores[f];
			}
		}
	}

	IEnumerator Getwait(WWW w)
	{
		yield return w;
		if (!w.text.Contains("error"))
		{
			Debug.Log ("Response from Server : " + w.text.ToString ());
			JSONObject jo=new JSONObject(w.text);
			int count=jo.GetField("data").Count;
			print("Count : "+count);
			if(count< 10)
			{
				for(int f=0;f<count;f++)
				{
					PlayerScores[f]=jo.GetField("data")[f].GetField("score").ToString().Replace("\"", "");
					PlayerNames[f]=jo.GetField("data")[f].GetField("fb_name").ToString().Replace("\"","");
				}
				File.WriteAllLines(Application.persistentDataPath + "/highscores.dat" , PlayerScores);
				PlayerScores= File.ReadAllLines(Application.persistentDataPath + "/highscores.dat");
				File.WriteAllLines(Application.persistentDataPath + "/highname.dat" , PlayerNames);
				PlayerNames= File.ReadAllLines(Application.persistentDataPath + "/highname.dat");
				for(int f=0;f<count;f++)
				{
					GameObject.Find("Name"+(f+1)).GetComponent<UILabel>().text=PlayerNames[f];
					GameObject.Find("Score"+(f+1)).GetComponent<UILabel>().text= PlayerScores[f];
				}
			}
			else
			{
				for(int f=0;f<9;f++)
				{
					PlayerNames[f]=jo.GetField("data")[f].GetField("fb_name").ToString().Replace("\"", "");
					PlayerScores[f]=jo.GetField("data")[f].GetField("score").ToString().Replace("\"","");
				}
				File.WriteAllLines(Application.persistentDataPath + "/highscores.dat" , PlayerScores);
				PlayerScores= File.ReadAllLines(Application.persistentDataPath + "/highscores.dat");
				File.WriteAllLines(Application.persistentDataPath + "/highname.dat" , PlayerNames);
				PlayerNames= File.ReadAllLines(Application.persistentDataPath + "/highname.dat");
				for(int f=0;f<9;f++)
				{
					GameObject.Find("Name"+(f+1)).GetComponent<UILabel>().text=PlayerNames[f];
					GameObject.Find("Score"+(f+1)).GetComponent<UILabel>().text= PlayerScores[f];
				}
			}
				
		}					
		else 
		{
			PlayerScores= File.ReadAllLines(Application.persistentDataPath + "/highscores.dat");
			PlayerNames= File.ReadAllLines(Application.persistentDataPath + "/highname.dat");
			for(int f=0;f<9;f++)
			{
				GameObject.Find("Name"+(f+1)).GetComponent<UILabel>().text=PlayerNames[f];
				GameObject.Find("Score"+(f+1)).GetComponent<UILabel>().text= PlayerScores[f];
			}       
		}
	}
}
