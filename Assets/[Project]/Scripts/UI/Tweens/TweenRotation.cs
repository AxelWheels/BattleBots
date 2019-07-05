using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class TweenRotation : Tweener.TweenResponsive
{
	[SerializeField]
	private Vector3 m_From;
	[SerializeField]
	private Vector3 m_To;
	[SerializeField, Tooltip( "Evaluation curve for the tween" )]
	private AnimationCurve m_TweenCurve;
	[SerializeField]
	private bool m_LocalSpace = true;

	public Vector3 from
	{
		get { return m_From; }
		set { m_From = value; }
	}

	public Vector3 to
	{
		get { return m_To; }
		set { m_To = value; }
	}

	public override void OnTweenerValueChanged( float lProgress )
	{
		Quaternion lLerpRotation = Quaternion.Lerp( Quaternion.Euler( m_From.x, m_From.y, m_From.z ),
													Quaternion.Euler( m_To.x, m_To.y, m_To.z ),
													m_TweenCurve.Evaluate( lProgress ) );

		if( m_LocalSpace )
			transform.localRotation = lLerpRotation;
		else
			transform.rotation = lLerpRotation;
	}
}
