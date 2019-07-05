using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// A component to automatically load the chosen scene in the game when any key is pressed. The value is saved in a scriptable object in the project.
/// </summary>
/// 
/// Daniel Beard
/// 
public class SplashController : MonoBehaviour
{
	[SerializeField]
	private SceneLoadData m_SceneLoadData;

	private void Update()
	{
		if( Input.anyKeyDown )
		{
			SceneManager.LoadScene( m_SceneLoadData.StartSceneToLoad );
		}
	}
}
