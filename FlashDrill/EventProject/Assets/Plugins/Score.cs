using UnityEngine;
using System.Collections;

public class Score : MonoBehaviour {

	public GUITexture bestScore,opponent,winner,loser,bg;
	public GUIText Me_time,Me_correct,Me_wrong,Me_combo;
	public GUIText Other_time,Other_correct,Other_wrong,Other_combo;
	// Use this for initialization
	void Start () {
	
		if(GameController.gameMode == GameMode.SinglePlayer)
		{
			initSinglePlayer();
			showSinglePlayerStats();
			showBestStats();
		}
		else
		{
			initMultiPlayer();
			showSinglePlayerStats();
			showOtherPlayerStats();
		}
		initGUI();
		SoundController.instance.SetMusicEnable(Menu.isMusic);
	}
	void initSinglePlayer()
	{
		bestScore.gameObject.SetActive(true);
		opponent.gameObject.SetActive(false);
		winner.gameObject.SetActive(false);
		loser.gameObject.SetActive(false);
	}
	void initMultiPlayer()
	{
		bestScore.gameObject.SetActive(false);
		opponent.gameObject.SetActive(true);
		winner.gameObject.SetActive(true);
		loser.gameObject.SetActive(true);
	}
	void showSinglePlayerStats()
	{
		StatsValues stats = new StatsValues();
		stats = GameController.stats;
		Me_time.text = ""+getTimeString(stats.endTime - stats.startTime);
		Me_correct.text = ""+stats.correct;
		Me_wrong.text = ""+stats.wrong;
		Me_combo.text = "x"+stats.comboMaxed;
	}
	void showOtherPlayerStats()
	{
		StatsValues stats = new StatsValues();
		stats = GameController.stats;
		Other_time.text = ""+getTimeString(stats.endTime - stats.startTime);
		Other_correct.text = ""+stats.correct;
		Other_wrong.text = ""+stats.wrong;
		Other_combo.text = "x"+stats.comboMaxed;
	}
	void showBestStats()
	{
		StatsValues stats = new StatsValues();
		stats = GameController.stats;
		StatsValues beststats = new StatsValues();
		beststats.endTime = PlayerPrefs.GetFloat("BestTime",-1);
		beststats.startTime = 0;
		beststats.correct = PlayerPrefs.GetInt("BestCorrect",0);
		beststats.wrong = PlayerPrefs.GetInt("BestWrong",-1);
		beststats.comboMaxed = PlayerPrefs.GetInt("BestCombo",0);
		if(beststats.comboMaxed<stats.comboMaxed)
		{
			beststats.comboMaxed = stats.comboMaxed;
			PlayerPrefs.SetInt("BestCombo",beststats.comboMaxed);
		}
		if(beststats.wrong==-1||beststats.wrong>stats.wrong)
		{
			beststats.wrong = stats.wrong;
			PlayerPrefs.SetInt("BestWrong",beststats.wrong);
		}
		if(beststats.correct<stats.correct)
		{
			beststats.correct = stats.correct;
			PlayerPrefs.SetInt("BestCorrect",beststats.correct);
		}
		if(beststats.endTime<0||(beststats.endTime - beststats.startTime)>(stats.endTime - stats.startTime))
		{
			beststats.endTime = (stats.endTime - stats.startTime);
			PlayerPrefs.SetFloat("BestTime",beststats.endTime);
		}
		Other_time.text = ""+getTimeString(beststats.endTime - beststats.startTime);
		Other_correct.text = ""+beststats.correct;
		Other_wrong.text = ""+beststats.wrong;
		Other_combo.text = "x"+beststats.comboMaxed;
	}
	// Update is called once per frame
	void Update () {
	
	}
	string getTimeString(float time)
	{
		int timeMS =(int)( time*1000);
		int _ms = timeMS%1000;
		timeMS/=1000;
		int _s = timeMS%60;
		int _m = timeMS/60;
		return string.Format("{0:00}:{1:00}:{2:000}",_m,_s,_ms);
	}
#region OnGUI
	public GUISkin skin;
	Rect mainmenuRect,playagainRect;
	void initGUI()
	{
		float width = skin.customStyles[8].active.background.width;
		float height = skin.customStyles[8].active.background.height;
		mainmenuRect = new Rect(Screen.width*0.15f-width/2,Screen.height*0.1f-height/2,width,height);
		playagainRect = new Rect(Screen.width*0.85f-width/2,Screen.height*0.1f-height/2,width,height);
		bg.pixelInset = new Rect (-Screen.width / 2, -Screen.height / 2, Screen.width, Screen.height);
	}
	void OnGUI()
	{
		if(GUI.Button(mainmenuRect,"",skin.customStyles[9]))
		{
			SoundController.instance.ButtonSoundSource.Play();
			Application.LoadLevel("Menu");
		}
		if(GUI.Button(playagainRect,"",skin.customStyles[8]))
		{
			SoundController.instance.ButtonSoundSource.Play();
			Application.LoadLevel("tap");
		}
	}
#endregion
}
