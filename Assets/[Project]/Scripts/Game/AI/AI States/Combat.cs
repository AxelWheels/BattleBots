/// <summary>
/// AI state that controls agent Combat.
/// </summary> 

public class CombatState : State<AI>
{
    private static CombatState m_Instance;

    private CombatState()
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

    public static CombatState Instance
    {
        get
        {
            if (m_Instance == null)
            {
                new CombatState();
            }

            return m_Instance;
        }
    }

    public override void EnterState(AI lOwner)
    {
        if (lOwner.PlayerTarget == null)
        {
            lOwner.SetClosestTarget();
        }
    }

    public override void ExitState(AI lOwner)
    {
        //lOwner.Target = null;
    }

    public override void UpdateState(AI lOwner)
    {
        if (!lOwner.PlayerController.IsMech)
        {
            lOwner.StateMachine.ChangeState(RetreatState.Instance);
        }

        if (lOwner.PlayerTarget != null && lOwner.Navigator.enabled && !lOwner.PlayerController.Dead && lOwner.IsOnNavMesh())
        {
            lOwner.Navigator.SetDestination(lOwner.PlayerTarget.transform.position);
        }
        else
        {
            lOwner.SetClosestTarget();
        }

        if (lOwner.DistanceToClosestTarget <= lOwner.ProjectileRange)
        {
            if (!lOwner.CharacterInput.CooldownActive(eAttackType.Ranged))
            {
                lOwner.Attack(eAttackType.Ranged);
            }
        }

        if (lOwner.DistanceToClosestTarget <= lOwner.BoostRange)
        {
            if (lOwner.CharacterInput.MobilityCooldown <= 0f)
            {
                lOwner.CharacterInput.Mobility(lOwner.CharacterInput.InData.RocketBoostCooldown);
            }
        }

        if (lOwner.DistanceToClosestTarget <= lOwner.MeleeRange)
        {
            if (lOwner.PlayerTarget != null && lOwner.Navigator.enabled && !lOwner.PlayerController.Dead && lOwner.IsOnNavMesh())
            {
                lOwner.Navigator.SetDestination(lOwner.PlayerTarget.transform.position);
            }

            if (!lOwner.PlayerController.CharacterInput.CooldownActive(eAttackType.QuickMelee))
            {
                lOwner.Attack(eAttackType.QuickMelee);
            }

            if (lOwner.PlayerTarget == null)
            {
                lOwner.SetClosestTarget();
            }
        }
        else
        {
            lOwner.SetClosestTarget();
        }

        if (lOwner.DistanceToClosestTarget > lOwner.BoostRange)
        {
            lOwner.StateMachine.ChangeState(IdleState.Instance);
        }
    }
}
