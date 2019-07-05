using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectiveTrigger : MonoBehaviour
{
    public bool m_Triggered = false;

    private void OnTriggerEnter( Collider lOther )
    {
        if (lOther.tag == "Player")
        {
            m_Triggered = true;
        }
    }
}
