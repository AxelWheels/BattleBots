using UnityEngine;

[CreateAssetMenu(fileName = "InvincibilityData.asset", menuName = "Onyx/Create InvincibilityData Object", order = 0)]
public class InvincibilityData : ScriptableObject
{
    [SerializeField] private float dodgeTime = 0.0f;

    [SerializeField] private float spawnTime = 0.0f;

    [SerializeField] private float swapTime = 0.0f;

    [SerializeField] private float stunTime = 0.0f;

    public float DodgeTime { get { return dodgeTime; } }
    public float SpawnTime { get { return spawnTime; } }
    public float SwapTime { get { return swapTime; } }
    public float StunTime { get { return stunTime; } }
}
