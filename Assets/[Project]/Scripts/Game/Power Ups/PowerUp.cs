using System.Collections;
using UnityEngine;

public class PowerUp : MonoBehaviour
{
    [SerializeField]
    private PowerUpData m_PowerUpData;

    [SerializeField]
    private GameObject m_MoveSpeedEffect;
    [SerializeField]
    private GameObject m_DamageUpEffect;
    [SerializeField]
    private GameObject m_DamageReductionEffect;

    private bool m_Active;

    public bool Active
    {
        get { return m_Active; }
        set { m_Active = value; }
    }

    public eBuffType BuffType
    {
        get
        {
            return m_PowerUpData.BuffType;
        }
    }

    public Vector3 Position
    {
        get
        {
            return transform.position;
        }
    }

    public PowerUpData PUD { get { return m_PowerUpData; } set { m_PowerUpData = value; } }

    private void OnTriggerEnter(Collider lOther)
    {
        if (lOther.tag == "Player")
        {
            if (m_PowerUpData.BuffType == eBuffType.Heal)
            {

            }
            else
            {
                StartCoroutine(DurationTimer(m_PowerUpData.Duration, m_PowerUpData.BuffType, lOther));
            }
            Pickup();
        }
    }

    void Pickup()
    {
        Instantiate(m_PowerUpData.Effect, transform.position, transform.rotation);

        GetComponent<Renderer>().enabled = false;
        GetComponent<Collider>().enabled = false;
        m_Active = false;
    }

    public IEnumerator DurationTimer(float lSeconds, eBuffType lBuffType, Collider lOther)
    {
		yield return null;
    }
}
