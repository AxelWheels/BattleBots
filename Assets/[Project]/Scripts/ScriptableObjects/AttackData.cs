using UnityEngine;

public enum AttackType
{
    QuickMelee,
    HeavyMelee,
    Ranged,
    RocketBoost,
    BombPlot,
    Empty
}

[CreateAssetMenu(fileName = "AttackData.asset", menuName = "Onyx/Create AttackData Object", order = 0)]
public class AttackData : ScriptableObject
{
    [SerializeField]
    private AttackType attackType = AttackType.Empty;

    [SerializeField] private float offsetZ = 0.0f;
    [SerializeField] private float offsetY = 0.0f;

    [SerializeField] private int damage = 0;
    [SerializeField] private float knockback = 1.0f;
    [SerializeField] private float hitStun = 0.5f;
    [SerializeField] private float startUpTime = 0.0f;
    [SerializeField] private float activeTime = 1.0f;
    [SerializeField] private float recoveryTime = 0.0f;

    [SerializeField] private int projectileSpeed = 0;
    [SerializeField] private float hitRadius = 0f;

    public AttackType AttackType { get { return attackType; } }

    public int Damage { get { return damage; } }
    public float Knockback { get { return knockback; } }
    public float HitStun { get { return hitStun; } }
    public float StartUpTime { get { return startUpTime; } }
    public float ActiveTime { get { return activeTime; } } //Time it lasts until being destroyed
    public float RecoveryTime { get { return recoveryTime; } }

    public float OffsetZ { get { return offsetZ; } }
    public float OffsetY { get { return offsetY; } }
    public int ProjectileSpeed { get { return projectileSpeed; } }
    public float HitRadius { get { return hitRadius; } }

}