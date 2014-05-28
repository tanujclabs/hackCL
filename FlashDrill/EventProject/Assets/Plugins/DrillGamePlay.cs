using UnityEngine;
using System.Collections;

public class DrillGamePlay : MonoBehaviour {
	float speedForward = 0.0f,speedRotation = 0.0f;
	float forwardFac = 2f,rotationFac = 2f,offsetFac = 0.20f;
	public Transform blade;
	float maxClampSpeed = 3;
	float increaseFac = 1.0f;
	float decreaseFac = 0.6f;
	public Material mat;
	float offsetSpeed = 0.0f,offsetVal;
	public ParticleEmitter dustBack, dustUp, dustDown,dustFront;
	Transform filledPlane;
	Transform backPlane;
	public float alphaFill;
	public bool move;
	float incTime = 2.0f;
	public bool isPlayer; 
	Vector3 wantedPos;
	float wantedRot;
	public AlphaFill _alphaFillPlayer,_alphaFillEnemy;
	float backMaxEmission,frontMaxEmission,upMaxEmission;
	SoundController sc;
	float prevVal,prevRot;
	int currentEngineSoundId = 1,currentDebris;
	bool done = false;
	public AudioSource drillPlayerSource,drillEnemySource,drillBladePlayer,drillBladeEnemy;
	// Use this for initialization
	void Start () 
	{
		backMaxEmission = dustBack.maxEmission * 0.5f;
		frontMaxEmission = dustFront.maxEmission * 0.8f;
		upMaxEmission = dustUp.maxEmission * 0.5f;
		EmmissionHandler ();
		sc = GameObject.FindObjectOfType (typeof(SoundController)) as SoundController;
		if (isPlayer) {
						sc.drillPlayerBlade = drillBladePlayer;
						sc.drillPlayerEngine = drillPlayerSource;
				} else {
			sc.drillEnemyBlade = drillBladeEnemy;
			sc.drillEnemyEngine = drillEnemySource;
				}
		if (isPlayer)
		sc.StartEngine (false);
		else
		sc.StartEngineEnemy (false);
		prevVal = 0;
		prevRot = 0;
	}
	
	// Update is called once per frame
	void Update () 
	{

		if (isPlayer) 
		{
			transform.position += Time.fixedDeltaTime * speedForward * Vector3.right;
			alphaFill = (Screen.width + transform.localPosition.x + 30)/Screen.width;
			//Debug.Log("alpha = "+alphaFill);
			_alphaFillPlayer.changeUv(alphaFill);
			offsetTexture ();
			if(transform.localPosition.x >= 30)
			{
				StartCounter.instance.SetGameOver();
			}
			if((speedForward - prevVal) > 0.2f)
			{
				currentEngineSoundId++;
				if(currentEngineSoundId <= 5)
				{
				if(isPlayer)
				sc.upTempo(currentEngineSoundId,true);
					else
				sc.upTempoEnemy(currentEngineSoundId,true);
				}
				prevVal = speedForward;
			}
			else if((speedForward - prevVal) < -0.2f)
			{
				currentEngineSoundId--;
				if(currentEngineSoundId <= 5)
				{
					if(isPlayer)
						sc.upTempo(currentEngineSoundId,true);
					else
						sc.upTempoEnemy(currentEngineSoundId,true);
				}
				prevVal = speedForward;
			}
			if((speedRotation)>0.05f && !done)
			{
				if(isPlayer)
				sc.StartDrill();
				else
					sc.StartDrillEnemy();
				done = true;
			}

			if(speedRotation < 0.05f && done)
			{
				if(isPlayer)
				sc.StopDrill();
				else
				sc.StopDrillEnemy();
				done = false;
			}
	    }
		else if(move)
		{
			transform.position = Vector3.Lerp(transform.position,wantedPos,Time.deltaTime*2.0f);
			speedRotation = Mathf.Lerp (speedRotation, wantedRot, Time.deltaTime * 2.0f);
			alphaFill = (Screen.width + transform.localPosition.x + 30)/Screen.width;
			_alphaFillEnemy.changeUv(alphaFill);
		}
		blade.Rotate (new Vector3 (0.0f, 0.0f, speedRotation), Space.Self);

	}

	void EmmissionHandler()
	{
		dustBack.maxEmission = dustBack.minEmission =  backMaxEmission * speedForward;
		dustFront.maxEmission = dustFront.minEmission = frontMaxEmission * speedRotation;
		dustUp.maxEmission = dustUp.minEmission = upMaxEmission * speedRotation;
		dustDown.maxEmission = dustDown.minEmission = upMaxEmission * speedRotation;
	}


	public void increaseSpeed(float tempo)
	{
		increaseFac = tempo * 0.25f;
		offsetSpeed += increaseFac * offsetFac;
		speedForward += increaseFac * forwardFac;
		speedRotation += increaseFac * rotationFac;
		EmmissionHandler ();
	}

	public void RemotePosition(float xPos,float rot)
	{
		wantedPos = new Vector3 (xPos, transform.position.y, transform.position.z);
		wantedRot = rot;
	}

	void PassPosition(float xPos, float speedRot)
	{

	}

	public void decreaseSpeed(float tempo)
	{
		decreaseFac = tempo * 0.5f;
		offsetSpeed -= decreaseFac * offsetFac;
		speedForward -= decreaseFac * forwardFac;
		speedRotation -= decreaseFac * rotationFac;
		offsetSpeed = Mathf.Clamp (offsetSpeed, 0.0f, offsetSpeed);
		speedForward = Mathf.Clamp (speedForward, 0.0f, speedForward);
		speedRotation = Mathf.Clamp (speedRotation, 0.0f, speedRotation);
		EmmissionHandler ();
	}

	void offsetTexture()
	{
		if (offsetVal > 1.0f)
		{
			offsetVal = 0.0f;
		}
		offsetVal += offsetSpeed;
		if (offsetVal > 1.0f) 
		{
			offsetVal = offsetVal - 1.0f;
		}
		mat.SetTextureOffset("_MainTex",new Vector2(offsetVal,0.0f));
	}


}
