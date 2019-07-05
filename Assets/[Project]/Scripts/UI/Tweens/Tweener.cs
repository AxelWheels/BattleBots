using System.Collections;
using UnityEngine;
using UnityEngine.Events;

//TODO: Fully implement tweener events in to UIPanels
public class Tweener : MonoBehaviour
{
	public abstract class TweenResponsive : MonoBehaviour
	{
		public virtual void OnTweenerValueChanged( float lValue )
		{
			return;
		}
	}

	public enum ePlayMode
	{
		None = 0,
		OnAwake,
		OnEnable,
	}

	public enum ePlayDirection
	{
		Stop = 0,
		Forward,
		Reverse
	}

	[SerializeField] private float m_Duration;
	[SerializeField] private bool startIn = true;
	[SerializeField] private bool m_IgnoreTimeScale;

	[SerializeField] private ePlayMode m_AutoPlay;

	[SerializeField] private TweenResponsive[] m_Tweeners;

	[SerializeField] private UnityEvent m_OnPlay;
	[SerializeField] private UnityEvent m_OnCompleteForward;
	[SerializeField] private UnityEvent m_OnCompleteReverse;

	private float m_Timer = -1;
	private ePlayDirection m_PlayDirection = ePlayDirection.Stop;

	public float Duration
	{
		get { return m_Duration; }
		set { m_Duration = value; }
	}

	public bool IgnoreTimescale
	{
		get { return m_IgnoreTimeScale; }
		set { m_IgnoreTimeScale = value; }
	}

	public UnityEvent OnTweenComplete
	{
		get { return m_OnCompleteForward; }
		set { m_OnCompleteForward = value; }
	}

	private void Awake()
	{
		if( startIn )
			SetValue( 0f );
		else
			SetValue( 1f );

		if( m_AutoPlay == ePlayMode.OnAwake )
			Play( true );
	}

	private void OnEnable()
	{
		if( m_AutoPlay == ePlayMode.OnEnable )
		{
			Play( true );
		}
	}

	//Plays all tweens attached to same object as Tweener
	//Use OnPlayHandler for any on play functions
	public void Play( bool lPlayForward )
	{
		m_OnPlay.Invoke();

		m_Tweeners = GetComponents<TweenResponsive>();
		m_PlayDirection = lPlayForward ? ePlayDirection.Forward : ePlayDirection.Reverse;

		m_Timer = 0f;
		SetValue( lPlayForward ? 0f : 1f );
	}

	private IEnumerator TweenerRoutine()
	{   
		//Until m_Timer hits duration tween value based on play direction and time
		while ( m_PlayDirection != ePlayDirection.Stop )
		{
			m_Timer += m_IgnoreTimeScale ? Time.unscaledDeltaTime : Time.deltaTime;
			SetValue( Mathf.Clamp01( m_PlayDirection == ePlayDirection.Forward ? m_Timer / m_Duration : 1 - ( m_Timer / m_Duration ) ) );

			if( m_Timer >= m_Duration )
			{
				if( m_PlayDirection == ePlayDirection.Forward )
				{
					m_OnCompleteForward.Invoke();
				}
				else
				{
					m_OnCompleteReverse.Invoke();
				}

				m_PlayDirection = ePlayDirection.Stop;
			}

			yield return null;
		}
	}

	//Sets value of tweeners attached to gameobject
	private void SetValue( float lProgress )
	{
		for( int i = 0; i < m_Tweeners.Length; i++ )
		{
			m_Tweeners[i].OnTweenerValueChanged( lProgress );
		}
	}
}
