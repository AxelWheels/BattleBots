using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[Serializable]
public class TweenScale : Tweener.TweenResponsive
{
	[SerializeField]
	private Vector3 m_From;
	[SerializeField]
	private Vector3 m_To;
	[SerializeField, Tooltip( "Evaluation curve for the tween" )]
	private AnimationCurve m_TweenCurve;

	public override void OnTweenerValueChanged( float lProgress )
	{
		transform.localScale = Vector3.Lerp( m_From, m_To, m_TweenCurve.Evaluate( lProgress ) );
	}
}
