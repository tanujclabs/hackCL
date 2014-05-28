using UnityEngine;
using System.Collections;

public class MoonSpeakerStrand : MonoBehaviour {
	Vector3 originalScale;
	SpectrumWindow window;

	// Use this for initialization
	void Start () {
		originalScale = transform.localScale;
		window = GameObject.Find("AudioManager").GetComponent<SpectrumWindow>();

	}
	
	// Update is called once per frame
	void Update () {
		transform.localScale = new Vector3(originalScale.x + window.AverageFrequencyValue*100,originalScale.y + window.AverageFrequencyValue*100,originalScale.z + window.AverageFrequencyValue*100);
	}
}
