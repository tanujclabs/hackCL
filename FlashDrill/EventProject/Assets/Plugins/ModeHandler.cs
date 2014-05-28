using UnityEngine;
using System.Collections;

public class ModeHandler : MonoBehaviour {
	//public static int gameMode = 0;
	public GameObject multi;
	public GameObject single;
	// Use this for initialization
	void Start () {
		//gameMode = 1;
	if (GameController.gameMode == GameMode.SinglePlayer) 
	{
	   single.SetActive (true);
	} 
	else 
	{
		multi.SetActive(true);
	}
		SoundController.instance.SetMusicEnable(Menu.isMusic);
	}
	
	// Update is called once per frame
	void Update () 
	{
	
	}
}
