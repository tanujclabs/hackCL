using UnityEngine;
using System.Collections;

public class welcomescreen : MonoBehaviour {

	// Use this for initialization
	public bool startGamegui;
	public Texture2D startbuttonOnclick;
	public Texture2D background;
	GUISkin myskin;
	public GUIStyle style;
	public Texture2D earth;
	Transform splashscreen;
	Transform earthobject;


	void Start () {
		myskin = new GUISkin ();
		style = new GUIStyle ();
		splashscreen = this.gameObject.transform.Find ("SplashScreen") as Transform; 
		earthobject = this.gameObject.transform.Find ("EarthRotate") as Transform; 



	}

	void OnGUI()
	{

		if(!startGamegui)
		{
			//GUI.Box (new Rect(100,100,background.width,background.height),background);

			if (GUI.Button (new Rect (Screen.width * 0.3f, Screen.height * 0.68f, startbuttonOnclick.width / 2, startbuttonOnclick.height / 2),earth,style )) 
			{
				splashscreen.gameObject.SetActive(false);
				earthobject.gameObject.SetActive(false);
				startGamegui = true;
				//Debug.Log("afads");
			}
	
		}
	}

	// Update is called once per frame
	void Update () {
	
	}
}
