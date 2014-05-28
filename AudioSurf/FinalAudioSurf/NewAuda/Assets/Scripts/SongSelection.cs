using UnityEngine;
using System.Collections;

public class SongSelection : MonoBehaviour
{
	GameObject audioManager;
	public AudioClip[] audioClips;
	// Use this for initialization
	void Start ()
	{
		audioManager = GameObject.Find("AudioManager");
	}
	public void AngrejiBeat()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[0];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Shoulder()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[9];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Mundiyan()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[6];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Boulivard()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[1];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void ChaarBottle()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[2];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void DirtyDance()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[3];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Gasolina()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[4];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void LinkinPark()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[5];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void ThriftShift()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[10];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Rasmus()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[8];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	public void Rapture()
	{
		audioManager.GetComponent<AudioSource>().clip = audioClips[7];
		audioManager.GetComponent<PlayList>().enabled = false;
	}
	// Update is called once per frame
	void Update ()
	{

	}
}
