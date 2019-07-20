using UnityEngine;

/// <summary>
/// A scriptable object that contains scene data to be able to access certain scenes on request
/// </summary>

namespace BattleBots
{
	[CreateAssetMenu(fileName = "SceneLoadData.asset", menuName = "Onyx/Create SceneLoadData Object", order = 0)]
	public class SceneLoadData : ScriptableObject
	{
		[SerializeField]
		private string startScene;

		[SerializeField]
		private string[] arenaScenes;

		public string[] ArenaScenes => arenaScenes;
	}
}
