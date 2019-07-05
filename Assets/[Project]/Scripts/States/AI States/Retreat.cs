using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RetreatState : State<AI>
{
	private static RetreatState m_Instance;

	private RetreatState()
	{
		if( m_Instance != null )
		{
			return;
		}
		else
		{
			m_Instance = this;
		}
	}

	public static RetreatState Instance
	{
		get
		{
			if( m_Instance == null )
			{
				new RetreatState();
			}

			return m_Instance;
		}
	}

	public override void EnterState( AI lOwner )
	{
		lOwner.SetClosestTarget();
	}

	public override void ExitState( AI lOwner )
	{
		//Nothing here yet.
	}

	public override void UpdateState( AI lOwner )
	{
		//Assuming player is pilot.
		if( lOwner.PlayerController.IsMech )
		{
			lOwner.StateMachine.ChangeState( IdleState.Instance );
		}

		lOwner.Invoke( "SetClosestTarget", 1f );

		if( lOwner.PlayerTarget != null && lOwner.Navigator.enabled && !lOwner.PlayerController.Dead && lOwner.IsOnNavMesh() )
		{
			lOwner.Navigator.SetDestination( lOwner.FleeDestination() );
		}

		if( lOwner.DistanceToClosestTarget <= 2 * lOwner.MeleeRange )
		{
			if( lOwner.CharacterInput.MobilityCooldown <= 0f )
			{
				lOwner.CharacterInput.Mobility( lOwner.CharacterInput.InData.DodgeCooldown );
			}
		}
	}
}
