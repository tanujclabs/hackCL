using UnityEngine;
using System.Collections;

public class SongName : MonoBehaviour
{
	public GameObject label;
	public AudioClip Clip;
	void OnEnable()
	{
		label.GetComponent<UILabel>().text = Clip.name;
	}
	// Use this for initialization
	void Start ()
	{

	}

	// Update is called once per frame
	void Update ()
	{

	}
}
