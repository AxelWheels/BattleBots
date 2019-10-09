using UnityEngine;

public enum BuffType
{
    Heal,
    Speed,
    DamageUp,
    DamageReduction
}

[CreateAssetMenu(fileName = "PowerUpData.asset", menuName = "Onyx/Create PowerUpData Object")]
public class PowerUpData : ScriptableObject
{
    [SerializeField] private BuffType buffType = BuffType.DamageReduction;

    [SerializeField] private Mesh mesh = null;
    [SerializeField] private Material material = null;
    [SerializeField] private GameObject effect = null;
    [SerializeField] private int healValue = 25;
    [SerializeField] private float speedMultiplier = 2f;
    [SerializeField] private float damageUpMultiplier = 1.5f;
    [SerializeField] private float damageReductionMultipler = 1.5f;
    [SerializeField] private float duration = 1f;
    [SerializeField] private float respawnTime = 30f;

    private bool randomPowerUp = false;

    public BuffType BuffType { get { return buffType; } }

    public Mesh Mesh { get { return mesh; } }
    public Material Material { get { return material; } }
    public GameObject Effect { get { return effect; } }
    public int HealValue { get { return healValue; } }
    public float SpeedMultipler { get { return speedMultiplier; } }
    public float DamageUpMultiplier { get { return damageUpMultiplier; } }
    public float DamageReductionMultiplier { get { return damageReductionMultipler; } }
    public float Duration { get { return duration; } }
    public float RespawnTime { get { return respawnTime; } }
    public bool RandomPowerUp { get { return randomPowerUp; } }
}
