using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// A scriptable object that contains scene data to be able to access certain scenes on request
/// </summary>
/// 
/// Daniel Beard
/// 
[CreateAssetMenu( fileName = "SceneLoadData.asset", menuName = "Onyx/Create SceneLoadData Object", order = 0 )]
public class SceneLoadData : ScriptableObject
{
	[SerializeField]
	private string m_StartSceneToLoad;

	public string StartSceneToLoad { get { return m_StartSceneToLoad; } }
}
