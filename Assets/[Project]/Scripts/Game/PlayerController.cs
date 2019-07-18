using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class PlayerController : MonoBehaviour
{
	[SerializeField]
	private PlayerColourData m_PlayerColour;

	[SerializeField]
	private GameObject m_ChevronObject;

	[SerializeField]
	private GameObject m_SuckObject;

	[SerializeField]
	private GameObject m_DeathBeam;

	[SerializeField]
	private Light m_PlayerLight;

	[SerializeField]
	private CharacterData m_MechData = null;

	[SerializeField]
	private CharacterData m_PilotData = null;

	[SerializeField]
	private SoundData m_PlayerSounds;

	[SerializeField]
	private SoundData m_SoundData;

	[SerializeField]
	private GameObject m_SpawnEffect;

	[SerializeField]
	private GameObject m_MechExplosionEffect;

	[SerializeField]
	private GameObject m_DeathEffect;

	[SerializeField]
	private AudioMixerGroup m_MasterMixerGroup;

	[SerializeField]
	private string m_MechExplosionSound;

	[SerializeField]
	private string m_KillSound;

	[SerializeField]
	private int m_AudioSources;

	[SerializeField]
	private InvincibilityData m_InvincibilityData = null;

	private List<AudioSource> m_AudioSourceObjects = new List<AudioSource>();

	protected PlayerStats m_PlayerStats;
	protected GameObject m_PlayerStatsObject;

	protected PlayerStatus m_PlayerStatus;

	private AI m_AIController;
	private CharacterInput m_CharInput;
	protected CharacterMovement m_CharMovement;
	protected CharacterAttack m_CharAttack;

	protected CharacterData m_CurrentData;

	protected Animator m_Animator;
	protected Rigidbody m_Rigidbody;
	protected CapsuleCollider m_Capsule;

	protected GameObject m_MechObject;
	protected GameObject m_PilotObject;
	private PlayerController m_LastHitBy = null;
	private float m_LastHitTime = 0f;

	private bool m_AIControlled = false;
	private bool m_IsMech;
	private bool m_IsInvincible;
	private bool m_IsHitStun;
	private bool m_IsBlocking;
	private float m_DamageMultiplier = 1f;
	private float m_DamageReduction = 0f;


	private float m_PilotToMechTimeRemaining = 0f;

	private bool m_ShouldDetach = false;

	[SerializeField, Range( 0.01f, 1 )]
	private float m_BlockReduction = 0f;

	private float m_RespawnTime = 3.0f;

	[SerializeField]
	private float m_MaxVelocity = 10.0f;
	[SerializeField]
	private float m_VelocityDampening = 0.5f;

	private int m_CurrentHealth = 0;

	private int m_Lives = 3;

	[SerializeField]
	private float m_ChevronThreshold = 0.1f;

	[SerializeField]
	private float m_SpawnTime = 0.5f;

	private bool m_CanSpawn = false;
	private bool m_Dead;

	private float m_SpawnTimer = 3.0f;

	#region Properties

	public bool Dead { get { return m_Dead; } }
	public bool CanInput { get; set; }
	public bool IsMech { get { return m_IsMech; } }
	public bool IsInvincible { get { return m_IsInvincible; } set { m_IsInvincible = value; } }
	public bool IsHitStun { get { return m_IsHitStun; } set { m_IsHitStun = value; } }
	public bool IsBlocking { get { return m_IsBlocking; } set { m_IsBlocking = value; } }

	public int CurrentHealth { get { return m_CurrentHealth; } }
	public int Lives { get { return m_Lives; } set { m_Lives = value; } }
	public int PlayerID { get; set; }

	public float MaxVelocity { get { return m_MaxVelocity; } }
	public float VelocityDampening { get { return m_VelocityDampening; } }
	public float DamageMultiplier { get { return m_DamageMultiplier; } set { m_DamageMultiplier = value; } }
	public float DamageReduction { get { return m_DamageReduction; } set { m_DamageReduction = value; } }
	public float BlockReduction { get { return m_BlockReduction; } set { m_BlockReduction = value; } }
	public PlayerColourData PlayerColour { get { return m_PlayerColour; } set { m_PlayerColour = value; } }

	public Animator Animator { get { return m_Animator; } }

	public PlayerStats PlayerStats { get { return m_PlayerStats; } set { m_PlayerStats = value; } }
	public PlayerStatus PlayerStatus { get { return m_PlayerStatus; } set { m_PlayerStatus = value; } }
	public GameObject PlayerStatsObject { get { return m_PlayerStatsObject; } set { m_PlayerStatsObject = value; } }

	public GameObject BoostEffect { get { return ActiveObject.GetComponent<CharacterAttackJoint>().BoostObject; } }
	public GameObject SuckObject { get { return m_SuckObject; } }

	public CharacterInput CharacterInput { get { return m_CharInput; } }
	public CharacterMovement CharacterMovement { get { return m_CharMovement; } }
	public CharacterAttack CharacterAttack { get { return m_CharAttack; } }

	public CharacterData MechData { get { return m_MechData; } }
	public CharacterData PilotData { get { return m_PilotData; } }
	public CharacterData CurrentData { get { return m_CurrentData; } }
	public InvincibilityData InvincibilityData { get { return m_InvincibilityData; } }

	public GameObject MechObject { get { return m_MechObject; } }
	public GameObject PilotObject { get { return m_PilotObject; } }
	public GameObject ActiveObject { get { return m_IsMech ? m_MechObject : m_PilotObject; } }

	public bool ShouldDetach
	{
		get
		{
			return m_ShouldDetach;
		}

		set
		{
			m_ShouldDetach = value;
		}
	}

	public bool IsAIControlled
	{
		get
		{
			return m_AIControlled;
		}

		set
		{
			m_AIControlled = value;
		}
	}

	#endregion

	public void Initialise( int lPlayerID, bool lAIControl )
	{
		PlayerID = lPlayerID;

		m_CurrentHealth = m_MechData.Health;
		m_CharInput = GetComponent<CharacterInput>();
		m_CharMovement = GetComponent<CharacterMovement>();
		m_CharAttack = GetComponent<CharacterAttack>();
		m_PlayerColour = GameController.Instance.PlayerColours[lPlayerID];

		if( lAIControl )
		{
			m_AIControlled = true;
			m_AIController = GetComponent<AI>();
			m_AIController.enabled = true;
		}

		CanInput = false;

		if( m_CharInput != null )
		{
			m_CharInput.Controller = this;
		}

		if( m_CharMovement != null )
		{
			m_CharMovement.Controller = this;
		}

		if( m_CharAttack != null )
		{
			m_CharAttack.Controller = this;
		}

		m_PilotObject = Instantiate( m_PilotData.CharPrefab, transform.position, Quaternion.identity, transform );
		m_MechObject = Instantiate( m_MechData.CharPrefab, transform.position, Quaternion.identity, transform );

		m_PlayerStats = new PlayerStats();

		//Set components to be Mech's components - true is Mech
		SwapCharacter( lToMech: true );

		//Player ID is zero-indexed, controller is not
		m_CharInput.ControllerID = lPlayerID + 1;

		m_SpawnTimer = m_SpawnTime;

		ArenaController.Instance.OnArenaLoad += OnArenaLoad;

		//Initialise PlayerStatus on in game screen
		GamePanel lGP = (GamePanel)UIController.Instance.UIPanels[eUIPanel.Game];
		//m_PlayerStatusObject = GameObject.Instantiate( UIController.Instance.PlayerStatusPrefab, UIController.Instance.GameUIParent );
		m_PlayerStatus = lGP.Players[lPlayerID];
		lGP.Players[lPlayerID].PlayerInstance = this;
		lGP.Players[lPlayerID].MechIcon.sprite = m_PlayerColour.MechAvatar;
		lGP.Players[lPlayerID].PilotIcon.sprite = m_PlayerColour.PilotAvatar;

		lGP.Players[lPlayerID].gameObject.SetActive( true );

		m_PlayerLight.color = m_PlayerColour.PColour;

		GameController.Instance.SetMechMaterial( gameObject, m_PlayerColour );

		CreateAudioSources();
	}

	private void OnArenaLoad( string lArena )
	{
		m_CanSpawn = true;
	}

	private void CreateAudioSources()
	{
		for( int i = 0; i < m_AudioSources; i++ )
		{
			CreateNewSource();
		}
	}

	private AudioSource CreateNewSource()
	{
		GameObject lObject = new GameObject();

		lObject.name = "AudioSource";
		lObject.transform.localPosition = Vector3.zero;
		lObject.transform.parent = transform;
		lObject.AddComponent<AudioSource>();
		lObject.GetComponent<AudioSource>().outputAudioMixerGroup = m_MasterMixerGroup;
		lObject.GetComponent<AudioSource>().spatialBlend = 0.85f;

		m_AudioSourceObjects.Add( lObject.GetComponent<AudioSource>() );

		return lObject.GetComponent<AudioSource>();
	}

	public void PlaySound( AudioClip lClip )
	{
		for( int i = 0; i < m_AudioSourceObjects.Count; i++ )
		{
			if( !m_AudioSourceObjects[i].isPlaying )
			{
				m_AudioSourceObjects[i].PlayOneShot( lClip );
				return;
			}
		}
	}

	public void Deinitialise()
	{
		//Remove from target group
		CameraController.Instance.RemoveFromGroup( transform );
	}

	public IEnumerator Detach( float lTime )
	{
		ShouldDetach = true;
		yield return new WaitForSeconds( lTime );
		ShouldDetach = false;
	}

	private void Start()
	{
		if( !MatchController.Instance.GameModeData.UnlimitedLives )
			PlayerStats.Score = GameController.Instance.NumberOfPlayers;

		GameController.Instance.OnGameStateChange += OnGameStateChange;
	}

	private void OnGameStateChange( GameStateBase lState )
	{
		if( lState.GetType() == typeof( MenuState ) )
		{
			Destroy( m_PlayerStatsObject );
		}
	}

	private void Update()
	{
		if( !IsMech )
		{
			if( m_PilotToMechTimeRemaining <= 0 )
			{
				SwapCharacter( !m_IsMech );
			}
			m_PilotToMechTimeRemaining = Mathf.Max( 0f, m_PilotToMechTimeRemaining - Time.deltaTime );
		}

		if( Input.GetKeyDown( KeyCode.M ) && GameController.Instance.DebugMode )
		{
			SwapCharacter( !m_IsMech );
		}

		CheckChevron();

		if( m_CanSpawn )
		{
			if( m_SpawnTimer >= 0 )
			{
				m_SpawnTimer -= Time.unscaledDeltaTime;

				if( m_SpawnTimer <= 0 )
				{
					//Debug.Log( "Spawning" );
					TrySpawn();
				}
			}
		}

		m_LastHitTime = Mathf.Max( 0f, m_LastHitTime - Time.deltaTime );

		if( m_LastHitTime <= 0f )
		{
			m_LastHitBy = null;
		}
	}

	private void CheckChevron()
	{
		if( !ActiveObject.activeSelf )
		{
			m_ChevronObject.SetActive( false );

			return;
		}

		if( m_ChevronObject != null )
		{
			if( m_Capsule == null )
			{
				m_Capsule = ActiveObject.GetComponent<CapsuleCollider>();
			}

			m_ChevronObject.GetComponentInChildren<Renderer>().material.color = m_PlayerColour.PColour;

			if( m_Capsule != null )
			{
				Vector3 lBottom = Camera.main.WorldToViewportPoint( transform.position );
				Vector3 lTop = Camera.main.WorldToViewportPoint( transform.position + Vector3.up * m_Capsule.height );

				float lDelta = lTop.y - lBottom.y;

				if( lDelta < m_ChevronThreshold )
				{
					m_ChevronObject.SetActive( true );

					m_ChevronObject.transform.localPosition = Vector3.up * m_Capsule.height;
				}
				else
				{
					m_ChevronObject.SetActive( false );
				}
			}
			else
			{
				Debug.Assert( false, "[PlayerController] Collider could not be found on the player controller, does one still exist?" );
			}
		}
	}

	private void TrySpawn()
	{
		Debug.Log( m_Lives );
		if( ArenaController.Instance.SpawnPoints.Count > 0 && m_CanSpawn && m_Lives > 0 )
		{
			if( !m_AIControlled )
			{
				transform.position = ArenaController.Instance.GetSpawnPoint().transform.position;
			}
			else
			{
				transform.position = ArenaController.Instance.GetSpawnPoint().transform.position;
				m_AIController.Navigator.Warp( transform.position );
				m_AIController.Navigator.enabled = true;
				ActiveObject.transform.localPosition = Vector3.zero;
				ActiveObject.transform.localRotation = Quaternion.identity;
				m_ShouldDetach = false;
			}

			ArenaController.Instance.LastSpawn = ArenaController.Instance.SpawnPoints[m_CharInput.ControllerID - 1];

			m_PlayerLight.enabled = true;
			GetComponent<Rigidbody>().useGravity = true;
			GetComponent<Rigidbody>().velocity = Vector3.zero;
			gameObject.SetActive( true );
			SwapCharacter( true );
			m_Dead = false;

			m_CurrentHealth = m_MechData.Health;

			MakeInvincible( m_InvincibilityData.SpawnTime );

			m_CharAttack.Joint = m_MechObject.GetComponent<CharacterAttackJoint>().Joint;

			//Add to controller target group
			CameraController.Instance.AddToGroup( transform, 1, 2.5f );

			//Play Spawn effect
			//EffectsController.Instance.PlayEffectAtPosition( m_SpawnEffect.name, transform.position, Quaternion.identity );

			if( MatchController.Instance.InProgress )
				CanInput = true;
		}
		Lives -= 1;
	}

	private void MakeInvincible( float lTime )
	{
		StartCoroutine( m_CharMovement.Invincible( lTime ) );
	}

	public void MakeHitStun( float lTime )
	{
		m_Animator.SetTrigger( "HitStun" );
		StartCoroutine( m_CharMovement.HitStun( lTime ) );
		MakeInvincible( m_InvincibilityData.StunTime );
		StartCoroutine( Detach( lTime + 0.5f ) );
	}

	public void ChangeHealth( Collider lDamageSource, int lDelta )
	{
		if( lDamageSource != null )
		{
			m_LastHitBy = lDamageSource.GetComponentInParent<PlayerController>();
		}

		//Debug.Log( "Last hit by: " + m_LastHitBy );
		m_LastHitTime = 4f;

		if( lDelta < 0 )
		{
			m_PlayerStatus.PlayHealthFlashAnim();
			m_PlayerStats.AddDamageTaken( -lDelta );
		}

		m_CurrentHealth = Mathf.Clamp( m_CurrentHealth + lDelta, 0, m_CurrentData.Health );

		if( m_CurrentHealth <= 0 )
		{
			if( m_IsMech )
			{
				PlaySound( m_PlayerSounds.GetSound( m_MechExplosionSound ) );

				TimeController.Instance.TryDampenTime();

				//CameraShake.Instance.Shake( 0.05f, 10.0f, 1.0f );

				SwapCharacter( lToMech: false );

				MakeInvincible( m_InvincibilityData.SwapTime );

				m_Animator.SetTrigger( "Eject" );

				//Add to data object i.e. MechEjectForce
				GetComponent<Rigidbody>().AddForce( new Vector3( 0f, 50f, 0f ), ForceMode.Impulse );

				if( m_LastHitBy != null )
				{
					m_LastHitBy.PlayerStats.IncrementScore();
				}
				else
				{
					PlayerStats.DecrementScore();
				}

				VibrateController( 75.0f, 0.65f );

				//EffectsController.Instance.PlayEffectAtPosition( m_MechExplosionEffect.name, transform.position, Quaternion.identity );
			}
			else
			{
				KillPlayer();
			}
		}
		else
		{
			if( lDelta < 0 )
			{
				VibrateController( lDelta, 0.35f );
			}
		}
	}

	private void KillPlayer()
	{
		m_PlayerStats.IncrementDeaths();

		if( m_LastHitBy != null )
		{
			m_LastHitBy.PlayerStats.IncrementScore();
			m_LastHitBy.PlayerStatus.PlayPlusMinusAnim( true );
			m_LastHitBy.PlayerStats.AddDamageDealt( m_CurrentHealth );
		}
		else
		{
			PlayerStats.DecrementScore();
			PlayerStatus.PlayPlusMinusAnim( false );
		}

		m_LastHitBy = null;
		m_LastHitTime = 0f;
		m_CurrentHealth = 0;

		if( !MatchController.Instance.GameModeData.UnlimitedLives )
		{
			if( m_PlayerStatus.LivesList.Count > 0 )
			{
				Destroy( m_PlayerStatus.LivesList[0].gameObject );
				m_PlayerStatus.LivesList.RemoveAt( 0 );
			}

			if( Lives <= 0 )
			{
				PlayerStats.Score = GameController.Instance.NumberOfPlayers - MatchController.Instance.PlayersLeft;
				MatchController.Instance.PlayersLeft--;
			}
		}

		m_PlayerLight.enabled = false;

		ActiveObject.SetActive( false );
		GetComponent<Rigidbody>().useGravity = false;
		GetComponent<Rigidbody>().velocity = Vector3.zero;
		m_Dead = true;

		//ChangeHealth( null, -CurrentHealth );

		Invoke( "TrySpawn", m_RespawnTime );
		m_CharInput.ResetCooldownList();

		//Add to controller target group
		CameraController.Instance.RemoveFromGroup( transform );

		//CameraShake.Instance.Shake( 0.10f, 10.0f, 1.0f );

		if( m_SoundData != null )
			SoundController.Instance.PlaySound( m_SoundData.GetSound( m_KillSound ), Camera.main.transform, false, 0.02f );

		//Play Death effect
		//EffectsController.Instance.PlayEffectAtPosition( m_DeathEffect.name, transform.position, Quaternion.identity );

		VibrateController( 100.0f, 0.35f );

		CanInput = false;
	}

	private void OnCollisionEnter( Collision lCollision )
	{
		if( lCollision.gameObject.tag == "KillPlane" )
		{
			KillPlayer();
		}
	}

	///Strength is out of 100 and time is raw seconds
	///Uses XInput library
	public void VibrateController( float lStrength, float lTime )
	{
		if( !m_AIControlled )
			StartCoroutine( SetVibration( lStrength, lTime ) );
	}

	public IEnumerator SetVibration( float lStrength, float lTime )
	{
		//GamePad.SetVibration( (PlayerIndex)PlayerID, lStrength, lStrength );

		yield return new WaitForSeconds( lTime );

		//GamePad.SetVibration( (PlayerIndex)PlayerID, 0.0f, 0.0f );
	}

	public void ResetVibration()
	{
		//GamePad.SetVibration( (PlayerIndex)PlayerID, 0.0f, 0.0f );
	}

	public IEnumerator RemoveInput( float lTime )
	{
		CanInput = false;

		yield return new WaitForSeconds( lTime );

		CanInput = true;
	}

	/// <summary>
	/// Swaps between character states - true means Mech
	/// </summary>
	/// <param name="lToMech"></param>
	private void SwapCharacter( bool lToMech )
	{
		//Set lerp value back to 100%
		if( m_PlayerStatus != null )
		{
			m_PlayerStatus.PrevHealthVal = 100;
		}

		m_CurrentData = lToMech ? m_MechData : m_PilotData;

		if( !lToMech )
		{
			MakeInvincible( m_InvincibilityData.SpawnTime );
			m_PilotToMechTimeRemaining = m_CurrentData.PilotToMechTime;
		}

		m_PilotObject.SetActive( !lToMech );
		m_MechObject.SetActive( lToMech );

		GameObject lCurrentActive = lToMech ? m_MechObject : m_PilotObject;
		m_CharMovement.UpdateData( m_CurrentData, lCurrentActive );
		m_CurrentHealth = lToMech ? m_MechData.Health : m_PilotData.Health;

		m_Capsule = lCurrentActive.GetComponent<CapsuleCollider>();
		m_Animator = lCurrentActive.GetComponent<Animator>();

		if( m_Animator != null )
		{
			m_Animator.SetTrigger( "MechReturn" );
		}

		if( MatchController.Instance.InProgress )
		{
			StartCoroutine( RemoveInput( 1.0f ) );
		}

		m_IsMech = lToMech;
	}
}
