using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A script that sits on the root object of each of the cameras and contains functions to enable and disable the camera
/// </summary>
/// 
/// Daniel Beard
/// 
public class CameraBehaviour : MonoBehaviour
{
	public void EnableCamera()
	{
		transform.root.gameObject.SetActive( true );
	}

	public void DisableCamera()
	{
		transform.root.gameObject.SetActive( false );
	}
}
