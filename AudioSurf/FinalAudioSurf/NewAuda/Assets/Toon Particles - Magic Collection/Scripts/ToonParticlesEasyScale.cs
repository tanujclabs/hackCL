/*
EasyScale Script v.1.0
Copyright © 2012 Unluck Software - Egil A Larsen
www.chemicalbliss.com
*/
using UnityEngine;

[ExecuteInEditMode]
public class ToonParticlesEasyScale : MonoBehaviour
{
	public float multiplier = 1.0f;
	public float _startSize = 0.0f;
	public float _gravityModifier = 0.0f;
	public float _startSpeed = 0.0f;

	void OnDrawGizmosSelected () 
	{
		if(Application.isEditor)
		{
			if(_startSize ==0)
			{
				_startSize = transform.particleSystem.startSize;
				_gravityModifier = transform.particleSystem.gravityModifier;
				_startSpeed = transform.particleSystem.startSpeed;
			}
			else
			{
				transform.particleSystem.startSize = _startSize * multiplier;
				transform.particleSystem.gravityModifier = _gravityModifier * multiplier;
				transform.particleSystem.startSpeed = _startSpeed * multiplier;
			}
		}
	}	
}
