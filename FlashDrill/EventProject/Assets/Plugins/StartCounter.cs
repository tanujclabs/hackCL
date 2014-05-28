using UnityEngine;
using System.Collections;

public class StartCounter : MonoBehaviour {
	public static StartCounter instance;
	float counter = 6.0f;
	int _counter = 6;
	public GameObject[] objectsToEnable;
	bool counterFinished = false;
	public GUITexture bg;
	// Use this for initialization
	void Start () {
		GameController.gameState = GameState.Play;
		instance = this;
		initGUI();
	}
	void OnDestroy()
	{
		instance = null;
	}
	// Update is called once per frame
	void Update () {
		if(counterFinished)
			return;
		if(_counter != (int)counter)
		{
			_counter = (int)counter;
			StartCoroutine(changeSize());
		}
		counterStyle.fontSize = fontSize;
		counter -= Time.deltaTime;
		if(counter<0.2f)
		{
			for(int i=0;i<objectsToEnable.Length;i++)
			{
				objectsToEnable[i].SetActive(true);
			}
			counterFinished = true;
			//gameObject.SetActive(false);

		}
	}
	IEnumerator changeSize()
	{
		float startSize = normalFontSize*3;
		float targetSize = normalFontSize;
		bool _isRunnig = true;
		float timer = 0;
		while(_isRunnig)
		{
			timer += Time.deltaTime*2;
			fontSize = (int)Mathf.Lerp(startSize,targetSize,Easing.Exponential.easeOut(timer));
			if(timer>=1.0f)
				_isRunnig = false;
			yield return 0;
		}
		fontSize = normalFontSize;
	}
	public void SetGameOver()
	{
		if(GameController.gameState == GameState.Score)
			return;
		GameController.gameState = GameState.Score;
		for(int i=0;i<objectsToEnable.Length;i++)
		{
			objectsToEnable[i].SetActive(false);
		}
		MoveGUI.instance.stats.endTime = Time.realtimeSinceStartup;
		GameController.stats = MoveGUI.instance.stats;
		Invoke("LoadScore",2.0f);
	}
	void LoadScore()
	{
		Application.LoadLevel("score");
	}
#region OnGUI
	public GUISkin skin;
	GUIStyle counterStyle;
	Rect counterRect;
	int fontSize=100,normalFontSize = 100;
	void initGUI()
	{
		counterRect = new Rect(Screen.width*0.45f,Screen.height*0.3f,Screen.width*0.1f,Screen.height*0.1f);
		counterStyle = skin.customStyles[7];
		bg.pixelInset = new Rect (-Screen.width / 2, -Screen.height / 2, Screen.width, Screen.height);
	}
	void OnGUI()
	{
		if(!counterFinished)
			GUI.Label(counterRect,""+_counter,counterStyle);
	}
#endregion
}
