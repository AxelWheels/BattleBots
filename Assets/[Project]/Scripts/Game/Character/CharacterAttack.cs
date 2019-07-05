using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterAttack : MonoBehaviour
{
	[SerializeField]
	private List<AttackObject> m_PilotAttacks;

	[SerializeField]
	private List<AttackObject> m_MechAttacks;

	private Transform m_Joint;

	public PlayerController Controller { get; set; }
	public Transform Joint { get { return m_Joint; } set { m_Joint = value; } }

	public void Attack( eAttackType lAttackType )
	{
		if( Controller.IsMech )
		{
			for( int i = 0; i < m_MechAttacks.Count; i++ )
			{
				eAttackType lMechAttackType = m_MechAttacks[i].AttackData.AttackType;

				if( lMechAttackType == lAttackType )
				{
					SpawnAttackObject( m_MechAttacks[i].gameObject, m_MechAttacks[i].AttackData, Controller.IsMech, lMechAttackType == eAttackType.Ranged );
					Controller.CharacterInput.RecoveryTime += m_MechAttacks[i].AttackData.RecoveryTime;
				}
			}
		}
		else if( !Controller.IsMech )
		{
			for( int i = 0; i < m_PilotAttacks.Count; i++ )
			{
				eAttackType lPilotAttackType = m_PilotAttacks[i].AttackData.AttackType;

				if( lPilotAttackType == lAttackType )
				{
					SpawnAttackObject( m_PilotAttacks[i].gameObject, m_PilotAttacks[i].AttackData, Controller.IsMech, lPilotAttackType == eAttackType.Ranged );
					Controller.CharacterInput.RecoveryTime += m_PilotAttacks[i].AttackData.RecoveryTime;
				}
			}
		}
		else
		{
			Debug.Assert( false, "[CharacterAttack] Something has gone wrong here. The player is neither in the mech or outside of the mech. " + gameObject );
		}
	}
	private void SpawnAttackObject( GameObject lObject, AttackData lAttackData, bool lIsMech, bool lRanged )
	{
		Vector3 lNewOffset = Controller.ActiveObject.transform.forward * lAttackData.OffsetZ + Vector3.up * lAttackData.OffsetY;

		GameObject lAttackObject = Instantiate( lObject, transform.position, Quaternion.identity );

		if( lAttackData.AttackType == eAttackType.BombPlot )
		{
			Controller.CharacterInput.PlantedBomb = lAttackObject;
			lAttackObject.transform.position = Controller.ActiveObject.GetComponent<CharacterAttackJoint>().RangedAttackObjectRoot.position;
		}
		else if( lRanged )
		{
			Controller.CharacterInput.MechMissile = lAttackObject;
			lAttackObject.transform.parent = Controller.ActiveObject.GetComponent<CharacterAttackJoint>().RangedAttackObjectRoot;
			lAttackObject.transform.localPosition = Vector3.zero;
		}
		else if( lAttackData.AttackType == eAttackType.RocketBoost )
		{
			lAttackObject.transform.parent = Controller.ActiveObject.transform;
			lAttackObject.transform.localPosition = Vector3.zero;
			lAttackObject.transform.localRotation = Quaternion.identity;
		}
		else
		{
			lAttackObject.transform.parent = Controller.ActiveObject.GetComponent<CharacterAttackJoint>().MeleeAttackObjectRoot;

			lAttackObject.transform.localPosition = Vector3.zero;
			lAttackObject.transform.localRotation = Quaternion.identity;
		}

		Collider lOwnerCollider = Controller.ActiveObject.GetComponent<Collider>();
		//Debug.Log( lOwnerCollider.name );

		lAttackObject.GetComponent<AttackObject>().OwnerCollider = lOwnerCollider;
		lAttackObject.GetComponent<AttackObject>().PlayAttackSound();
	}
}

