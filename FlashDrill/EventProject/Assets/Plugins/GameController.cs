using UnityEngine;
using System.Collections;

public enum GameState
{
	Menu,
	Play,
	Score
};
public enum GameMode
{
	SinglePlayer,
	MultiPlayer
};
public class GameController : MonoBehaviour {

	public static GameState gameState = GameState.Menu;
	public static GameMode gameMode = GameMode.SinglePlayer;
	public static StatsValues stats = new StatsValues();
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
