using UnityEngine;
using System.Collections;

public class spotLightStrand2 : MonoBehaviour {
	GameObject audioSource;
	// Use this for initialization
	void Start () {
		audioSource = GameObject.Find("AudioManager");
	}
	
	// Update is called once per frame
	void Update () {
		gameObject.GetComponent<Light>().spotAngle = audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*50000;
	}
}
