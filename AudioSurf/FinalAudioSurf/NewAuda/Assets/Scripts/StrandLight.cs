using UnityEngine;
using System.Collections;

public class StrandLight : MonoBehaviour
{
	GameObject audioSource;
	// Use this for initialization
	void Start ()
	{
		audioSource = GameObject.Find("AudioManager");
	}

	// Update is called once per frame
	void Update ()
	{
		//gameObject.GetComponent<Light>().intensity = audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*5000;
		gameObject.GetComponent<Light>().spotAngle = audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*10000;
	}
}
