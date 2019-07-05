using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent( typeof( Tweener ) )]
[RequireComponent( typeof( TweenRotation ) )]
[RequireComponent( typeof( TweenPosition ) )]
public class CameraTransition : MonoBehaviour
{
	[System.Serializable]
	public struct CameraTransitionPoint
	{
		public Vector3 m_Position;
		public Vector3 m_EulerRotation;
	}

	[SerializeField] private CameraTransitionPoint[] m_CameraPoints;
	[SerializeField] private Tweener m_Tweener;
	[SerializeField] private TweenPosition m_TweenPosition;
	[SerializeField] private TweenRotation m_TweenRotation;

	private CameraTransitionPoint m_TargetPoint;

	private void OnEnable()
	{
		CameraController.Instance.MainCam.SetActive( false );
	}

	private void OnDisable()
	{
		CameraController.Instance.MainCam.SetActive( true );
	}

	private void Start()
	{
		m_TargetPoint = m_CameraPoints[0];
		TransitionCamera( 0 );
		m_Tweener = GetComponent<Tweener>();
		m_TweenPosition = GetComponent<TweenPosition>();
		m_TweenRotation = GetComponent<TweenRotation>();
	}

	public void TransitionCamera( int lIndex )
	{
		m_TweenPosition.from = m_TargetPoint.m_Position;
		m_TweenRotation.from = m_TargetPoint.m_EulerRotation;

		m_TargetPoint = m_CameraPoints[lIndex];

		m_TweenPosition.to = m_TargetPoint.m_Position;
		m_TweenRotation.to = m_TargetPoint.m_EulerRotation;

		m_Tweener.Play( true );
	}
}
