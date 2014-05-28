using UnityEngine;
using System.Collections;

public class SceneController : MonoBehaviour {


	public GameObject LeaderBoardPanelObject;
	public GameObject GameStartScreenObject;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void ToLeader()
	{
		LeaderBoardPanelObject.SetActive(true);
		GameStartScreenObject.SetActive(false);
	}
	void BackToMenu()
	{
		LeaderBoardPanelObject.SetActive(false);
		GameStartScreenObject.SetActive(true);
	}
}
