using UnityEngine;

public enum eAttackType
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
    private eAttackType m_AttackType;

    [SerializeField]
    private float m_OffsetZ;
    [SerializeField]
    private float m_OffsetY;

    [SerializeField]
    private int m_Damage = 0;
    [SerializeField]
    private float m_Knockback = 1.0f;
    [SerializeField]
    private float m_HitStun = 0.5f;
    [SerializeField]
    private float m_StartUpTime = 0.0f;
    [SerializeField]
    private float m_ActiveTime = 1.0f;
    [SerializeField]
    private float m_RecoveryTime = 0.0f;

    [SerializeField]
    private int m_ProjectileSpeed = 0;
    [SerializeField]
    private float m_HitRadius = 0f;
    //[SerializeField]
    //private float m_MaxProjectileVelocity = 0f;
    //[SerializeField]
    //private float m_ProjectileHeightCheck = 0f;

    public eAttackType AttackType { get { return m_AttackType; } }

    public int Damage { get { return m_Damage; } }
    public float Knockback { get { return m_Knockback; } }
    public float HitStun { get { return m_HitStun; } }
    public float StartUpTime { get { return m_StartUpTime; } }
    public float ActiveTime { get { return m_ActiveTime; } } //Time it lasts until being destroyed
    public float RecoveryTime { get { return m_RecoveryTime; } }

    public float OffsetZ { get { return m_OffsetZ; } }
    public float OffsetY { get { return m_OffsetY; } }
    public int ProjectileSpeed { get { return m_ProjectileSpeed; } }
    public float HitRadius { get { return m_HitRadius; } }

}