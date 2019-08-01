using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace BattleBots
{
	public class SceneLoader : MonoBehaviourSingleton<SceneLoader>
	{
		public delegate void SceneLoadDelegate(string lArena);
		public event SceneLoadDelegate OnSceneLoad;

		public void LoadScene(string sceneName)
		{
			StartCoroutine(LoadSceneCoroutine(sceneName, LoadSceneMode.Additive));
		}

		public void UnloadScene(string sceneName)
		{
			SceneManager.UnloadSceneAsync(sceneName);
		}

		private IEnumerator LoadSceneCoroutine(string sceneName, LoadSceneMode sceneMode)
		{
			//UIController.Instance.GetScreen(eUIPanel.Load).Show();
			Application.backgroundLoadingPriority = ThreadPriority.Low;
			AsyncOperation lAsyncOperation = SceneManager.LoadSceneAsync(sceneName, sceneMode);

			yield return lAsyncOperation;

			Application.backgroundLoadingPriority = ThreadPriority.Normal;
			OnSceneLoad?.Invoke(sceneName);
		}
	}
}

