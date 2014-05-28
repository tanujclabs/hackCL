using System.Collections;
using UnityEngine;
public class MoveCreator {
	public int MaxMoveTypes;
	int leftSeed,rightSeed;
	// Use this for initialization
	void Start () {
	
		leftSeed = Random.Range(1111111,9999999);
		rightSeed = Random.Range(1111111,9999999);
	}
	public int getNewMove()
	{
		return Random.Range(0,MaxMoveTypes);
	}
	public int getLeftMove()
	{
		//string temp = ""+(leftSeed*leftSeed);


		return Random.Range(0,MaxMoveTypes); 
	}
	public int getRightMove()
	{
		return Random.Range(0,MaxMoveTypes); 
	}
	string getPart(string full)
	{
		char[] temp = full.ToCharArray();
		string part = "";
		return part;
	}
}
