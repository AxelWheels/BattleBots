using System.Collections.Generic;
using UnityEngine;

public class SuckObject : MonoBehaviour
{
    [SerializeField]
    private GameObject m_SuckEffect;

    // Use this for initialization
    [SerializeField]
    private float m_PullingPower;

    [SerializeField]
    private float m_ActiveTime;

    [SerializeField]
    private bool m_Permanent;

    private Collider m_OwnerCollider;

    private List<Rigidbody> m_PlayersInRange = new List<Rigidbody>();

    public Collider OwnerCollider { get { return m_OwnerCollider; } set { m_OwnerCollider = value; } }

    void Start()
    {
        if (m_SuckEffect != null)
        {
            //EffectsController.Instance.PlayEffectAtPosition( m_SuckEffect.name, transform.position, Quaternion.identity );
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!m_Permanent)
        {
            if (m_ActiveTime <= 0)
            {
                Destroy(gameObject);
            }
        }

        m_ActiveTime = Mathf.Max(0f, m_ActiveTime - Time.deltaTime);
    }

    private void FixedUpdate()
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {

        }
    }
}
