using System.Collections;
using System.Collections.Generic;
using System;
using System.Linq;
using UnityEngine;
using UnityEngine.AI;

/// <summary>
/// Class that controls AI behaviour.
/// </summary>
/// 
/// Claudiu Gheorghica
///

[RequireComponent( typeof( NavMeshAgent ) )]

public class AI : MonoBehaviour
{
	private StateMachine<AI> m_StateMachine;
	private NavMeshAgent m_Navigator;
	private MatchController m_MatchController;
	private PlayerController m_PlayerController;
	private GameController m_GameController;

	[SerializeField]
	private float m_DistanceToClosestTarget = 0;

	//Float to determine the max height the agent is considered on the NavMesh
	[SerializeField]
	private float m_OnMeshThreshold = 3f;
	[SerializeField]
	private PlayerController m_PlayerTarget;
	[SerializeField]
	private GameObject m_Target;
	[SerializeField]
	private Vector3 m_MoveTarget;

	private CharacterInput m_CharInput;
	private CharacterMovement m_CharMovement;
	private CharacterAttack m_CharAttack;
	private List<PowerUpSpawner> m_PowerUpLocations;
	private PowerUpSpawner m_PowerUpTarget;
	private bool m_PowerUpDestinationSet = false;

	[SerializeField]
	private float m_ProjectileRange;
	[SerializeField]
	private float m_MeleeRange;
	[SerializeField]
	private float m_BoostRange;
	[SerializeField]
	private float m_MinMoveDistance;

	#region Properties
	public StateMachine<AI> StateMachine
	{
		get
		{
			return m_StateMachine;
		}
		set
		{
			m_StateMachine = value;
		}
	}

	public NavMeshAgent Navigator
	{
		get
		{
			return m_Navigator;
		}
		private set
		{
			m_Navigator = value;
		}
	}

	public float ProjectileRange
	{
		get
		{
			return m_ProjectileRange;
		}
		set
		{
			m_ProjectileRange = value;
		}
	}

	public float MeleeRange
	{
		get
		{
			return m_MeleeRange;
		}
		set
		{
			m_MeleeRange = value;
		}
	}

	public PlayerController PlayerTarget
	{
		get
		{
			return m_PlayerTarget;
		}
		set
		{
			m_PlayerTarget = value;
		}
	}

	public GameController GameController
	{
		get
		{
			return m_GameController;
		}
		set
		{
			m_GameController = value;
		}
	}

	public MatchController MatchController
	{
		get
		{
			return m_MatchController;
		}
		set
		{
			m_MatchController = value;
		}
	}

	public Vector3 MoveTarget
	{
		get
		{
			return m_MoveTarget;
		}

		set
		{
			m_MoveTarget = value;
		}
	}

	public float MinMoveDistance
	{
		get
		{
			return m_MinMoveDistance;
		}

		set
		{
			m_MinMoveDistance = value;
		}
	}

	public GameObject Target
	{
		get
		{
			return m_Target;
		}

		set
		{
			m_Target = value;
		}
	}

	public PlayerController PlayerController
	{
		get
		{
			return m_PlayerController;
		}

		set
		{
			m_PlayerController = value;
		}
	}
	public CharacterInput CharacterInput
	{
		get
		{
			return m_CharInput;
		}
		set
		{
			m_CharInput = value;
		}
	}

	public float DistanceToClosestTarget
	{
		get
		{
			return m_DistanceToClosestTarget;
		}

		set
		{
			m_DistanceToClosestTarget = value;
		}
	}

	public float BoostRange
	{
		get
		{
			return m_BoostRange;
		}

		set
		{
			m_BoostRange = value;
		}
	}

	public PowerUpSpawner PowerUpTarget
	{
		get
		{
			return m_PowerUpTarget;
		}

		set
		{
			m_PowerUpTarget = value;
		}
	}

	public bool PowerUpDestinationSet
	{
		get
		{
			return m_PowerUpDestinationSet;
		}

		set
		{
			m_PowerUpDestinationSet = value;
		}
	}
	#endregion

	// Use this for initialization
	private void Start()
	{
		m_StateMachine = new StateMachine<AI>( this );
		m_StateMachine.ChangeState( IdleState.Instance );
		m_Navigator = GetComponent<NavMeshAgent>();

		m_MatchController = MatchController.Instance;
		m_GameController = GameController.Instance;
		m_PlayerController = GetComponent<PlayerController>();

		m_CharInput = GetComponent<CharacterInput>();
		m_CharMovement = GetComponent<CharacterMovement>();
		m_CharAttack = GetComponent<CharacterAttack>();

		if( m_CharInput.CharacterAttack == null )
		{
			Debug.Log( "Character input's CharAttack is not set up!" );
			m_CharInput.CharacterAttack = m_CharAttack;
		}

		if( m_CharInput.CharacterMovement == null )
		{
			Debug.Log( "Character input's CharMovement is not set up!" );
			m_CharInput.CharacterMovement = m_CharMovement;
		}


		m_Navigator.angularSpeed = 180;
		m_Navigator.speed = m_PlayerController.MaxVelocity / 1.5f;
		m_Navigator.acceleration = 100f;
	}

	// Update is called once per frame
	private void FixedUpdate()
	{
		//if( m_PowerUpLocations == null )
		//InitPowerUpList();

		if( MatchController.Instance.InProgress )
		{
			m_StateMachine.Update();
			m_CharMovement.UpdateActiveObject();
			m_CharMovement.UpdateAnimator( PlayerController.Animator, PlayerController.GetComponentInParent<Rigidbody>().velocity );

			if( m_PlayerController.ShouldDetach || !m_CharMovement.Grounded || m_CharInput.IsInMobility )
			{
				m_Navigator.enabled = false;
			}
			else if( !m_PlayerController.ShouldDetach && m_CharMovement.Grounded && !m_CharInput.IsInMobility )
			{
				m_Navigator.enabled = true;
			}

			//Debug.Log( "Grounded " + m_CharMovement.Grounded );

			if( m_PlayerTarget != null )
			{
				m_DistanceToClosestTarget = Vector3.Distance( m_PlayerController.transform.position, m_PlayerTarget.transform.position );
			}

			if( m_CharAttack == null )
			{
				Debug.Log( "Character Attack is not set inside AI > Start" );
			}
		}
	}

	public PlayerController ClosestTarget( List<PlayerController> lPlayers )
	{
		PlayerController lMinDistancePlayer = null;

		//Look through list of players and select a target based on their distance.
		float lDistance = Mathf.Infinity;
		for( int i = 0; i < lPlayers.Count; i++ )
		{
			if( lPlayers[i] != m_PlayerController && !lPlayers[i].Dead )
			{
				if( Vector3.Distance( transform.position, lPlayers[i].transform.position ) < lDistance )
				{
					lMinDistancePlayer = lPlayers[i];
					lDistance = Vector3.Distance( transform.position, lPlayers[i].transform.position );
				}
			}
		}

		return lMinDistancePlayer;
	}

	public void RandomTarget()
	{
		List<PlayerController> lPlayers = MatchController.Instance.CurrentPlayers;
		PlayerTarget = lPlayers[UnityEngine.Random.Range( 0, lPlayers.Count )];

		if( PlayerTarget == m_PlayerController )
		{
			PlayerTarget = lPlayers[m_PlayerController.PlayerID + 1 % lPlayers.Count];
		}
	}

	public void SetClosestTarget()
	{
		m_PlayerTarget = ClosestTarget( m_MatchController.CurrentPlayers );
	}

	public bool IsOnNavMesh()
	{
		NavMeshHit lHit;
		if( NavMesh.SamplePosition( transform.position, out lHit, m_OnMeshThreshold, NavMesh.AllAreas ) )
		{
			if( Mathf.Approximately( transform.position.x, lHit.position.x ) && Mathf.Approximately( transform.position.z, lHit.position.z ) )
			{
				return transform.position.y >= lHit.position.y;
			}
		}

		return false;
	}

	public void PursueTarget()
	{
		m_Navigator.SetDestination( m_PlayerTarget.transform.position );
		Debug.Log( "Problems with agent " + PlayerController.PlayerID );
	}

	public IEnumerator AttackCoroutine( eAttackType lAttackType )
	{
		yield return new WaitForSeconds( 0.0f );
		m_CharInput.AIAttack( lAttackType );
	}

	public void Attack( eAttackType lAttackType )
	{
		m_CharInput.AIAttack( lAttackType );
	}

	public Vector3 FleeDirection()
	{
		return ( transform.position - m_PlayerTarget.transform.position );
	}

	public Vector3 FleeDestination()
	{
		NavMeshHit newHit;
		NavMesh.SamplePosition( FleeDirection(), out newHit, Mathf.Infinity, NavMesh.AllAreas );

		return newHit.position;
	}

	//List of powerup locations
	public void InitPowerUpList()
	{
		m_PowerUpLocations = new List<PowerUpSpawner>( FindObjectsOfType<PowerUpSpawner>().ToList() );
	}

	//Check for powerups
	public void SetClosestPowerUp()
	{
		PowerUpSpawner lClosestPowerUp = null;
		float lDistance = Mathf.Infinity;
		for( int i = 0; i < m_PowerUpLocations.Count; i++ )
		{
			if( m_PowerUpLocations[i].PowerUp.Active )
			{
				if( Vector3.Distance( transform.position, m_PowerUpLocations[i].transform.position ) < lDistance )
				{
					lClosestPowerUp = m_PowerUpLocations[i];
					lDistance = Vector3.Distance( transform.position, m_PowerUpLocations[i].transform.position );
				}
			}
		}

		m_PowerUpTarget = lClosestPowerUp;
	}

	public void SetPowerUpTarget()
	{
		Invoke( "SetClosestPowerUp", 5f );
	}

	public bool PowerUpsAvailable()
	{
		Debug.Log( m_PowerUpLocations.Count );
		for( int i = 0; i < m_PowerUpLocations.Count; i++ )
		{
			if( m_PowerUpLocations[i].PowerUp.Active )
			{
				return true;
			}
		}
		return false;
	}
}
