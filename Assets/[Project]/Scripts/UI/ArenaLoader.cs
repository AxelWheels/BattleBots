using UnityEngine;
using TMPro;

namespace BattleBots
{
	internal class ArenaLoader : MonoBehaviour 
	{
		[SerializeField] private SceneLoadData sceneData;

		[SerializeField] private TextMeshProUGUI selectedSceneText;

		private int selectedScene = 0;

		public string CurrentSelectedSceneName => sceneData.ArenaScenes[selectedScene];

		private void Start()
		{
			selectedSceneText.text = CurrentSelectedSceneName;
		}

		public void ChangeScene(int index)
		{
			selectedScene = index;
			selectedSceneText.text = CurrentSelectedSceneName;
		}

		public void ChangeSceneByIncrement(int increment)
		{
			selectedScene = Mathf.Clamp(selectedScene + increment, 0, sceneData.ArenaScenes.Length - 1);
			selectedSceneText.text = CurrentSelectedSceneName;
		}

		public void LoadArena()
		{
			SceneLoader.Instance.LoadScene(CurrentSelectedSceneName);
		}

		public void UnloadArena()
		{
			SceneLoader.Instance.UnloadScene(CurrentSelectedSceneName);
		}
	}
}
