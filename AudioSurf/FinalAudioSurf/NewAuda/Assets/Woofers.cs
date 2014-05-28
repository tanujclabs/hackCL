using UnityEngine;
using System.Collections;

public class Woofers : MonoBehaviour {
	Vector3 originalScale;
	SpectrumWindow window;
	float time,randomDelayTime;
	// Use this for initialization
	void Start () {
		originalScale = transform.localScale;
		window = GameObject.Find("AudioManager").GetComponent<SpectrumWindow>();
		time = 0;
		//randomDelayTime = Random.Range (0,5);
	}
//	void BeatsWoofers()
//	{
//
//	}
	// Update is called once per frame
	void Update () {
		float factor = Random.Range(700,1500);
			transform.localScale = new Vector3(originalScale.x + window.AverageFrequencyValue*factor,originalScale.y + window.AverageFrequencyValue*factor,originalScale.z + window.AverageFrequencyValue*factor);
	}
}
