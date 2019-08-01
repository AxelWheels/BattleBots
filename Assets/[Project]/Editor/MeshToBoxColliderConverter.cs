using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;

namespace BattleBots
{

	internal class MeshToBoxColliderConverter : EditorWindow
	{
		[MenuItem("Utility/Mesh to Box Collider")]
		private static void MeshToBoxCollider()
		{
			GameObject[] rootObjects = SceneManager.GetActiveScene().GetRootGameObjects();

			for (int i = 0; i < rootObjects.Length; i++)
			{
				MeshCollider[] meshColliders = rootObjects[i].GetComponentsInChildren<MeshCollider>();

				for (int j = 0; j < meshColliders.Length; j++)
				{
					GameObject go = meshColliders[j].gameObject;

					Vector3 center = meshColliders[j].sharedMesh.bounds.center;
					Vector3 extents = meshColliders[j].sharedMesh.bounds.extents;

					DestroyImmediate(meshColliders[j]);

					BoxCollider bc = go.AddComponent<BoxCollider>();
					bc.center = center;
					bc.size = extents * 2f;
				}
			}
		}
	}
}
