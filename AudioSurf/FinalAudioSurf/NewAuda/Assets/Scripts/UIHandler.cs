using UnityEngine;
using System.Collections;

public class UIHandler : MonoBehaviour {
	
	public GameObject TapPlay, GoBack, MainLabel, mCamera,scrollBackground,mainLabel;
	
	public Font _font;
	
	private bool IsInUpperLayer = true;


	void OnEnable()
	{
		UpdateButtonTargets();
		scrollBackground.SetActive(false);
		//scrollPannel.SetActive(false);
	}
	void OnTapPlayPressed()
	{
		mCamera.GetComponent<UICameraTransitions>().IsTransitionF = true;
		MainLabel.GetComponent<UICameraTransitions>().IsTransitionF = true;
		TapPlay.SetActive( false );
		GoBack.SetActive( true );
		scrollBackground.SetActive(true);
		mainLabel.SetActive(false);
		Invoke ( "ScrollViewAnim", 0.5f );
	}
	
	void OnGoBackPressed()
	{
		mCamera.GetComponent<UICameraTransitions>().IsTransitionB = true;
		MainLabel.GetComponent<UICameraTransitions>().IsTransitionB = true;
		TapPlay.SetActive( true );
		scrollBackground.SetActive(false);
		GoBack.SetActive( false );
		mainLabel.SetActive(true);
	}
	
	void OnGUI()
	{
		GUI.skin.label.font = _font;
		GUI.color = new Color( 255, 0, 216/255, 1 );
		if( IsInUpperLayer)
			GUI.Label( new Rect( Screen.width / 3, Screen.height / 4, Screen.width / 2, Screen.height ), "Tap Anywhere" );
//		if( GUI.Button( new Rect(0,0,100,100), "Play" ))
//		{
//			Application.LoadLevel( "GamePlay" );
//		}
	}
	
	void Update()
	{
		if( Input.GetMouseButtonUp(0) && IsInUpperLayer )
		{
			mCamera.GetComponent<UICameraTransitions>().FadingBlur = true;
			mCamera.animation.Play();
			TapPlay.SetActive(true);
			IsInUpperLayer = false;
		}
	}

	void UpdateButtonTargets()
	{
//		Debug.Log( "Updating Target" );

		UIButton[] Buttons = scrollBackground.GetComponentsInChildren<UIButton>();
		foreach( UIButton B in Buttons )
			B.transform.GetComponent<UIButtonMessage>().target = GameObject.Find( "AudioMessenger" );
	}


}
