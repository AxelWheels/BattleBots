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
    [SerializeField] private string controllerSuffix = "_";

    [SerializeField] private string moveXAxis = "L_XAxis";

    [SerializeField] private string moveYAxis = "L_YAxis";

    [SerializeField] private string dodgeAxis = "B_";

    [SerializeField] private string quickAttackAxis = "X_";

    [SerializeField] private string heavyAttackAxis = "Y_";

    [SerializeField] private string rangedAttackAxis = "A_";

    [SerializeField] private string blockAxis = "";

    [SerializeField] private string pilotBombAxis = "";

    //Cooldowns
    [SerializeField] private float quickCooldown = 0f;

    [SerializeField] private float heavyCooldown = 0f;

    [SerializeField] private float mechRangedCooldown = 0f;

    [SerializeField] private float pilotRangedCooldown = 0f;

    [SerializeField] private float dodgeCooldown = 0f;

    [SerializeField] private float rocketBoostCooldown = 0f;

    //Delays
    [SerializeField] private float quickDelay = 0.0f;
    [SerializeField] private float heavyDelay = 0.0f;
    [SerializeField] private float mechRangedDelay = 0.0f;
    [SerializeField] private float pilotRangedDelay = 0.0f;
    [SerializeField] private float pilotBombCooldown = 0.0f;
    [SerializeField] private float dodgeDelay = 0.0f;
    [SerializeField] private float rocketDelay = 0.0f;
    [SerializeField] private float rocketBoostTime = 0.0f;

    public string ControllerSuffix { get { return controllerSuffix; } }
    public string MoveXAxis { get { return moveXAxis; } }
    public string MoveYAxis { get { return moveYAxis; } }
    public string MobilityAxis { get { return dodgeAxis; } }
    public string QuickAttackAxis { get { return quickAttackAxis; } }
    public string HeavyAttackAxis { get { return heavyAttackAxis; } }
    public string RangedAttackAxis { get { return rangedAttackAxis; } }
    public string PilotBombAxis { get { return pilotBombAxis; } }
    public string BlockAxis { get { return blockAxis; } }
    public float QuickCooldown { get { return quickCooldown; } }
    public float HeavyCooldown { get { return heavyCooldown; } }
    public float MechRangedCooldown { get { return mechRangedCooldown; } }
    public float PilotRangedCooldown { get { return pilotRangedCooldown; } }
    public float DodgeCooldown { get { return dodgeCooldown; } }
    public float RocketBoostCooldown { get { return rocketBoostCooldown; } }
    public float QuickDelay { get { return quickDelay; } }
    public float HeavyDelay { get { return heavyDelay; } }
    public float MechRangedDelay { get { return mechRangedDelay; } }
    public float PilotRangedDelay { get { return pilotRangedDelay; } }
    public float PilotBombCooldown { get { return pilotBombCooldown; } }
    public float DodgeDelay { get { return dodgeDelay; } }
    public float RocketDelay { get { return rocketDelay; } }
    public float RocketBoostTime { get { return rocketBoostTime; } }
}
