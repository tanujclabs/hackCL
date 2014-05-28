using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class MoveProps
{
	public int moveType;
	public Rect moveRect;
	public int moveDir;
	public float destroyTimer;
	public float rotateAngle;
	public int checkPoint;
	public float moveSpeed;
	public bool isStoping;
	public float lerpingTimer;
	public float stopingTimer;
};
public struct StatsValues
{
	public int correct;
	public int wrong;
	public int combo;
	public int comboMaxed;
	public int rotatecombo;
	public float startTime;
	public float endTime;
};
public class MoveGUI : MonoBehaviour {
	public static MoveGUI instance;
	public GUITexture backGround,backStrip;
	public Texture[] icons;
	bool leftTakeInput = true,rightTakeInput = true;
	public Texture slider,sliderbackground,sliderfill,rightbox,wrongbox,activebox,rotateButtonGrey,rotateButton,comboicon,rotateBar;
	int leftMoveType = -1,rightMoveType = -1;
	TouchInfo lefttouch,rightTouch;
	float[] leftCheckPoints,rightCheckPoints;
	MoveCreator _moveCreator;
	float widthFac,heightFac;

	List<MoveProps> movesLeft = new List<MoveProps>(10);
	List<MoveProps> movesRight = new List<MoveProps>(10);

	float moveStayTime = 1.5f;
	float MaxStopTime = 1.5f;
	float MoveSpeed = 100;
	float tempoVal = 0.5f;

	bool leftTouchDecided = false,rightTouchDecided = false;
	float tempoAdditionFac = 1.0f;
	public bool shouldRotate = false;
	bool activeRotate = false;
	public bool canPinchIn = true;
	float thresholdMag;
	public bool pinching = false;

	public StatsValues stats = new StatsValues();
	bool ForceStartMove = false;

	public DrillGamePlay _drill,drillSingleMode,drillMultiMode;
	// Use this for initialization
	void Start () {
		widthFac = Screen.width / 1280.0f;
		heightFac = Screen.height / 800.0f;
		widthFac = 1.0f;
		heightFac = 1.0f;
		instance = this;
		canPinchIn = true;
		_moveCreator = new MoveCreator();
		_moveCreator.MaxMoveTypes = icons.Length+4;
		startTime = Time.realtimeSinceStartup;
		stats.startTime = Time.realtimeSinceStartup;
		float leftDistance = (Screen.width*0.455f + (1.5f)*icons[0].width*widthFac);
		leftCheckPoints = new float[5];
		for(int i=0;i<5;i++)
			leftCheckPoints[i] = -2*icons[0].width*widthFac+(i+1)*leftDistance/5;
		rightCheckPoints = new float[5];
		for(int i=0;i<5;i++)
			rightCheckPoints[i] = Screen.width+icons[0].width - (i+1)*leftDistance/5;
		thresholdMag = Screen.height * 0.08f;
		backGround.pixelInset = new Rect (-Screen.width / 2, -Screen.height / 2, Screen.width, Screen.height);
		initGUI();
		_drill = GameController.gameMode == GameMode.SinglePlayer ? drillSingleMode : drillMultiMode;
		SoundController.instance.SetMusicEnable(Menu.isMusic);
	}

	float timer = 0;
	float startTime=0;
	float rotatetimer = 0;
	float stoptimer = 0;
	float stoptimer2 = 0;
	// Update is called once per frame
	float moveSpeed = 50;
	bool isStoping = false;
	float lerpingTimer=0;
	bool addNewMove = true;
	int rotationMoves = 20;
	void OnDestroy()
	{
		instance = null;
	}
	void Update () {

		if(leftBoxAlpha>0)
			leftBoxAlpha -= Time.deltaTime;
		if(rightBoxAlpha>0)
			rightBoxAlpha -= Time.deltaTime;

		if(addNewMove)
		{
			addNewMove = false;
			timer = 0;
			//left move
			addMove(-1);
			addMove(1);
		}

		updateMove(movesLeft);
		updateMove(movesRight);

		CheckForPinchInStatus (movesLeft,true);
		CheckForPinchInStatus (movesRight,false);
		// Hoping To Change 


		TouchInput();
		isStoping = false;

		//force starting
		if(ForceStartMove)
		{
			for(int i=0;i<movesLeft.Count;i++)
			{
				movesLeft[i].isStoping = false;
				movesLeft[i].checkPoint++;
			}
			for(int i=0;i<movesRight.Count;i++)
			{
				movesRight[i].isStoping = false;
				movesRight[i].checkPoint++;
			}
			addNewMove = true;
			ForceStartMove = false;
			if(shouldRotate)
			{
				rotationMoves--;
				if(rotationMoves==0)
				{
					shouldRotate = false;
				}
				StartCoroutine(rotationBar());
				rotateMove(movesLeft);
				rotateMove(movesRight);
			}
		}
		comboRotationAngle = comboRotationAngle+stats.combo*20*Time.deltaTime;
	}
	void addMove(int dir)
	{
		int newmove =dir>0? _moveCreator.getLeftMove():_moveCreator.getRightMove();
		MoveProps move = new MoveProps();
		int diff = 0;
		if(newmove > 1)
		{
			diff = newmove - 2;
			newmove = 2;
		}
		move.moveType = newmove;
		move.destroyTimer = moveStayTime;
		move.moveDir = dir;
		move.rotateAngle = diff*90;
		move.moveSpeed = MoveSpeed;
		if(dir>0)
		{
			move.moveRect = new Rect(-2*icons[newmove].width,Screen.height*0.205f-icons[newmove].height/2,icons[newmove].width*widthFac,icons[newmove].height*heightFac);
			movesLeft.Add(move);
		}
		else
		{
			move.moveRect = new Rect(Screen.width+icons[newmove].width,Screen.height*0.205f-icons[newmove].height/2,icons[newmove].width*widthFac,icons[newmove].height*heightFac);
			movesRight.Add(move);
		}
	}
	void updateMove(List<MoveProps> moves)
	{
		for(int i=0;i<moves.Count;i++)
		{
			MoveProps move = moves[i];
			//check for stay
			float posx = Screen.width*(0.5f-move.moveDir*0.045f)-move.moveRect.width/2;
			if(move.moveDir>0?(move.moveRect.x>=posx):(move.moveRect.x<=posx))
			{
				move.destroyTimer-=Time.deltaTime;
				if(move.destroyTimer<=0)
				{
					moves.RemoveAt(i);
					i--;
					canPinchIn = true;
					if(move.moveDir > 0)
					{
						if(leftTouchDecided && move.moveType!=0)
							updateStats(false);
						leftTouchDecided = false;
						leftTakeInput = true;
						leftMoveType = -1;
					}
					else
					{
						if(rightTouchDecided && move.moveType!=0)
							updateStats(false);
						rightTouchDecided = false;
						rightTakeInput = true;
						rightMoveType = -1;
					}
				}
			}
			else
			{
				if((move.moveDir>0?move.moveRect.x<leftCheckPoints[move.checkPoint]:move.moveRect.x>rightCheckPoints[move.checkPoint])&&!move.isStoping)
				{
					move.lerpingTimer += Time.deltaTime*5;
					if(move.lerpingTimer>0.5f)
						move.lerpingTimer = 0.5f;
					move.moveSpeed = MoveSpeed*(1+Mathf.Sin(3*Mathf.PI/2+Mathf.PI*move.lerpingTimer));
				}
				else if(move.isStoping)
				{
					move.lerpingTimer = 0;
					move.moveSpeed = Mathf.Lerp(move.moveSpeed,0,Time.deltaTime*5);
					move.stopingTimer += Time.deltaTime;
					if(move.stopingTimer>MaxStopTime)
					{
						ForceStartMove = true;
					}
				}
				else
				{
					move.isStoping = true;
					move.stopingTimer = 0;
				}
				move.moveRect.x += move.moveDir*Time.deltaTime*move.moveSpeed;
				move.destroyTimer = moveStayTime;
			}
				
	
		}
	}

	void rotateMove(List<MoveProps> moves)
	{
		for(int i=0;i<moves.Count;i++)
		{
			if(moves[i].moveType!=0 && Mathf.Abs(Screen.width*(0.5f-moves[i].moveDir*0.045f)-moves[i].moveRect.width/2-moves[i].moveRect.x)>40)
			{
				StartCoroutine(rotateAngle(moves[i]));
			}
		}
	}
	
	IEnumerator rotateAngle(MoveProps move)
	{
		float startAngle = move.rotateAngle;
		float targetAngle = startAngle + move.moveDir*90;
		bool _isRunning = true;
		float _time = 0;
		while(_isRunning)
		{
			_time += Time.deltaTime*5;
			move.rotateAngle = Mathf.Lerp(startAngle,targetAngle,_time);
			if(_time>=1.0f)
				_isRunning = false;
			yield return 0;
		}
		move.rotateAngle = targetAngle;

		yield return 0;
	}
	IEnumerator rotationBar()
	{
		float startWidth = rotateBarRect.width;
		float targetWidth = startWidth - rotateBar.width/20;
		bool _isRunning = true;
		float _time = 0;
		while(_isRunning)
		{
			_time += Time.deltaTime*5;
			rotateBarRect.width = Mathf.Lerp(startWidth,targetWidth,Easing.Exponential.easeOut(_time));
			if(_time>=1.0f)
				_isRunning = false;
			yield return 0;
		}
		rotateBarRect.width = targetWidth;
		
		yield return 0;
	}

#region Touch Inputs
	int touchId = -1;
	void TouchInput()
	{
		if(Input.touchCount>0)
		{
			for(int i=0;i<Input.touchCount;i++)
			{
				Touch _touch = Input.touches[i];
				if(_touch.phase == TouchPhase.Began && touchId==-1)
				{
					Vector2 touch = _touch.position;
					touch.y = Screen.height - touch.y;
					if(sliderGroupRect.Contains(touch))
					{
						touchId = _touch.fingerId;
						setSliderValue((touch.x-sliderGroupRect.x)/sliderbackground.width);
					}
				}
				else if(_touch.phase == TouchPhase.Moved && touchId == _touch.fingerId)
				{
					Vector2 touch = _touch.position;
					touch.y = Screen.height - touch.y;
					//if(sliderGroupRect.Contains(touch))
					{
						setSliderValue((touch.x-sliderGroupRect.x)/sliderbackground.width);
					}
				}
				else if(_touch.phase == TouchPhase.Ended && touchId == _touch.fingerId)
				{
					touchId = -1;
				}
			}
		}
		else
		{
			if(Input.GetMouseButtonDown(0) && touchId==-1)
			{
				Vector2 touch = new Vector2(Input.mousePosition.x,Input.mousePosition.y);
				touch.y = Screen.height - touch.y;
				if(sliderGroupRect.Contains(touch))
				{
					touchId = 0;
					setSliderValue((touch.x-sliderGroupRect.x)/sliderbackground.width);
				}
			}
			else if(Input.GetMouseButton(0) && touchId == 0)
			{
				Vector2 touch = new Vector2(Input.mousePosition.x,Input.mousePosition.y);
				touch.y = Screen.height - touch.y;
				//if(sliderGroupRect.Contains(touch))
				{
					setSliderValue((touch.x-sliderGroupRect.x)/sliderbackground.width);
				}
			}
			else if(Input.GetMouseButtonUp(0) && touchId == 0)
			{
				touchId = -1;
			}
		}

	}
#endregion
	float sliderValue = 0;
	void setSliderValue(float value)
	{
		sliderRect.x = value*sliderbackground.width - sliderRect.width/2;
		sliderRect.x = Mathf.Clamp(sliderRect.x,0,sliderGroupRect.width-sliderRect.width);
		fillUVRect.width = sliderRect.x/sliderbackground.width;
		fillRect.width = sliderRect.x;
		sliderValue = Mathf.Clamp(value,0.0f,1.0f);

		MoveSpeed = 50 + 200*sliderValue;
		moveStayTime = 1.5f -0.75f*sliderValue;
		MaxStopTime = moveStayTime;
	}
#region ONGUI
	Vector2 pivotPoint = Vector2.zero;
	Vector2 comboPivot = Vector2.zero;
	Vector2 rotatePivot = Vector2.zero;
	Rect sliderGroupRect,sliderbgRect,sliderRect,fillUVRect,fillRect,rightRect,leftRect,rotateRect,comboRect,comboValueRect,currectValueRect,rotateBarRect;
	float rightBoxAlpha,leftBoxAlpha;
	bool isLeftCorrect,isRightCorrect;
	public GUISkin skin;
	float comboRotationAngle=0;
	void initGUI()
	{
		sliderGroupRect = new Rect(Screen.width-sliderbackground.width*1.2f,Screen.height*0.05f,sliderbackground.width*widthFac,slider.height*heightFac);
		sliderbgRect = new Rect(0,(slider.height-sliderbackground.height)/2,sliderbackground.width*widthFac,sliderbackground.height*heightFac);
		sliderRect = new Rect(0,0,slider.width*widthFac,slider.height*heightFac);
		fillUVRect = new Rect(0,0,0,1);
		fillRect = sliderbgRect;
		rightRect = new Rect(Screen.width*0.545f-rightbox.width/2,Screen.height*0.205f-rightbox.height/2,rightbox.width*widthFac,rightbox.height*heightFac);
		leftRect = new Rect(Screen.width*0.455f-rightbox.width/2,Screen.height*0.205f-rightbox.height/2,rightbox.width*widthFac,rightbox.height*heightFac);
		rotateRect = new Rect(Screen.width*0.02f,Screen.height*0.02f,rotateButton.width*widthFac,rotateButton.height*heightFac);
		comboRect = new Rect(Screen.width*0.2f,Screen.height*0.03f,comboicon.width*widthFac,comboicon.height*heightFac);
		comboPivot = new Vector2(comboRect.x+comboRect.width/2,comboRect.y+comboRect.height/2);
		comboValueRect = new Rect(Screen.width*0.26f,Screen.height*0.03f,comboicon.width*widthFac,comboicon.height*heightFac);
		currectValueRect = new Rect(Screen.width*0.5f-comboicon.width/2,Screen.height*0.03f,comboicon.width*widthFac,comboicon.height*heightFac);
		rotateBarRect = new Rect(0,Screen.height*0.205f-rotateBar.height/2,rotateBar.width*widthFac,rotateBar.height*heightFac);
		rotatePivot = new Vector2(Screen.width*0.5f,Screen.height*0.205f);
	}
	void resetRotate()
	{
		shouldRotate = false;
	}
	void OnGUI()
	{
		//rotate icon
		if(shouldRotate)
		{
			if(GUI.Button(rotateRect,rotateButton))
			{
				shouldRotate = false;
				rotationMoves = 0;
				SoundController.instance.ButtonSoundSource.Play();
				//CancelInvoke("resetRotate");
			}
			//rotate bar
			GUI.DrawTexture(rotateBarRect,rotateBar);
			GUIUtility.RotateAroundPivot(180,rotatePivot);
			GUI.DrawTexture(rotateBarRect,rotateBar);
			GUIUtility.RotateAroundPivot(-180,rotatePivot);
		}
		if(activeRotate)
		{
			if(GUI.Button(rotateRect,"",skin.customStyles[0]))
			{
				shouldRotate = true;
				activeRotate = false;
				rotationMoves = 20;
				rotateBarRect.width = rotateBar.width;
				SoundController.instance.ButtonSoundSource.Play();
			}
		}
		else if(!shouldRotate)
			GUI.DrawTexture(rotateRect,rotateButtonGrey);

		//combo
		GUIUtility.RotateAroundPivot(comboRotationAngle,comboPivot);
		GUI.DrawTexture(comboRect,comboicon);
		GUIUtility.RotateAroundPivot(-comboRotationAngle,comboPivot);
		GUI.Label(comboValueRect,"x"+stats.combo,skin.customStyles[1]);
		//correct moves
		GUI.Label(currectValueRect,""+stats.correct,skin.customStyles[2]);


		//right wrong box
		if(leftTouchDecided)
			GUI.DrawTexture(leftRect,activebox);
		if(rightTouchDecided)
			GUI.DrawTexture(rightRect,activebox);
		GUI.color = new Color(1,1,1,leftBoxAlpha);
		GUI.DrawTexture(leftRect,(isLeftCorrect?rightbox:wrongbox));
		GUI.color = new Color(1,1,1,rightBoxAlpha);
		GUI.DrawTexture(rightRect,(isRightCorrect?rightbox:wrongbox));
		GUI.color = new Color(1,1,1,1);
		//moves
		drawMove(movesLeft);
		drawMove(movesRight);
		//silder
		GUI.BeginGroup(sliderGroupRect);
			GUI.DrawTexture(sliderbgRect,sliderbackground);
			GUI.DrawTextureWithTexCoords(fillRect,sliderfill,fillUVRect);
			GUI.DrawTexture(sliderRect,slider);
		GUI.EndGroup();
	}
	void drawMove(List<MoveProps> moves)
	{
		for(int i=0;i<moves.Count;i++)
		{
			
			Color clr = GUI.color;
			clr.a = moves[i].destroyTimer/moveStayTime;
			GUI.color = clr;
			pivotPoint.x = moves[i].moveRect.x+moves[i].moveRect.width/2;
			pivotPoint.y = moves[i].moveRect.y+moves[i].moveRect.height/2;
			GUIUtility.RotateAroundPivot(moves[i].rotateAngle,pivotPoint);
			//if(moves[i].rotateAngle > 0)
				//Debug.Log("rect = "+moves[i].moveRect);
			GUI.DrawTexture(moves[i].moveRect,icons[moves[i].moveType]);
			GUIUtility.RotateAroundPivot(-moves[i].rotateAngle,pivotPoint);
			GUI.color = new Color(1,1,1,1);
		}
	}
#endregion

#region Stats Update
	void updateStats(bool current)
	{
		if(current)
		{
			SoundController.instance.RightTapSource.Play();
			stats.combo++;
			stats.correct++;
			if(!activeRotate&&!shouldRotate)
			stats.rotatecombo++;
			if(stats.rotatecombo>=20)
			{
				stats.rotatecombo=0;
				activeRotate = true;
			}
			if(stats.comboMaxed<stats.combo)
				stats.comboMaxed = stats.combo;
			_drill.increaseSpeed(0.1f+sliderValue+(shouldRotate?0.5f:0.0f));
		}
		else
		{
			SoundController.instance.WrongTapSource.Play();
			stats.wrong++;
			if(stats.comboMaxed<stats.combo)
				stats.comboMaxed = stats.combo;
			stats.combo = 0;
			stats.rotatecombo=0;
			_drill.decreaseSpeed(0.1f+sliderValue+(shouldRotate?0.5f:0.0f));
		}
	}
#endregion
	public void SetLeftTouch(TouchInfo touch)
	{
		if(!leftTouchDecided)
			return;

			lefttouch = touch;
		    if (lefttouch.touchHalf == 0) {
						LeftDecision (false);
			            return;
				}
		if (lefttouch.touchState == TouchState.TAP_ENDED) 
		{
			if(leftTouchDecided)
			{
				if(leftMoveType == 1)
				{
					LeftDecision(true);
				}
				else
				{
					LeftDecision(false);
				}
			}
			else
			{
				//LeftDecision(false);
			}
		}
		if (lefttouch.touchDeltafromBegin.magnitude > thresholdMag) 
		{
			//rightTouchDecided = true;
			if(!leftTouchDecided)
			{
				LeftDecision(false);
			}
			else
			{
				float magX = lefttouch.touchDeltafromBegin.x;
				float magY = lefttouch.touchDeltafromBegin.y;
				if(Mathf.Abs(magX) > Mathf.Abs(magY))
				{
					if(magX > 0)
					{
						lefttouch.touchState = TouchState.SWIPE_RIGHT;
					}
					else
					{
						lefttouch.touchState = TouchState.SWIPE_LEFT;
					}
				}
				else
				{
					if(magY > 0)
					{
						lefttouch.touchState = TouchState.SWIPE_UP;
					}
					else
					{
						lefttouch.touchState = TouchState.SWIPE_DOWN;
					}
				}
				
				if(((int)lefttouch.touchState ) == leftMoveType)
				{
					LeftDecision(true);
				}
				else
				{
					LeftDecision(false);
				}
			}
		}
		
	}

	public void SetRightTouch(TouchInfo touch)
	{
		if(!rightTouchDecided)
			return;

			rightTouch = touch;
		if (rightTouch.touchHalf == 0) {
			RightDecision (false);
			return;
		}
		if (rightTouch.touchState == TouchState.TAP_ENDED) 
		{
			if(rightTouchDecided)
			{

				if(rightMoveType == 1)
				{
					RightDecision(true);
				}
				else
				{
					RightDecision(false);
				}
			}
			else
			{
				//RightDecision(false);
			}
		}
			if (rightTouch.touchDeltafromBegin.magnitude > thresholdMag) 
			{
				//rightTouchDecided = true;
			    if(!rightTouchDecided)
			   {
				RightDecision(false);
			   }
			   else
			   {
				float magX = rightTouch.touchDeltafromBegin.x;
				float magY = rightTouch.touchDeltafromBegin.y;
				if(Mathf.Abs(magX) > Mathf.Abs(magY))
				{
					if(magX > 0)
					{
						rightTouch.touchState = TouchState.SWIPE_RIGHT;
					}
					else
					{
						rightTouch.touchState = TouchState.SWIPE_LEFT;
					}
				}
				else
				{
					if(magY > 0)
					{
						rightTouch.touchState = TouchState.SWIPE_UP;
					}
					else
					{
						rightTouch.touchState = TouchState.SWIPE_DOWN;
					}
				}

				if(((int)rightTouch.touchState ) == rightMoveType)
				{
					RightDecision(true);
				}
				else
				{
					RightDecision(false);
				}
			   }
			}

	}

	public void MoveSlider(float val)
	{
		tempoVal += val * tempoAdditionFac;
		pinching = true;
	}

	public bool getPinchInStatus()
	{
		return canPinchIn;
	}

	void LeftDecision(bool dec)
	{
		updateStats(dec);
		isLeftCorrect = dec;
		leftBoxAlpha = 1.0f;
		leftTouchDecided = false;
	}

	void RightDecision(bool dec)
	{
		updateStats(dec);
		isRightCorrect = dec;
		rightBoxAlpha = 1.0f;
		rightTouchDecided = false;
	}
	void CheckForPinchInStatus(List<MoveProps> moves,bool left)
	{
		for(int i=0;i<moves.Count;i++)
		{
			if(moves[i].moveType == 0)
			{
				continue;
			}
			if(!(Mathf.Abs(Screen.width*(0.5f-moves[i].moveDir*0.045f)-moves[i].moveRect.width/2-moves[i].moveRect.x)>40))
			{
				//StartCoroutine(rotateAngle(moves[i]));
				canPinchIn = false;
				//Debug.Log("moves[i] dir " + moves[i].moveDir);
				if(left && leftTakeInput)
				{
					//Debug.Log("i left = "+i);
					leftTouchDecided = true;
					leftTakeInput = false;
					int movetype = moves[i].moveType;
					if(movetype==2)
					{
						int angle = Mathf.RoundToInt(moves[i].rotateAngle/90);
						angle%=4;
						movetype += angle;
					}
					leftMoveType = movetype;
				}
				else if(rightTakeInput)
				{
					
					//Debug.Log("i right = "+i);
					rightTouchDecided = true;
					rightTakeInput = false;
					int movetype = moves[i].moveType;
					if(movetype==2)
					{
						int angle = Mathf.RoundToInt(moves[i].rotateAngle/90);
						angle=(angle+4*Mathf.Abs(angle))%4;
						movetype += angle;
					}
					rightMoveType = movetype;
				}
			}
		}
	}
	
	void SetLeftIncomingType(MoveProps leftGesture)
	{
		
	}
	
	void SetRightIncomingType(MoveProps rightGesture)
	{
		
	}
	

}
