using UnityEngine;
using System.Collections;

public class ReadyScript : MonoBehaviour {
	GameObject g;
	// Use this for initialization
	void Start () 
	{
		StaticScript.LetsStart = false;
		Time.timeScale = 0.0f;
		g=Resources.Load("GameStartPiller")as GameObject;
		Instantiate(g);
		g=Resources.Load("GlowBall")as GameObject;
		Instantiate(g);
		g=Resources.Load("GameController")as GameObject;
		Instantiate(g);
		g=Resources.Load("GamePlayPanel")as GameObject;
		NGUITools.AddChild (GameObject.Find ("UI Root")as GameObject, g);
		Debug.Log ("Invoke Method Called");
		Invoke ("GetStart", 0.5f);
	}
	
	// Update is called once per frame
	void Update () 
	{
			
	}
	void GetStart()
	{
		StaticScript.LetsStart = true;
		Time.timeScale = 1.0f;
		g=GameObject.Find("GlowBall(Clone)") as GameObject;
		g.transform.Translate(1f,0f,0f);
		GameObject.Find ("GamePlayPanel(Clone)/PauseButton").transform.collider.enabled = true;
		Destroy(GameObject.Find("ReadyPanel(Clone)") as GameObject);
	}
}
