using UnityEngine;
using System.Collections;

public class SpotLightColor : MonoBehaviour {
	Vector3 originalPos;
	GameObject audioSource;
	public Material Mat;
	// Use this for initialization
	void Start () {
		originalPos = transform.localScale;
		audioSource = GameObject.Find("AudioManager");
	}
	
	// Update is called once per frame
	void Update () {

		Mat.SetColor("_TintColor",new Color(gameObject.GetComponent<ColorChange>().green/255f,gameObject.GetComponent<ColorChange>().blue/255f,gameObject.GetComponent<ColorChange>().red/255f));
		renderer.sharedMaterial = Mat;
		transform.localScale = new Vector3(originalPos.x + audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*20,originalPos.y + audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*20,originalPos.z + audioSource.GetComponent<SpectrumWindow>().AverageFrequencyValue*20);

	}
}
