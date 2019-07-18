using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

/// <summary>
/// A Singleton that controls the currently active camera to enable switching between camera angles/behaviours
/// </summary>
/// 
/// Daniel Beard
///
public class CameraController : SingletonManager<CameraController>
{
	[SerializeField]
	private CinemachineTargetGroup m_TargetGroup;
	[SerializeField]
	private GameObject m_MenuCam;
	[SerializeField]
	private GameObject m_MainCam;

	private Camera m_ActiveCameraBehaviour;

	public Camera ActiveCamera { get { return m_ActiveCameraBehaviour; } }
	public GameObject MenuCam { get { return m_MenuCam; } }
	public GameObject MainCam { get { return m_MainCam; } }

	public void SetActiveCamera( Camera lNewCamera )
	{
		if( lNewCamera != null )
		{
			if( m_ActiveCameraBehaviour != null )
			{
                //Turn off the top level object in the hierarchy of the current camera
                m_ActiveCameraBehaviour.enabled = false;
			}

			m_ActiveCameraBehaviour = lNewCamera;

            //Turn on the new main camera at it's root (Should be disabled by default anyway)
            m_ActiveCameraBehaviour.enabled = true;
		}
		else
		{
			Debug.Assert( false, "[CameraController] Did not expect new camera to be null" );
		}
	}

	public void AddToGroup( Transform lTargetToAdd, float lWeight, float lRadius )
	{
		CinemachineTargetGroup.Target lNewTarget;

		lNewTarget.target = lTargetToAdd;
		lNewTarget.radius = lRadius;
		lNewTarget.weight = lWeight;

		List<CinemachineTargetGroup.Target> lAllTargets = m_TargetGroup.m_Targets.ToList();
		lAllTargets.Add( lNewTarget );

		m_TargetGroup.m_Targets = lAllTargets.ToArray();
	}

	public void RemoveFromGroup( Transform lTargetToRemove )
	{
		List<CinemachineTargetGroup.Target> lAllTargets = m_TargetGroup.m_Targets.ToList();

		for( int i = 0; i < lAllTargets.Count; i++ )
		{
			if( lAllTargets[i].target == lTargetToRemove )
			{
				lAllTargets.RemoveAt( i );
			}
		}

		m_TargetGroup.m_Targets = lAllTargets.ToArray();
	}
}
