using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

[RequireComponent( typeof( Tweener ) )]
public class UIPanel : MonoBehaviour
{
	public delegate void UIPanelEvent( UIPanel lPanel );

	public static event UIPanelEvent OnUIPanelShow;
	public static event UIPanelEvent OnUIPanelHide;

	[SerializeField] protected CanvasGroup m_CanvasGroup;
	[SerializeField] protected bool m_HoldTransition = false;
	[SerializeField] protected GameObject m_StartFocusObject;

	private Camera m_UICamera;
	private float m_Timer = 0f;

	public CanvasGroup CG { get { return m_CanvasGroup; } }
	public bool HoldTransition { get { return m_HoldTransition; } }

	protected void Update()
	{
		CheckEventSystem();
	}

	protected void CheckEventSystem()
	{
		if( EventSystem.current.currentSelectedGameObject == null )
		{
			EventSystem.current.SetSelectedGameObject( m_StartFocusObject );
		}
	}

	protected Camera UICamera
	{
		get
		{
			if( m_UICamera == null )
			{
				Canvas lCanvas = GetComponentInParent<Canvas>();
				m_UICamera = lCanvas.GetComponentInChildren<Camera>( true );
			}

			return m_UICamera;
		}
	}

	public void Show()
	{
		if( !gameObject.activeInHierarchy )
		{
			gameObject.SetActive( true );

			if( OnUIPanelShow != null )
			{
				OnUIPanelShow( this );
			}
		}
	}

	public void Hide()
	{
		if( gameObject.activeInHierarchy )
		{
			gameObject.SetActive( false );

			if( OnUIPanelHide != null )
			{
				OnUIPanelHide( this );
			}
		}
	}

	private void TogglePanelInteraction( bool lEnable )
	{
		m_CanvasGroup.interactable = lEnable;

	}

	public virtual void OnTransitionIn()
	{
		//Debug.Log( "Transition In " + gameObject.name );
		TogglePanelInteraction( true );
		StartCoroutine( SetEventSystem( this ) );
	}

	public virtual void OnTransitionOut()
	{
		//Debug.Log( "Transition Out" );
		Hide();
		TogglePanelInteraction( false );
	}

	public virtual void OnTransition()
	{
		//Debug.Log( "Transition Play" );
		Show();
		TogglePanelInteraction( false );
	}

	public IEnumerator SetEventSystem( UIPanel lPanel )
	{
		EventSystem.current.SetSelectedGameObject( null );

		yield return new WaitForEndOfFrame();

		EventSystem.current.SetSelectedGameObject( lPanel.m_StartFocusObject );
	}
}
