using UnityEngine;

/// <summary>
/// A scriptable object that contains input data to be able to access controller axes on request
/// </summary>
/// 
/// Daniel Beard
/// 
[CreateAssetMenu(fileName = "InputData.asset", menuName = "Onyx/Create InputData Object", order = 0)]
public class InputData : ScriptableObject
{
    //Inputs
    [SerializeField]
    private string m_ControllerSuffix = "_";

    [SerializeField]
    private string m_MoveXAxis = "L_XAxis";

    [SerializeField]
    private string m_MoveYAxis = "L_YAxis";

    //[SerializeField]
    //private string m_JumpAxis = "A_";

    [SerializeField]
    private string m_DodgeAxis = "B_";

    [SerializeField]
    private string m_QuickAttackAxis = "X_";

    [SerializeField]
    private string m_HeavyAttackAxis = "Y_";

    [SerializeField]
    private string m_RangedAttackAxis = "A_";

    [SerializeField]
    private string m_BlockAxis = "";

    [SerializeField]
    private string m_PilotBombAxis = "";

    //Cooldowns
    [SerializeField]
    private float m_QuickCooldown = 0f;

    [SerializeField]
    private float m_HeavyCooldown = 0f;

    [SerializeField]
    private float m_MechRangedCooldown = 0f;

    [SerializeField]
    private float m_PilotRangedCooldown = 0f;

    [SerializeField]
    private float m_DodgeCooldown = 0f;

    [SerializeField]
    private float m_RocketBoostCooldown = 0f;

    //Delays
    [SerializeField] private float m_QuickDelay;
    [SerializeField] private float m_HeavyDelay;
    [SerializeField] private float m_MechRangedDelay;
    [SerializeField] private float m_PilotRangedDelay;
    [SerializeField] private float m_PilotBombCooldown;
    [SerializeField] private float m_DodgeDelay;
    [SerializeField] private float m_RocketDelay;
    [SerializeField] private float m_RocketBoostTime;

    public string ControllerSuffix { get { return m_ControllerSuffix; } }
    public string MoveXAxis { get { return m_MoveXAxis; } }
    public string MoveYAxis { get { return m_MoveYAxis; } }
    //public string JumpAxis { get { return m_JumpAxis; } }
    public string MobilityAxis { get { return m_DodgeAxis; } }
    public string QuickAttackAxis { get { return m_QuickAttackAxis; } }
    public string HeavyAttackAxis { get { return m_HeavyAttackAxis; } }
    public string RangedAttackAxis { get { return m_RangedAttackAxis; } }
    public string PilotBombAxis { get { return m_PilotBombAxis; } }
    public string BlockAxis { get { return m_BlockAxis; } }
    public float QuickCooldown { get { return m_QuickCooldown; } }
    public float HeavyCooldown { get { return m_HeavyCooldown; } }
    public float MechRangedCooldown { get { return m_MechRangedCooldown; } }
    public float PilotRangedCooldown { get { return m_PilotRangedCooldown; } }
    public float DodgeCooldown { get { return m_DodgeCooldown; } }
    public float RocketBoostCooldown { get { return m_RocketBoostCooldown; } }
    public float QuickDelay { get { return m_QuickDelay; } }
    public float HeavyDelay { get { return m_HeavyDelay; } }
    public float MechRangedDelay { get { return m_MechRangedDelay; } }
    public float PilotRangedDelay { get { return m_PilotRangedDelay; } }
    public float PilotBombCooldown { get { return m_PilotBombCooldown; } }
    public float DodgeDelay { get { return m_DodgeDelay; } }
    public float RocketDelay { get { return m_RocketDelay; } }
    public float RocketBoostTime { get { return m_RocketBoostTime; } }
}
