using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public class TweenPosition : Tweener.TweenResponsive
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
		if( m_LocalSpace )
			transform.localPosition = Vector3.Lerp( m_From, m_To, m_TweenCurve.Evaluate( lProgress ) );
		else
			transform.position = Vector3.Lerp( m_From, m_To, m_TweenCurve.Evaluate( lProgress ) );
	}
}
