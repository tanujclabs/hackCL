using UnityEngine;
using System.Collections;

public class ResumePanelScript : MonoBehaviour {
	GameObject[] ar = new GameObject[50];
	GameObject a;
	// Use this for initialization
	void Start () 
	{
		ar = GameObject.FindGameObjectsWithTag("Piller");	
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
	void Restart()
	{
		foreach (GameObject g in ar) 
		{
			Destroy(g.gameObject);
		}
		Destroy (GameObject.Find ("GameController(Clone)") as GameObject);
		Destroy (GameObject.Find ("GamePlayPanel(Clone)") as GameObject);
		Destroy (GameObject.Find ("GlowBall(Clone)") as GameObject);
		Destroy (GameObject.Find ("GameStartPiller(Clone)")as GameObject);
		a = Resources.Load ("ReadyPanel")as GameObject;
		NGUITools.AddChild (GameObject.Find ("UI Root")as GameObject, a);
		Destroy (this.gameObject);
	}
	void Menu()
	{
		Application.LoadLevel ("GlowBallBounce");
	}

	void Resume()
	{
		StaticScript.LetsStart = true;
		Time.timeScale = 1.0f;
		Destroy (this.gameObject);
	}
}
