using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackObject : MonoBehaviour
{
	[SerializeField]
	private AttackData m_AttackData;
	[SerializeField]
	private GameObject m_HitEffect;
	[SerializeField]
	private GameObject m_FireEffect;
	[SerializeField]
	private SoundData m_SoundData;

	[SerializeField]
	private string m_AttackSound;

	[SerializeField]
	private AudioSource m_AudioSource;

	[SerializeField]
	private AudioClip m_AttackClip;
	[SerializeField]
	private AudioClip m_HitClip;


	private Collider m_OwnerCollider;
	private float m_TimeTillStart;
	private float m_ActiveTime;

	public float TimeTillStart { get { return m_TimeTillStart; } set { m_TimeTillStart = value; } }
	public AttackData AttackData { get { return m_AttackData; } }
	public Collider OwnerCollider { get { return m_OwnerCollider; } set { m_OwnerCollider = value; } }

	private void Start()
	{
		m_ActiveTime = m_AttackData.ActiveTime;
		m_TimeTillStart = m_AttackData.StartUpTime;

		if( m_TimeTillStart > 0 )
		{
			GetComponent<Collider>().enabled = false;
		}

		if( m_AttackData.ProjectileSpeed > 0 )
		{
			//GetComponent<Rigidbody>().velocity = transform.forward * m_AttackData.ProjectileSpeed * Time.fixedDeltaTime;
			GetComponent<Rigidbody>().velocity.Set( 0f, 0f, 0f );
			GetComponent<Collider>().enabled = false;
			transform.GetChild( 0 ).gameObject.SetActive( false );

			Invoke( "RangedStartTime", m_AttackData.StartUpTime );
		}
	}

	private void Update()
	{
		if( m_TimeTillStart <= 0 )
		{
			GetComponent<Collider>().enabled = true;
		}

		if( m_ActiveTime <= 0 )
		{
            if (true)//m_AreaOfEffect != null )
			{
				GetComponent<SphereCollider>().radius = 5f;
				Destroy( gameObject );
			}
			else
			{
				Destroy( gameObject );
			}
		}

		m_ActiveTime = Mathf.Max( 0f, m_ActiveTime - Time.deltaTime );
		m_TimeTillStart = Mathf.Max( 0f, m_TimeTillStart - Time.deltaTime );

	}

	private void OnTriggerEnter( Collider lObject )
	{
		if( lObject == m_OwnerCollider || lObject.tag == "Trap" )
		{
			//Debug.Log( "Hit self, return" );
			return;
		}

		PlayerController lPlayerController = lObject.GetComponentInParent<PlayerController>();
		PlayerController lOwnerController = m_OwnerCollider.GetComponentInParent<PlayerController>();

		if( lObject.tag == "Player" )
		{

			if( !lPlayerController.IsInvincible )
			{
				if( lPlayerController != null )
				{
					int lDamage = 0;

					if( lPlayerController.IsBlocking )
					{
						if( lPlayerController.DamageReduction > 0 )
						{
							lDamage = Mathf.RoundToInt( -m_AttackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.DamageReduction * lPlayerController.BlockReduction );
							lPlayerController.ChangeHealth( m_OwnerCollider, lDamage );
						}
						else
						{
							lDamage = Mathf.RoundToInt( -m_AttackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.BlockReduction );
							lPlayerController.ChangeHealth( m_OwnerCollider, lDamage );
						}
					}
					else
					{
						if( lPlayerController.DamageReduction > 0 )
						{
							lDamage = Mathf.RoundToInt( -m_AttackData.Damage * lOwnerController.DamageMultiplier * lPlayerController.DamageReduction );
							lPlayerController.ChangeHealth( m_OwnerCollider, lDamage );
						}
						else
						{
							lDamage = Mathf.RoundToInt( -m_AttackData.Damage * lOwnerController.DamageMultiplier );
							lPlayerController.ChangeHealth( m_OwnerCollider, lDamage );
						}
					}

					m_OwnerCollider.GetComponentInParent<PlayerController>().PlayerStats.AddDamageDealt( Mathf.Abs( lDamage ) );

					if( m_AttackData.HitStun > 0 && !lPlayerController.IsBlocking )
					{
						lPlayerController.MakeHitStun( m_AttackData.HitStun );
					}
				}

				Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();

				if( lRigidbody != null )
				{
					if( m_AttackData.AttackType == eAttackType.BombPlot || m_AttackData.AttackType == eAttackType.Ranged )
					{
						lRigidbody.AddForce( ( lObject.transform.position - gameObject.transform.position ).normalized * m_AttackData.Knockback + Vector3.up, ForceMode.Impulse );
					}
					else
					{
						lRigidbody.AddForce( ( lObject.transform.position - m_OwnerCollider.transform.position ).normalized * m_AttackData.Knockback + Vector3.up, ForceMode.Impulse );
					}
				}

				//Play Effects and Sound
				if( m_HitEffect != null )
				{
					//EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
				}

				PlayHitSound();

				if( m_AttackData.ProjectileSpeed > 0 )
				{
					//CameraShake.Instance.Shake( 0.1f, 10.0f, 0.5f );
				}
				else
				{
					//CameraShake.Instance.Shake( 0.01f, 10.0f, 0.5f );
				}

				Vector3 lAttackDirection = m_OwnerCollider.transform.position - lPlayerController.transform.position;

				//Avoids the player tilting at weird angles
				Vector3 lPlanedDirection = new Vector3( lAttackDirection.x, 0, lAttackDirection.z );

				lPlayerController.ActiveObject.transform.rotation = Quaternion.LookRotation( lPlanedDirection, Vector3.up );
			}

			if( AttackData.AttackType == eAttackType.Ranged )
			{
				if( AttackData.HitRadius > 0f )
				{
					Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();
					GetComponent<SphereCollider>().radius = AttackData.HitRadius;
					//Debug.Log( "B-A: " + ( lObject.transform.position - gameObject.transform.position ).normalized );
					Vector3 lForce = lObject.transform.position - gameObject.transform.position;
					lForce.y = 0;
					//Debug.Log( "zero y: " + lForce );
					lRigidbody.AddForce( ( lForce ).normalized * m_AttackData.Knockback + Vector3.up, ForceMode.Impulse );
				}
				Destroy( gameObject );

			}
			else
			{
				Destroy( gameObject );
			}
		}

		else
		{
			if( AttackData.AttackType == eAttackType.Ranged )
			{
				if( AttackData.HitRadius > 0f )
				{
					if( lPlayerController != null )
					{
						Rigidbody lRigidbody = lPlayerController.GetComponent<Rigidbody>();
						GetComponent<SphereCollider>().radius = AttackData.HitRadius;
						//Debug.Log( "B-A: " + ( lObject.transform.position - gameObject.transform.position ).normalized );
						Vector3 lForce = lObject.transform.position - gameObject.transform.position;
						lForce.y = 0;
						//Debug.Log( "zero y: " + lForce );
						lRigidbody.AddForce( ( lForce ).normalized * m_AttackData.Knockback + Vector3.up, ForceMode.Impulse );
					}
				}
				Destroy( gameObject );
			}

			if( m_HitEffect != null && m_AttackData.AttackType != eAttackType.BombPlot )
			{
				//EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
			}
		}
	}

	public void PlayAttackSound()
	{
		m_OwnerCollider.GetComponentInParent<PlayerController>().PlaySound( m_AttackClip );
	}

	public void PlayHitSound()
	{
		m_OwnerCollider.GetComponentInParent<PlayerController>().PlaySound( m_HitClip );
	}

	private void RangedStartTime()
	{
		transform.parent = null;
		transform.position = m_OwnerCollider.GetComponentInParent<PlayerController>().ActiveObject.GetComponent<CharacterAttackJoint>().RangedAttackObjectRoot.position;
		transform.forward = m_OwnerCollider.GetComponentInParent<PlayerController>().ActiveObject.transform.forward;
		GetComponent<Collider>().enabled = true;
		transform.GetChild( 0 ).gameObject.SetActive( true );
		GetComponent<Rigidbody>().velocity = transform.forward * m_AttackData.ProjectileSpeed * Time.fixedDeltaTime;
	}

	public IEnumerator RangedFireCoroutine( Transform lSpawnPosition, Quaternion lRotation, float lDelayTime )
	{
		if( m_FireEffect != null )
		{
			yield return new WaitForSeconds( lDelayTime );
			//EffectsController.Instance.PlayEffectAtPosition( m_FireEffect, lSpawnPosition.position, lRotation );
		}
	}

	private void OnDrawGizmos()
	{
		//Gizmos.DrawSphere( transform.position, 0.5f );
	}

	public void DestroyAndExplode()
	{
		PlayHitSound();
		//EffectsController.Instance.PlayEffectAtPosition( m_HitEffect.name, transform.position, Quaternion.Euler( Vector3.up ) );
		Destroy( gameObject, 0.1f );
	}
}
