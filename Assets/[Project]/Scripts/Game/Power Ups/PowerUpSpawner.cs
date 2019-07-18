using UnityEngine;

public class PowerUpSpawner : MonoBehaviour
{
    [SerializeField]
    private PowerUpData[] m_PowerUps;
    [SerializeField]
    private PowerUp m_PowerUp;

    private float m_SpawnTime = 0f;

    public PowerUp PowerUp { get { return m_PowerUp; } }

    private void Start()
    {
        SpawnPowerUp();
    }

    private void Update()
    {
        if (!m_PowerUp.Active)
        {
            m_SpawnTime = Mathf.Max(0f, m_SpawnTime - Time.deltaTime);
            if (m_SpawnTime <= 0f)
            {
                SpawnPowerUp();
            }
        }
    }

    private void SpawnPowerUp()
    {
        int lPowerUpIndex = Random.Range(0, m_PowerUps.Length);
        m_PowerUp.GetComponent<Renderer>().enabled = true;
        m_PowerUp.GetComponent<Collider>().enabled = true;
        m_PowerUp.PUD = m_PowerUps[lPowerUpIndex];
        m_PowerUp.GetComponent<MeshFilter>().mesh = m_PowerUp.PUD.Mesh;
        m_PowerUp.GetComponent<MeshRenderer>().material = m_PowerUp.PUD.Material;

        m_SpawnTime = m_PowerUp.PUD.RespawnTime;
        m_PowerUp.Active = true;
    }
}
