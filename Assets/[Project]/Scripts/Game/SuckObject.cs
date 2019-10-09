using System.Collections.Generic;
using UnityEngine;

public class SuckObject : MonoBehaviour
{
    [SerializeField] private GameObject suckEffect = null;

    // Use this for initialization
    [SerializeField] private float pullingPower = 0.0f;

    [SerializeField] private float activeTime = 0.0f;

    [SerializeField] private bool permanent = false;
    private List<Rigidbody> playersInRange = new List<Rigidbody>();

    public Collider OwnerCollider { get; set; }

    void Start()
    {
        if (suckEffect != null)
        {
            //EffectsController.Instance.PlayEffectAtPosition( m_SuckEffect.name, transform.position, Quaternion.identity );
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!permanent)
        {
            if (activeTime <= 0)
            {
                Destroy(gameObject);
            }
        }

        activeTime = Mathf.Max(0f, activeTime - Time.deltaTime);
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
