using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;

namespace BattleBots.Utility
{
	internal class MeshColliderManagerEditor : EditorWindow
	{
		[MenuItem("Utility/Collider/All Mesh to Box Collider")]
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

		[MenuItem("Utility/Collider/Mesh Collider Manager")]
		private static void MeshColliderManagerWindow()
		{
			GetWindow(typeof(MeshColliderManagerEditor));
		}

		private void OnGUI()
		{
			EditorGUILayout.LabelField("Add box or sphere colliders to mesh colliders", EditorStyles.centeredGreyMiniLabel);

			GameObject[] rootObjects = SceneManager.GetActiveScene().GetRootGameObjects();

			for(int i = 0; i < rootObjects.Length; i++)
			{
				MeshCollider[] meshColliders = rootObjects[i].GetComponentsInChildren<MeshCollider>();

				for(int j = 0; j < meshColliders.Length; j++)
				{
					GameObject go = meshColliders[j].gameObject;

					Vector3 centre = meshColliders[j].sharedMesh.bounds.center;
					Vector3 extents = meshColliders[j].sharedMesh.bounds.extents;

					EditorGUILayout.ObjectField(go, typeof(GameObject), true);

					EditorGUILayout.BeginHorizontal();

					if (GUILayout.Button("Sphere Collider"))
					{
						Undo.DestroyObjectImmediate(meshColliders[j]);

						SphereCollider sc = Undo.AddComponent(go, typeof(SphereCollider)) as SphereCollider;
						sc.center = centre;
						sc.radius = extents.magnitude;
					}

					if(GUILayout.Button("Box Collider"))
					{
						Undo.DestroyObjectImmediate(meshColliders[j]);

						BoxCollider bc = Undo.AddComponent(go, typeof(BoxCollider)) as BoxCollider;
						bc.center = centre;
						bc.size = extents * 2f;
					}
					EditorGUILayout.EndHorizontal();
					EditorGUILayout.Space();

					
				}
			}
		}
	}
}
