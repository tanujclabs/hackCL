using UnityEngine;
using System.Collections;

public class Menu : MonoBehaviour {

	public static bool isMusic = true;
	public GUITexture bg;
	float screenwidth,screenheight;
	// Use this for initialization
	void Awake()
	{

	}
	void Start () {
		screenwidth = Screen.width;
		screenheight = Screen.height;

		initGUI();
		SoundController.instance.SetMusicEnable(isMusic);
	}

	// Update is called once per frame
	void Update () {

		if(screenwidth != Screen.width || Screen.height != screenheight)
		{
			screenwidth = Screen.width;
			screenheight = Screen.height;
			
			initGUI();
		}
	}

#region OnGUI
	public GUISkin skin;
	Rect singleRect,multiRect,musicRect;
	void initGUI()
	{
		singleRect = new Rect(Screen.width*0.6f,Screen.height*0.2f,skin.customStyles[3].active.background.width,skin.customStyles[3].active.background.height);
		multiRect = new Rect(Screen.width*0.6f,Screen.height*0.4f,skin.customStyles[4].active.background.width,skin.customStyles[4].active.background.height);
		musicRect = new Rect(Screen.width,Screen.height,skin.customStyles[5].active.background.width,skin.customStyles[5].active.background.height);
		musicRect.x -= musicRect.width*2.0f;
		musicRect.y -= musicRect.height*2.0f;
		bg.pixelInset = new Rect (-Screen.width / 2, -Screen.height / 2, Screen.width, Screen.height);
	}
	public AudioClip sound;
	void OnGUI()
	{
		if(GUI.Button(singleRect,"",skin.customStyles[3]))
		{
			//single player
			SoundController.instance.ButtonSoundSource.Play();
			GameController.gameMode = GameMode.SinglePlayer;
			Destroy(gameObject);
			Application.LoadLevel("tap");
		}
		if(GUI.Button(multiRect,"",skin.customStyles[4]))
		{
			//multi player

			//DonDestroy._instance.StartMulti();
			SoundController.instance.ButtonSoundSource.Play();
			GameController.gameMode = GameMode.SinglePlayer;
			Destroy(gameObject);
//			Application.LoadLevel("tap");
			Application.LoadLevel ("tap");
		}
		if(GUI.Button(musicRect,"",skin.customStyles[(isMusic?5:6)]))
		{
			isMusic = !isMusic;
			SoundController.instance.SetMusicEnable(isMusic);
			SoundController.instance.ButtonSoundSource.Play();

		}
	}
#endregion
}
