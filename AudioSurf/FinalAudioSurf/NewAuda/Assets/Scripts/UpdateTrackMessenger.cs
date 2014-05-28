using UnityEngine;
using System.Collections;

public class UpdateTrackMessenger : MonoBehaviour {

	void OnTriggerEnter( Collider other )
	{
		if( other.tag == "Player" )
		{
			SendMessageUpwards( "UpdateTrackInfo", SendMessageOptions.DontRequireReceiver);
		}
	}
}
