using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

/// <summary>
/// Script that controls the loading and unloading of the arenas as scenes. Also contains the enumerable which defines an arena.
/// </summary>
/// 
/// Daniel Beard
/// 

public class ArenaController : SingletonManager<ArenaController>
{
    [SerializeField] private SceneLoadData sceneLoadData = null;
    [SerializeField] private SoundData gameSounds = null;
    [SerializeField] private List<SpawnPoint> spawnPoints = new List<SpawnPoint>();
    [SerializeField] private string environmentScene = string.Empty;

    private SpawnPoint lastSpawnPoint = null;
    private string loadedArena = string.Empty;

    public delegate void ArenaLoad(string lArena);
    public event ArenaLoad OnArenaLoad;

    public List<SpawnPoint> SpawnPoints { get { return spawnPoints; } }

    public SpawnPoint LastSpawn { get { return lastSpawnPoint; } set { lastSpawnPoint = value; } }

    public string LoadedArena { get { return loadedArena; } }

    public SpawnPoint GetSpawnPoint()
    {
        SpawnPoint lRandomSpawnPoint = SpawnPoints[Random.Range(0, SpawnPoints.Count)];

        if (lRandomSpawnPoint.Active)
        {
            lRandomSpawnPoint.Deactivate();

            return lRandomSpawnPoint;
        }
        else
        {
            return GetSpawnPoint();
        }
    }

    public void LoadArena(string lArena)
    {
        UnloadArena();

        AsyncLoadScene(lArena, LoadSceneMode.Additive);

        loadedArena = lArena;
    }

    public void UnloadArena()
    {
        spawnPoints = new List<SpawnPoint>();

        //If we're loading a level for the first time, there will not be an arena loaded
        if (loadedArena != null)
        {
            SceneManager.UnloadSceneAsync(environmentScene);
            SceneManager.UnloadSceneAsync(loadedArena);

            loadedArena = null;
        }
    }

    private void AsyncLoadScene(string lScene, LoadSceneMode lMode)
    {
        StartCoroutine(LoadSceneCoroutine(lScene, lMode));
    }

    private IEnumerator LoadSceneCoroutine(string lScene, LoadSceneMode lMode)
    {
        UIController.Instance.GetScreen(eUIPanel.Load).Show();

        Application.backgroundLoadingPriority = ThreadPriority.Low;

        AsyncOperation lAsyncOperation = SceneManager.LoadSceneAsync(lScene, lMode);

        yield return lAsyncOperation;

        lAsyncOperation = SceneManager.LoadSceneAsync(environmentScene, LoadSceneMode.Additive);

        yield return lAsyncOperation;

        Application.backgroundLoadingPriority = ThreadPriority.Normal;

        UIController.Instance.GetScreen(eUIPanel.Load).Hide();

        if (OnArenaLoad != null)
        {
            OnArenaLoad(lScene);
        }

        SoundController.Instance.PlaySound(gameSounds.GetSound("GameLoaded"), Camera.main.transform, false, gameSounds.GetVolume("GameLoaded"));
    }
}
