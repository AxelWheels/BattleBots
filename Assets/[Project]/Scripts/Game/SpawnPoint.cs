using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnPoint : MonoBehaviour
{
	private bool m_Active = true;

	private float m_UnactiveTime = 3.0f;
	private float m_ActiveTimer = 0.0f;

	public bool Active { get { return m_Active; } }

	private void Awake()
	{
		ArenaController.Instance.SpawnPoints.Add( this );
		//ArenaController.Instance.OnArenaLoad += OnArenaLoad;
	}

	public void Deactivate()
	{
		m_Active = false;

		m_ActiveTimer = m_UnactiveTime;
	}

	private void Update()
	{
		if( !m_Active )
		{
			m_ActiveTimer -= Time.deltaTime;

			if( m_ActiveTimer < 0 )
			{
				m_Active = true;
			}
		}
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.DrawWireSphere( transform.position, 1 );
		Gizmos.DrawLine( transform.position, transform.position + transform.forward );
	}
}
