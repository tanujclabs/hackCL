using UnityEngine;
using System.Collections;

public class LightBackStrand : MonoBehaviour {
	GameObject audioSource;
	// Use this for initialization
	void Start () {
		audioSource = GameObject.Find("AudioManager");
	}
	
	// Update is called once per frame
	void Update () {
//		float factor = Random.Range(1000000,5000000);
		gameObject.GetComponent<Light>().spotAngle = audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*50000;
		gameObject.GetComponent<Light>().color = new Color(gameObject.GetComponent<ColorChange>().green/255f,gameObject.GetComponent<ColorChange>().red/255f,gameObject.GetComponent<ColorChange>().blue/255f);
	}
}
