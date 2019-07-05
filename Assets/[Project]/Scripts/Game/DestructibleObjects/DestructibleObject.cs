using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestructibleObject : MonoBehaviour
{
    [SerializeField]
    private GameObject m_ExplosionEffect;
    [SerializeField]
    private SoundData m_SoundData;
    [SerializeField]
    private string m_ExplosionSound;

    [SerializeField]
    private float m_Radius = 10f;
    [SerializeField]
    private float m_DefaultDamage = 25f;

    public void Destruct()
    {
        Instantiate( m_ExplosionEffect, transform.position, transform.rotation );
        
        if (m_SoundData != null)
        {
            SoundController.Instance.PlaySound( m_SoundData.GetSound( m_ExplosionSound ), transform, true, m_SoundData.GetVolume( m_ExplosionSound ) );
        }

        /*Collider[] lColliders = Physics.OverlapSphere( transform.position, m_Radius );
        foreach ( Collider m_Rigidbody in lColliders )
        {
            Rigidbody lOther = m_Rigidbody.GetComponent<Rigidbody>();

            if( lOther.tag == "Player" )
            {
                float m_DistanceFromPlayer = (transform.position - lOther.transform.position).magnitude;

                float m_DamageCalculation = 1 - (m_DistanceFromPlayer / m_Radius);

                lOther.gameObject.GetComponentInParent<PlayerController>().ChangeHealth(null, (int)(m_DefaultDamage * m_DamageCalculation));
            }
        }*/

        Destroy( gameObject );
    }
}
