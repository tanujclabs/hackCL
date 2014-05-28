using UnityEngine;
using System.Collections;

public class BackgroundAnim : MonoBehaviour
{
	public GameObject topBackground, bottomBackground, background;
	// Use this for initialization
	void Start ()
	{
		topBackground.SetActive(false);
		bottomBackground.SetActive(false);
		background.SetActive(false);
	}

	// Update is called once per frame
	void Update ()
	{
		bottomBackground.transform.Translate( new Vector3 (-0.46365f, -0.40262f, 0.01182f));

		topBackground.transform.Translate( new Vector3 (-0.269f, 0.58498f, 0.01126f));
	}
}
