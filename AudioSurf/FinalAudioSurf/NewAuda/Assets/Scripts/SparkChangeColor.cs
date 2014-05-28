using UnityEngine;
using System.Collections;

public class SparkChangeColor : MonoBehaviour
{

	// Use this for initialization
	void Start ()
	{

	}

	// Update is called once per frame
	void Update ()
	{
		gameObject.renderer.material.color = new Color(gameObject.GetComponent<ColorChange>().red/255f,gameObject.GetComponent<ColorChange>().blue/255f,gameObject.GetComponent<ColorChange>().green/255f);
	}
}
