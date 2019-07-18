/// <summary>
/// AI state in which the agent selects a target and begins closing distance.
/// </summary>
public class IdleState : State<AI>
{
    private static IdleState m_Instance;

    private IdleState()
    {
        if (m_Instance != null)
        {
            return;
        }
        else
        {
            m_Instance = this;
        }
    }

    public static IdleState Instance
    {
        get
        {
            if (m_Instance == null)
            {
                new IdleState();
            }

            return m_Instance;
        }
    }

    public override void EnterState(AI lOwner)
    {
        //Select a target.
        if (MatchController.Instance.InProgress)
        {
            lOwner.SetClosestTarget();
        }
    }

    public override void ExitState(AI lOwner)
    {
        //PlayerTarget = null;
    }

    public override void UpdateState(AI lOwner)
    {
        if (lOwner.PlayerTarget == null)
        {
            lOwner.SetClosestTarget();
        }

        if (lOwner.DistanceToClosestTarget <= lOwner.MeleeRange)
        {
            lOwner.StateMachine.ChangeState(CombatState.Instance);
        }

        /*
		if( lOwner.PowerUpsAvailable() )
		{
			Debug.Log( "PowerUps? " + lOwner.PowerUpsAvailable() );
			lOwner.StateMachine.ChangeState( KitingState.Instance );
		}
		else
		{
			Debug.Log( "PowerUps? " + lOwner.PowerUpsAvailable() );
		}*/

        lOwner.Invoke("SetClosestTarget", 1f);

        //Begin navigation to closest target.
        if (MatchController.Instance.InProgress && lOwner.PlayerTarget != null && lOwner.Navigator.enabled && lOwner.IsOnNavMesh() && !lOwner.PlayerTarget.Dead)
        {
            lOwner.Navigator.SetDestination(lOwner.PlayerTarget.transform.position);
        }
        else
        {
            //Debug.Log( "Is agent " + lOwner.PlayerController.PlayerID + " on mesh?" + lOwner.IsOnNavMesh() );
            //Debug.Log( "Should Detach " + lOwner.PlayerController.ShouldDetach );
            //Debug.Log( "NavAgent enabled " + lOwner.Navigator.enabled );
        }

    }
}
