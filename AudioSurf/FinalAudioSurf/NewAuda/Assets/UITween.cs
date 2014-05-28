using UnityEngine;
using System.Collections;

public class UITween : MonoBehaviour {

	void OnEnable()
	{
		TweenAlpha.Begin( this.gameObject, 0, 0 );
		TweenAlpha.Begin( this.gameObject ,1, 0.5f);
	}
}
