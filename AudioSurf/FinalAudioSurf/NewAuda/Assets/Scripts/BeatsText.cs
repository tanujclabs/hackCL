using UnityEngine;
using System.Collections;

public class BeatsText : MonoBehaviour 
{
	Vector3 originalPos;
	SpectrumWindow window;
	// Use this for initialization
	void Start () 
	{
		originalPos = transform.position;
		window = GameObject.Find("AudioManager").GetComponent<SpectrumWindow>();
	}
	
	// Update is called once per frame
	void Update () 
	{
		transform.localScale = new Vector3(originalPos.x + window.AverageFrequencyValue*100,originalPos.y + window.AverageFrequencyValue*150,originalPos.z + window.AverageFrequencyValue*50);
	
	}
}
