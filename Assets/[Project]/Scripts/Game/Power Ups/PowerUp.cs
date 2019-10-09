using System.Collections;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    [SerializeField] private PowerUpData powerUpData;
    [SerializeField] private GameObject moveSpeedEffect;
    [SerializeField] private GameObject damageUpEffect;
    [SerializeField] private GameObject damageReductionEffect;
    public bool Active { get; set; }

    public BuffType BuffType
    {
        get
        {
            return powerUpData.BuffType;
        }
    }

    public Vector3 Position
    {
        get
        {
            return transform.position;
        }
    }

    public PowerUpData Data { get { return powerUpData; } set { powerUpData = value; } }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            if (powerUpData.BuffType == BuffType.Heal)
            {

            }
            else
            {
                StartCoroutine(DurationTimer(powerUpData.Duration, powerUpData.BuffType, other));
            }
            Pickup();
        }
    }

    void Pickup()
    {
        Instantiate(powerUpData.Effect, transform.position, transform.rotation);

        GetComponent<Renderer>().enabled = false;
        GetComponent<Collider>().enabled = false;
        Active = false;
    }

    public IEnumerator DurationTimer(float lSeconds, BuffType lBuffType, Collider lOther)
    {
        yield return null;
    }
}
