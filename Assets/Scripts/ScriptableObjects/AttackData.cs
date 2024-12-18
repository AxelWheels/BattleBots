using UnityEngine;

public interface IAttackData { }

[System.Serializable]
public class AttackData : ScriptableObject, IAttackData
{
    [SerializeField] protected int damage = 0;
    [SerializeField] protected float knockback = 1.0f;
    [SerializeField] protected float hitStun = 0.5f;
    [SerializeField] protected float startUpTime = 0.0f;
    [SerializeField] protected float recoveryTime = 0.0f;
    [SerializeField] protected float hitRadius = 0f;

	public int Damage => damage;
    public float Knockback => knockback;
    public float HitStun => hitStun;
    public float StartUpTime => startUpTime;
    public float RecoveryTime => recoveryTime;
    public float HitRadius => hitRadius;

}