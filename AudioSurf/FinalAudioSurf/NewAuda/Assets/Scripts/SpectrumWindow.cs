using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SpectrumWindow : MonoBehaviour {
	List<GameObject> strandTuple = new List<GameObject>();
	CircularArrangement _CR;
	float Frequency = 0.0f;
	
	public float SmoothFactor = 1000;
	public float[] SpecValues = new float[16];
	int i = 1;
	int StrandCount = 0;
	float[] SpecData = new float[1024];
	int CorrectionFactor = 1;
	public float AverageFrequencyValue = 0.0f;
	private float Temp = 0;
	// Use this for initialization
	void Start () {
		_CR = GameObject.Find("main").GetComponent<CircularArrangement>();
		if( Application.loadedLevelName == "UI" )
		{
			foreach( Strand s in _CR._strand )
				strandTuple.Add( s.gameObject );
		}
	}
	
	// Update is called once per frame
	void FixedUpdate () {
		HandleFrequencyBands();
		HandleAvreageValue();
		
	}
	
	void HandleAvreageValue()
	{
		for( int i = 0; i < SpecValues.Length; i++)
		{
			Temp += SpecValues[i];
		}
		AverageFrequencyValue = Temp / 16;
		Temp = 0;
	}
	
	void HandleFrequencyBands()
	{

		SpecData = audio.GetSpectrumData( 1024, 0, FFTWindow.BlackmanHarris );
		
		while( i <= 1024 )
		{
			if( i%64 != 0 )
			{
				Frequency += SpecData[i - 1];
				i++;
			}
			else
			{
				float Avg = Frequency / 64;
				SpecValues[ StrandCount ] = Avg;
				if( Application.loadedLevelName == "UI")
				{
					strandTuple[ StrandCount ].transform.localScale = Vector3.Lerp ( strandTuple[ StrandCount ].transform.localScale, new Vector3( strandTuple[ StrandCount ].transform.localScale.x, SmoothFactor * Avg * CorrectionFactor,strandTuple[ StrandCount ].transform.localScale.z ), Time.deltaTime * 10);
					strandTuple[ StrandCount + 16 ].transform.localScale = Vector3.Lerp ( strandTuple[ StrandCount + 16  ].transform.localScale, new Vector3( strandTuple[ StrandCount + 16  ].transform.localScale.x, SmoothFactor * Avg * CorrectionFactor ,strandTuple[ StrandCount + 16  ].transform.localScale.z ), Time.deltaTime * 10);
					strandTuple[ StrandCount + 32 ].transform.localScale = Vector3.Lerp ( strandTuple[ StrandCount + 32  ].transform.localScale, new Vector3( strandTuple[ StrandCount + 32  ].transform.localScale.x, SmoothFactor * Avg * CorrectionFactor ,strandTuple[ StrandCount + 32  ].transform.localScale.z ), Time.deltaTime * 10 );
				}
				StrandCount++;
				Frequency = 0;
				i++;
				CorrectionFactor+=10;
				
			}
			
		}
		i = 1;
		StrandCount = 0;
		CorrectionFactor = 1;
	}
}
