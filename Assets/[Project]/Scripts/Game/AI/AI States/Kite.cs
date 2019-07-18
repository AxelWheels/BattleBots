/// <summary>
/// AI state that handles AI behaviour when engaging would not be favourable.
/// </summary>

public class KitingState : State<AI>
{
    private static KitingState m_Instance;

    private KitingState()
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

    public static KitingState Instance
    {
        get
        {
            if (m_Instance == null)
            {
                new KitingState();
            }

            return m_Instance;
        }
    }
    public override void EnterState(AI lOwner)
    {
        lOwner.PlayerTarget = null;
    }

    public override void ExitState(AI lOwner)
    {
        lOwner.PowerUpTarget = null;
    }

    public override void UpdateState(AI lOwner)
    {
        if (lOwner.PowerUpTarget == null)
        {
            lOwner.SetClosestPowerUp();
        }

        if (lOwner.DistanceToClosestTarget < lOwner.MeleeRange / 2)
        {
            lOwner.StateMachine.ChangeState(CombatState.Instance);
        }

        if (lOwner.PowerUpTarget != null && lOwner.PowerUpTarget.PowerUp.Active)
        {
            if (!lOwner.PowerUpDestinationSet)
            {
                if (lOwner.Navigator.enabled && !lOwner.PlayerController.Dead && lOwner.IsOnNavMesh())
                {
                    lOwner.Navigator.SetDestination(lOwner.PowerUpTarget.transform.position);
                }
            }
        }
        else
        {
            lOwner.StateMachine.ChangeState(IdleState.Instance);
        }
    }
}
