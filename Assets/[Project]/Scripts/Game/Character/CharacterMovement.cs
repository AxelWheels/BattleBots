using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class CharacterMovement : MonoBehaviour
{
	[SerializeField] private float m_TurnSpeed = 360f;
	[SerializeField] private float m_RollPower = 12f;
	[SerializeField] private float m_RocketPower = 10f;
	[SerializeField] private float m_GroundCheckDistance;

	[SerializeField, Range( 1f, 100f )]
	private float m_MoveSpeedMultiplier = 1f;

	[SerializeField, Range( 1f, 5f )]
	private float m_AnimSpeedMultiplier = 1f;

	private PlayerController m_PlayerController;
	private Rigidbody m_Rigidbody;
	private Animator m_Animator;
	private CapsuleCollider m_Capsule;
	private Vector3 m_GroundNormal;
	private Vector3 m_DeltaPosition;
	private Vector3 m_LastPosition = Vector3.zero;

	private float m_OrigGroundCheckDistance;
	private float m_CapsuleHeight;
	private bool m_Boosting;

	#region Properties

	public PlayerController Controller { get; set; }

	public bool Grounded { get { return Physics.Raycast( transform.position + Vector3.up * m_CapsuleHeight, Vector3.down, m_CapsuleHeight + m_GroundCheckDistance ); } }

	public float TurnSpeed { get { return m_TurnSpeed; } }
	public float RollPower { get { return m_RollPower; } }
	public float RocketPower { get { return m_RocketPower; } }
	public float MoveSpeedMultiplier { get { return m_MoveSpeedMultiplier; } set { m_MoveSpeedMultiplier = value; } }
	public float AnimSpeedMultiplier { get { return m_AnimSpeedMultiplier; } }
	public float GroundCheckDistance { get { return m_GroundCheckDistance; } }
	public bool Boosting { get { return m_Boosting; } }
	#endregion

	private void Start()
	{
		m_PlayerController = GetComponent<PlayerController>();
		m_Rigidbody = GetComponent<Rigidbody>();
		m_CapsuleHeight = m_Capsule.bounds.extents.y * 0.5f;
	}

	public void UpdateAnimator( Animator lAnimator, Vector3 lMove )
	{
		lAnimator.SetFloat( "Forward", lMove.magnitude );
		lAnimator.SetFloat( "Turn", 0 );
	}

	public void Move( Vector3 lDirection )
	{
		if( lDirection.magnitude > 0 )
		{
			Quaternion lDirectionRotation = Quaternion.LookRotation( lDirection, Vector3.up );

			Vector3 lRelativeDirection = lDirectionRotation * ( lDirection.magnitude * transform.forward * m_MoveSpeedMultiplier );

			m_Rigidbody.MovePosition( m_Rigidbody.position + lRelativeDirection * Time.fixedDeltaTime );

			//Set the currently active mech/pilot to the same rotation as the PlayerController object
			Controller.ActiveObject.transform.rotation = Quaternion.Slerp( Controller.ActiveObject.transform.rotation, lDirectionRotation, Time.fixedDeltaTime * m_TurnSpeed );

			UpdateActiveObject();
		}

		DampenRigidbodyVelocity();
	}

	public void UpdateActiveObject()
	{
		UpdateAnimator( Controller.Animator, m_Rigidbody.velocity );
		if( Controller.transform.localRotation != Quaternion.identity )
		{
			Controller.ActiveObject.transform.localRotation = Quaternion.identity;
		}
	}

	private void DampenRigidbodyVelocity()
	{
		if( m_Rigidbody.velocity.magnitude > Controller.MaxVelocity )
		{
			Vector3 lAllowedVelocity = Vector3.ClampMagnitude( m_Rigidbody.velocity, Controller.MaxVelocity );

			Vector3 lDampenedVelocity = m_Rigidbody.velocity - lAllowedVelocity;

			lDampenedVelocity *= Controller.VelocityDampening;

			m_Rigidbody.velocity = lAllowedVelocity + lDampenedVelocity;
		}
	}

	public void DodgeRoll()
	{
		if( Grounded )
		{
			m_Rigidbody.AddForce( Controller.ActiveObject.transform.forward * RollPower, ForceMode.Impulse );
			StartCoroutine( Invincible( Controller.InvincibilityData.DodgeTime ) );
		}
	}

	public void RocketBoost( float lTime )
	{
		StartCoroutine( BoostRoutine( lTime ) );
	}

	private IEnumerator BoostRoutine( float lTime )
	{
		if( Controller.BoostEffect != null )
		{
			Controller.BoostEffect.SetActive( true );
		}

		Controller.CanInput = false;
		m_Rigidbody.AddForce( ( Controller.ActiveObject.transform.forward * RocketPower ) + ( Grounded ? Vector3.zero : ( Controller.ActiveObject.transform.up * RocketPower ) ), ForceMode.VelocityChange );
		yield return new WaitForSeconds( lTime );
		Controller.CanInput = true;
		m_Animator.SetTrigger( "Landing" );

		yield return new WaitForSeconds( lTime );

		if( Controller.BoostEffect != null )
		{
			Controller.BoostEffect.SetActive( false );
		}
	}

	//public void Jump( float lJumpPower )
	//{
	//	if( Grounded )
	//	{
	//		m_Rigidbody.AddForce( Vector3.up * lJumpPower, ForceMode.Impulse );
	//	}
	//}

	public IEnumerator Invincible( float lSeconds )
	{
		Controller.IsInvincible = true;
		yield return new WaitForSeconds( lSeconds );
		Controller.IsInvincible = false;
	}

	public IEnumerator HitStun( float lSeconds )
	{
		Controller.IsHitStun = true;

		if( Controller.IsMech )
		{
			Transform lTransform = Controller.ActiveObject.GetComponent<CharacterAttackJoint>().MeleeAttackObjectRoot;

			for( int i = 0; i < lTransform.childCount; i++ )
			{
				Destroy( lTransform.GetChild( i ).gameObject );
			}
		}

		yield return new WaitForSeconds( lSeconds );
		Controller.IsHitStun = false;
	}

	public void UpdateData( CharacterData lData, GameObject lActiveObject )
	{
		m_TurnSpeed = lData.TurnSpeed;
		m_RollPower = lData.MobilityPower;
		m_MoveSpeedMultiplier = lData.MoveSpeed;

		m_Animator = lActiveObject.GetComponentInChildren<Animator>();
		m_Capsule = lActiveObject.GetComponent<CapsuleCollider>();

		m_OrigGroundCheckDistance = lData.GroundCheckDistance;
	}

	private void OnDrawGizmos()
	{
		Gizmos.DrawRay( transform.position + Vector3.up * m_CapsuleHeight, Vector3.down * ( m_CapsuleHeight + m_GroundCheckDistance ) );
	}

	public IEnumerator ChangeMoveSpeedTemporarily( float lValue, float lSeconds )
	{
		m_MoveSpeedMultiplier += lValue;
		yield return new WaitForSeconds( lSeconds );
		m_MoveSpeedMultiplier -= lValue;
	}
}
