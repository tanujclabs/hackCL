using UnityEngine;
using System.Collections;

public class GlowBallScript : MonoBehaviour
{
	bool flag=false;
	public AudioSource a;
	AudioClip f;
	GameObject s;
	// Use this for initialization
	void Start () 
	{
		//s = GameObject.Find ("DisplayScore")as GameObject;
		a = (AudioSource)gameObject.AddComponent("AudioSource");
		a.volume = 1.0f;
	}
	
	// Update is called once per frame
	void Update () 
	{

	}
	void OnCollisionEnter(Collision info)
	{
		if (info.gameObject.name.CompareTo ("BasePlane") == 0 ) 
		{
			StaticScript.HitBase=true;
			f = (AudioClip)Resources.Load("ball bounce");
			a.clip = f;
			a.Play();
		}
		else if (info.gameObject.name.CompareTo ("Score") == 0 ) 
		{
			Destroy(info.gameObject);
			StaticScript.Score=StaticScript.Score+1;
			//s.GetComponent<UILabel>().text=s.GetComponent<UILabel>().text+StaticScript.Score.ToString();
			this.gameObject.transform.position=new Vector3(-7.305f,this.transform.position.y,this.transform.position.z);

		}
		else if(info.gameObject.CompareTag("Piller") && !flag)
		{
			f = (AudioClip)Resources.Load("bar hit");
			a.clip = f;
			a.Play();
			flag=true;
			StaticScript.LetsStart=false;
			Invoke("jao",0.7f);
		}
	
	}
	void jao()
	{
		NGUITools.AddChild(GameObject.Find("UI Root")as GameObject,Resources.Load("GameOverPanel")as GameObject);
	}
}
