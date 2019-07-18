using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// This is a script to fix a known bug in Unity where multiple mesh colliders are added to objects on Apply.
/// Daniel Beard
[ExecuteInEditMode]
public class RemoveMeshColliders : MonoBehaviour
{
	private void Update()
	{
		MeshCollider[] m_Colliders = GetComponents<MeshCollider>();

		for( int i = 1; i < m_Colliders.Length; i++ )
		{
			DestroyImmediate( m_Colliders[i] );
		}
	}

}
