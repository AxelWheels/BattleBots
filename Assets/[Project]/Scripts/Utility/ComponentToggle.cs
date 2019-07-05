using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Toggles the selected component using the key selected in the inspector
/// </summary>
/// 
/// Daniel Beard
/// 
public class ComponentToggle : MonoBehaviour
{
	[SerializeField]
	private Behaviour m_Component;

	[SerializeField]
	private KeyCode m_KeyToPress;

	private void Update()
	{
		if (Input.GetKeyDown(m_KeyToPress))
		{
			m_Component.enabled = !m_Component.enabled;
		}
	}
}
