using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cooldown
{
	public eAttackType AttackType;
	public float TimeLeft;

	public Cooldown( eAttackType lAttackType, float lTimeLeft )
	{
		AttackType = lAttackType;
		TimeLeft = lTimeLeft;
	}
}

[RequireComponent( typeof( CharacterMovement ) )]
public class CharacterInput : MonoBehaviour
{
	[SerializeField]
	private InputData m_InputData = null;

	private GameObject m_PlantedBomb;
	private GameObject m_MechMissile;
	private GameObject m_SuckObject;
	private List<Cooldown> m_CooldownList = new List<Cooldown>();
	//private Coroutine m_JumpRoutine;
	private CharacterMovement m_CharacterMovement;
	private CharacterAttack m_CharacterAttack;
	private Transform m_Cam;
	private Vector3 m_Move;
	private bool m_Mobility;
	//private bool m_Jump;
	private bool m_ChargingHeavy = false;
	private float m_MobilityCooldown;
	private float m_RecoveryTime;
	private bool m_AlternateQuickAttack = false;

	public PlayerController Controller { get; set; }

	public CharacterMovement CharacterMovement { get { return m_CharacterMovement; } set { m_CharacterMovement = value; } }
	public CharacterAttack CharacterAttack { get { return m_CharacterAttack; } set { m_CharacterAttack = value; } }
	public GameObject PlantedBomb { get { return m_PlantedBomb; } set { m_PlantedBomb = value; } }
	public GameObject MechMissile { get { return m_MechMissile; } set { m_MechMissile = value; } }

	public List<Cooldown> CooldownList { get { return m_CooldownList; } }
	public InputData InData { get { return m_InputData; } }
	//public bool Jump { get { return m_Jump; } }
	public float MobilityCooldown { get { return m_MobilityCooldown; } }
	public float RecoveryTime { get { return m_RecoveryTime; } set { m_RecoveryTime = value; } }
	public int ControllerID { get; set; }

	public bool IsInMobility
	{
		get
		{
			return m_Mobility;
		}

		set
		{
			m_Mobility = value;
		}
	}

	private void Start()
	{
		if( Camera.main != null )
		{
			m_Cam = Camera.main.transform;
		}
		else
		{
			Debug.LogWarning(
				"Warning: no main camera found. CharacterMovement needs a Camera tagged \"MainCamera\" for controls." );
		}
		m_CharacterMovement = GetComponent<CharacterMovement>();
		m_CharacterAttack = GetComponent<CharacterAttack>();
	}

	public void Update()
	{
		if( Controller.IsHitStun )
		{
			Controller.Animator.SetBool( "HeavyAttack", false );
			m_ChargingHeavy = false;
			m_CharacterMovement.MoveSpeedMultiplier = Controller.CurrentData.MoveSpeed;
		}

		if( Input.GetButtonUp( m_InputData.BlockAxis + ControllerID ) && Controller.IsMech )
		{
			Controller.ActiveObject.GetComponent<CharacterAttackJoint>().BlockObject.SetActive( false );
			Controller.IsBlocking = false;
			Controller.Animator.SetBool( "Blocking", false );
			//Controller.Animator.SetTrigger( "BlockEnd" );
		}

		if( Input.GetButtonUp( m_InputData.HeavyAttackAxis + ControllerID ) && m_ChargingHeavy && !Controller.IsHitStun )
		{
			if( !CooldownActive( eAttackType.HeavyMelee ) )
			{
				Controller.Animator.SetBool( "HeavyAttack", false );
				CharacterAttack.Attack( eAttackType.HeavyMelee );
				m_CooldownList.Add( new Cooldown( eAttackType.HeavyMelee, m_InputData.HeavyCooldown ) );
				m_CharacterMovement.MoveSpeedMultiplier = Controller.CurrentData.MoveSpeed;
				m_ChargingHeavy = false;
			}
		}

		if( !Controller.IsHitStun && Controller.CanInput && m_RecoveryTime == 0 )
		{
			if( Controller.IsMech )
			{
				if( !Controller.IsBlocking )
				{
					if( !m_ChargingHeavy )
					{
						if( Input.GetButtonDown( m_InputData.QuickAttackAxis + ControllerID ) && m_RecoveryTime == 0 )
						{
							Attack( eAttackType.QuickMelee, m_InputData.QuickCooldown, "QuickAttack" );
							StartCoroutine( m_CharacterMovement.ChangeMoveSpeedTemporarily( -1f, 1 ) );
						}

						if( Input.GetButtonDown( m_InputData.HeavyAttackAxis + ControllerID ) && m_RecoveryTime == 0 )
						{
							if( !CooldownActive( eAttackType.HeavyMelee ) )
							{
								Controller.Animator.SetTrigger( "HeavyAttackStart" );
								Controller.Animator.SetBool( "HeavyAttack", true );
								m_CharacterMovement.MoveSpeedMultiplier -= 8f;
								m_ChargingHeavy = true;
								//Start charging coroutine
							}
						}

						if( Input.GetButtonDown( m_InputData.RangedAttackAxis + ControllerID ) )
						{
							if( !CooldownActive( eAttackType.Ranged ) )
							{
								//Fire Missile
								Debug.Log( "Missile active" );
								Attack( eAttackType.Ranged, m_InputData.MechRangedCooldown, "RangedAttack" );
							}
							else if( CooldownActive( eAttackType.Ranged ) )
							{
								//explode
								if( m_MechMissile != null )
								{
									m_MechMissile.GetComponent<SphereCollider>().radius = 5f;
									Destroy( m_MechMissile, 0.1f );
									Debug.Log( "Missile exploded" );
								}
							}
						}

						if( Input.GetButtonDown( m_InputData.PilotBombAxis + ControllerID ) )
						{
							if( CooldownActive( eAttackType.Ranged ) )
							{
								if( m_MechMissile != null )
								{
									m_SuckObject = Instantiate( Controller.SuckObject, m_MechMissile.transform.position, m_MechMissile.transform.rotation );
									m_SuckObject.GetComponent<SuckObject>().OwnerCollider = Controller.ActiveObject.GetComponent<Collider>();
									Destroy( m_MechMissile );
									//m_SuckObject.GetComponent<AttackObject>().OwnerCollider = Controller.ActiveObject.GetComponent<Collider>();
									//play sucking effect
								}
							}
						}

						if( Input.GetButtonDown( m_InputData.MobilityAxis + ControllerID ) )
						{
							Mobility( m_InputData.RocketBoostCooldown );
						}

						if( Input.GetButtonDown( m_InputData.BlockAxis + ControllerID ) )
						{
							Controller.IsBlocking = true;
							Controller.Animator.SetBool( "Blocking", true );
							Controller.Animator.SetTrigger( "BlockDraw" );
							Controller.ActiveObject.GetComponent<CharacterAttackJoint>().BlockObject.SetActive( true );
						}
					}
				}
			}
			else
			{
				Controller.IsBlocking = false;

				if( Input.GetButtonUp( m_InputData.RangedAttackAxis + ControllerID ) )
				{
					Controller.Animator.SetTrigger( "FinishShooting" );
				}

				if( Input.GetButtonDown( m_InputData.RangedAttackAxis + ControllerID ) )
				{
					Attack( eAttackType.Ranged, m_InputData.PilotRangedCooldown, "RangedAttack" );
				}

				if( Input.GetButtonDown( m_InputData.PilotBombAxis + ControllerID ) ) //Pilot Bomb
				{
					if( !CooldownActive( eAttackType.BombPlot ) )
					{
						//plant bomb
						Debug.Log( "bomb active" );
						Attack( eAttackType.BombPlot, m_InputData.PilotBombCooldown, "" );
					}
					else if( CooldownActive( eAttackType.BombPlot ) )
					{
						//explode
						if( m_PlantedBomb != null )
						{
							m_PlantedBomb.GetComponent<SphereCollider>().radius = 5f;
							Debug.Log( m_PlantedBomb.GetComponent<SphereCollider>().radius + "Bomb Radius" );
							m_PlantedBomb.GetComponent<AttackObject>().DestroyAndExplode();
							Debug.Log( "bomb exploded" );
						}
					}
				}

				if( Input.GetButtonDown( m_InputData.MobilityAxis + ControllerID ) )
				{
					Mobility( m_InputData.DodgeCooldown );
					m_RecoveryTime += 0.2f;
				}
			}
		}

		for( int i = 0; i < m_CooldownList.Count; i++ )
		{
			m_CooldownList[i].TimeLeft -= Time.deltaTime;

			if( m_CooldownList[i].TimeLeft < 0 )
			{
				m_CooldownList.RemoveAt( i );
			}
		}

		m_MobilityCooldown = Mathf.Max( 0f, m_MobilityCooldown - Time.deltaTime );
		m_RecoveryTime = Mathf.Max( 0f, m_RecoveryTime - Time.deltaTime );
	}

	public void AIAttack( eAttackType lAttackType )
	{
		switch( lAttackType )
		{
			case eAttackType.QuickMelee:
				Attack( eAttackType.QuickMelee, m_InputData.QuickCooldown, "QuickAttack" );
				StartCoroutine( m_CharacterMovement.ChangeMoveSpeedTemporarily( -1f, 1 ) );
				break;
			case eAttackType.HeavyMelee:
				Attack( eAttackType.HeavyMelee, m_InputData.HeavyCooldown, "HeavyAttack" );
				//StartCoroutine( m_CharacterMovement.ChangeMoveSpeedTemporarily( -1f, 1 ) );
				break;
			case eAttackType.Ranged:
				Attack( eAttackType.Ranged, m_InputData.MechRangedCooldown, "RangedAttack" );
				StartCoroutine( m_CharacterMovement.ChangeMoveSpeedTemporarily( -1f, 1 ) );
				break;
			default:
				break;

		}
	}

	private void Attack( eAttackType lAttackType, float lCooldown, string lAnimation, bool lAddCooldown = true )
	{
		if( !CooldownActive( lAttackType ) )
		{
			if( m_CharacterAttack == null )
			{
				Debug.Log( "Character attack is null!" );
			}
			m_CharacterAttack.Attack( lAttackType );
			if( lAnimation != "" )
			{
				Controller.Animator.SetTrigger( lAnimation );
			}

			if( lAddCooldown )
			{
				m_CooldownList.Add( new Cooldown( lAttackType, lCooldown ) );
			}
		}

		//Custom Animation ID for each attack type that has multiple animations
		//Not really sure where else this should go
		switch( lAttackType )
		{
			case eAttackType.QuickMelee:
				if( m_AlternateQuickAttack )
				{
					Controller.Animator.SetFloat( "AttackID", 1 );
					m_AlternateQuickAttack = !m_AlternateQuickAttack;
				}
				else
				{
					Controller.Animator.SetFloat( "AttackID", 0 );
					m_AlternateQuickAttack = !m_AlternateQuickAttack;
				}
				//Controller.Animator.SetFloat( "AttackID", 1.0f / Random.Range( -1, 2 ) );
				break;
			default:
				break;

		}
	}

	public bool CooldownActive( eAttackType lAttackType )
	{
		for( int i = 0; i < m_CooldownList.Count; i++ )
		{
			if( m_CooldownList[i].AttackType == lAttackType )
			{
				return true;
			}
		}

		return false;
	}

	public void Mobility( float lCooldown )
	{
		m_Mobility = true;

		if( m_MobilityCooldown == 0 )
		{
			m_MobilityCooldown = lCooldown;
			Controller.Animator.SetTrigger( "Mobility" );
			if( Controller.IsMech )
			{
				Invoke( "ApplyRocketBoost", m_InputData.RocketDelay );
				m_CharacterAttack.Attack( eAttackType.RocketBoost );
				m_RecoveryTime += 0.5f;
			}
			else
				Invoke( "ApplyDodge", m_InputData.DodgeDelay );
		}
	}

	private void ApplyDodge()
	{
		m_CharacterMovement.DodgeRoll();
	}

	private void ApplyRocketBoost()
	{
		m_CharacterMovement.RocketBoost( m_InputData.RocketBoostTime );
	}

	private void FixedUpdate()
	{
		if( !Controller.IsHitStun && Controller.CanInput && !Controller.IsBlocking )
		{
			float lHorizontal = Input.GetAxis( m_InputData.MoveXAxis + ControllerID );
			//lHorizontal = Mathf.Clamp( lHorizontal * lHorizontal * Mathf.Sign( lHorizontal ), -1, 1 );

			float lVertical = Input.GetAxis( m_InputData.MoveYAxis + ControllerID );
			//lVertical = Mathf.Clamp( lVertical * lVertical * Mathf.Sign( lVertical ), -1, 1 );

			m_Move = new Vector3( lHorizontal, 0, lVertical );

			m_CharacterMovement.Move( m_Move );
			m_CharacterMovement.UpdateAnimator( Controller.Animator, m_Move );

			m_Mobility = false;
		}
	}

	public void ResetCooldownList()
	{
		m_CooldownList.Clear();
		m_MobilityCooldown = 0f;
		m_RecoveryTime = 0f;
	}
}
