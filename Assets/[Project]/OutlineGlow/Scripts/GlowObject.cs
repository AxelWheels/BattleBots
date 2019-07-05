using UnityEngine;
using System.Collections.Generic;

public class GlowObject : MonoBehaviour
{
	public Renderer[] Renderers
	{
		get;
		private set;
	}

	public Color CurrentColor
	{
		get { return m_CurrentColour; }
	}

	private List<Material> m_Materials = new List<Material>();
	private Color m_CurrentColour;
	private Color m_TargetColour;

	void Start()
	{
		Renderers = GetComponentsInChildren<Renderer>();

		m_TargetColour = GetComponentInParent<PlayerController>().PlayerColour.PColour;

		for( int i = 0; i < Renderers.Length; i++ )
		{
			m_Materials.AddRange( Renderers[i].materials );
		}
	}

	/// <summary>
	/// Loop over all cached materials and update their color.
	/// </summary>
	private void Update()
	{
		m_CurrentColour = m_TargetColour;

		for( int i = 0; i < m_Materials.Count; i++ )
		{
			m_Materials[i].SetColor( "_GlowColor", m_CurrentColour );
		}
	}
}
