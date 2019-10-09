using UnityEngine;

public class PowerUpSpawner : MonoBehaviour
{
    [SerializeField] private PowerUpData[] powerUps = new PowerUpData[0];
    [SerializeField] private PowerUp powerUp = null;

    private float spawnTime = 0f;

    public PowerUp PowerUp { get { return powerUp; } }

    private void Start()
    {
        SpawnPowerUp();
    }

    private void Update()
    {
        if (!powerUp.Active)
        {
            spawnTime = Mathf.Max(0f, spawnTime - Time.deltaTime);
            if (spawnTime <= 0f)
            {
                SpawnPowerUp();
            }
        }
    }

    private void SpawnPowerUp()
    {
        int lPowerUpIndex = Random.Range(0, powerUps.Length);
        powerUp.GetComponent<Renderer>().enabled = true;
        powerUp.GetComponent<Collider>().enabled = true;
        powerUp.Data = powerUps[lPowerUpIndex];
        powerUp.GetComponent<MeshFilter>().mesh = powerUp.Data.Mesh;
        powerUp.GetComponent<MeshRenderer>().material = powerUp.Data.Material;

        spawnTime = powerUp.Data.RespawnTime;
        powerUp.Active = true;
    }
}
