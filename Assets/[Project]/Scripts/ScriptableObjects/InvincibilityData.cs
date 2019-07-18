using UnityEngine;

[CreateAssetMenu(fileName = "InvincibilityData.asset", menuName = "Onyx/Create InvincibilityData Object", order = 0)]
public class InvincibilityData : ScriptableObject
{
    [SerializeField]
    private float m_DodgeTime = 0.0f;

    [SerializeField]
    private float m_SpawnTime = 0.0f;

    [SerializeField]
    private float m_SwapTime = 0.0f;

    [SerializeField]
    private float m_StunTime = 0.0f;

    public float DodgeTime { get { return m_DodgeTime; } }
    public float SpawnTime { get { return m_SpawnTime; } }
    public float SwapTime { get { return m_SwapTime; } }
    public float StunTime { get { return m_StunTime; } }
}
