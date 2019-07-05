using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public class TweenAlpha : Tweener.TweenResponsive
{
	[SerializeField, Range( 0, 1 )]
	private float m_From;
	[SerializeField, Range( 0, 1 )]
	private float m_To;
	[SerializeField, Tooltip( "Evaluation curve for the tween" )]
	private AnimationCurve m_TweenCurve;

	[SerializeField]
	private CanvasGroup m_Target;

	public override void OnTweenerValueChanged( float lProgress )
	{
		m_Target.alpha = Mathf.Lerp( m_From, m_To, m_TweenCurve.Evaluate( lProgress ) );
	}
}
