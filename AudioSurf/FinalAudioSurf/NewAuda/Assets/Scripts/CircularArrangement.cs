using UnityEngine;
using System.Collections;

public class CircularArrangement : MonoBehaviour {
	
	public Strand[] _strand;
	private Color[] _color;
	
	void Awake()
	{
		_strand = GetComponentsInChildren<Strand>();
		_color = new Color[ _strand.Length ];
//		for( int i = 0; i < _color.Length; i++ )
//		{
//			Color C = new Color( Random.Range( 0, 10)/10, Random.Range( 0,10) / 10, Random.Range( 0, 10)/10, 1 );
//			_strand[i].transform.renderer.material.color = C;
//		}
		float _yangle = 0;
//		foreach( Strand s in _strand )
//		{
//			s.gameObject.transform.eulerAngles = new Vector3( s.gameObject.transform.eulerAngles.x, _yangle, s.gameObject.transform.eulerAngles.z );
//			_yangle += 7.5f;
//		}
	}
	
}
