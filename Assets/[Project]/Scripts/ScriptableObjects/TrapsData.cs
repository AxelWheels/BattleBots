using UnityEngine;

public enum TrapType
{
    Blade,
    Fire,
    Hades
}

[CreateAssetMenu(fileName = "TrapData.asset", menuName = "Onyx/Create TrapData Object", order = 0)]
public class TrapsData : ScriptableObject
{
    [SerializeField] private TrapType trapType = TrapType.Blade;
    [SerializeField] private int damage = 0;
    [SerializeField] private float armedTime = 0f; //How fast does the trap reset/reload ; 1 second load time.
    [SerializeField] private float disarmedTime = 0f;
    [SerializeField] private float hitStunTime = 0f;

    #region Properties
    public TrapType GetTrapTypes { get { return trapType; } }
    public int Damage { get { return damage; } }
    public float ArmedTime { get { return armedTime; } }
    public float DisarmedTime { get { return disarmedTime; } }
    public float HitStunTime { get { return hitStunTime; } }
    #endregion
}