using UnityEngine;
using System.Collections;

public class scrollColorChange : MonoBehaviour
{

	// Use this for initialization
	void Start ()
	{

	}

	// Update is called once per frame
	void Update ()
	{
		gameObject.GetComponent<UISprite>().color = new Color(gameObject.GetComponent<ColorChange>().green/255f,gameObject.GetComponent<ColorChange>().blue/255f,gameObject.GetComponent<ColorChange>().red/255f);
	}
}
