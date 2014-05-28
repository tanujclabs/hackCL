using UnityEngine;
using System.Collections;

public class ColorChange : MonoBehaviour
{
	public float red,green,blue;
	// Use this for initialization
	void Start ()
	{
		red = 255;
		green = 0;
		blue = 0;
	}

	// Update is called once per frame
	void Update ()
	{
		BoundColours();
		if(red >= 255 && green == 0)
		{
			blue++;

		}

		if(blue >= 255 && green == 0)
		{
			red--;

		}
		if(red == 0 && blue >= 255)
		{
			green++;

		}
		if(green >= 255 && red == 0)
		{
			blue--;

		}
		if(green >= 255 && blue == 0)
		{
			red++;

		}
		if(red >= 255 && blue == 0)
		{
			green--;

		}
		//gameObject.GetComponent<Light>().color = new Color(red/255f,green/255f,blue/255f);
	}

	void BoundColours()
	{
		if( red >= 255 ) red = 255;
		if( red <= 0 ) red = 0;
		if( blue >= 255 ) blue = 255;
		if( blue <= 0 ) blue = 0;
		if( green >= 255 ) green = 255;
		if( green <= 0 ) green = 0;
	}

}
