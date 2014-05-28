using UnityEngine;
using System.Collections;

public class PlayList : MonoBehaviour
{
	public AudioClip[] audioClips;
	GameObject audioManager;
	float time;
	int randomTrack, repeatedTrack;
	// Use this for initialization
	void Start ()
	{
		repeatedTrack = -1;
		audioManager = GameObject.Find("AudioManager");
		PlayNext();
	}
	void PlayNext()
	{
		randomTrack = Random.Range(0,audioClips.Length);
		if(randomTrack != repeatedTrack)
		{
			repeatedTrack = randomTrack;
		}
		else
		{
			PlayNext();
		}

		audioManager.GetComponent<AudioSource>().audio.clip = audioClips[randomTrack];
		audioManager.GetComponent<AudioSource>().audio.Play();
		time = 0;
//		Debug.Log("value random"+randomTrack);
	}
	// Update is called once per frame
	void Update ()
	{

		time += Time.deltaTime;
		if(time > audioClips[randomTrack].length)
		{
			PlayNext();

		}

	}
}
