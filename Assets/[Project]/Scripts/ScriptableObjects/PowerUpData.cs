using UnityEngine;

public enum eBuffType
{
    Heal,
    Speed,
    DamageUp,
    DamageReduction
}

[CreateAssetMenu(fileName = "PowerUpData.asset", menuName = "Onyx/Create PowerUpData Object")]
public class PowerUpData : ScriptableObject
{
    [SerializeField]
    private eBuffType m_BuffType;

    [SerializeField]
    private Mesh m_Mesh;
    [SerializeField]
    private Material m_Material;
    [SerializeField]
    private GameObject m_Effect;
    [SerializeField]
    private int m_HealValue = 25;
    [SerializeField]
    private float m_SpeedMultiplier = 2f;
    [SerializeField]
    private float m_DamageUpMultiplier = 1.5f;
    [SerializeField]
    private float m_DamageReductionMultipler = 1.5f;
    [SerializeField]
    private float m_Duration = 1f;
    [SerializeField]
    private float m_RespawnTime = 30f;

    private bool m_RandomPowerUp;

    public eBuffType BuffType { get { return m_BuffType; } }

    public Mesh Mesh { get { return m_Mesh; } }
    public Material Material { get { return m_Material; } }
    public GameObject Effect { get { return m_Effect; } }
    public int HealValue { get { return m_HealValue; } }
    public float SpeedMultipler { get { return m_SpeedMultiplier; } }
    public float DamageUpMultiplier { get { return m_DamageUpMultiplier; } }
    public float DamageReductionMultiplier { get { return m_DamageReductionMultipler; } }
    public float Duration { get { return m_Duration; } }
    public float RespawnTime { get { return m_RespawnTime; } }
    public bool RandomPowerUp { get { return m_RandomPowerUp; } }
}
