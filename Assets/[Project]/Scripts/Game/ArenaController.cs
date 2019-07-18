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
    [SerializeField]
    private SceneLoadData m_SceneLoadData;

    [SerializeField]
    private SoundData m_GameSounds;

    [SerializeField]
    private List<SpawnPoint> m_SpawnPoints;

    [SerializeField]
    private string m_EnvironmentScene;

    private SpawnPoint m_LastSpawnPoint;

    private string m_LoadedArena;

    public delegate void ArenaLoad(string lArena);
    public event ArenaLoad OnArenaLoad;

    public List<SpawnPoint> SpawnPoints { get { return m_SpawnPoints; } }

    public SpawnPoint LastSpawn { get { return m_LastSpawnPoint; } set { m_LastSpawnPoint = value; } }

    public string LoadedArena { get { return m_LoadedArena; } }

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

        m_LoadedArena = lArena;
    }

    public void UnloadArena()
    {
        m_SpawnPoints = new List<SpawnPoint>();

        //If we're loading a level for the first time, there will not be an arena loaded
        if (m_LoadedArena != null)
        {
            SceneManager.UnloadSceneAsync(m_EnvironmentScene);
            SceneManager.UnloadSceneAsync(m_LoadedArena);

            m_LoadedArena = null;
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

        lAsyncOperation = SceneManager.LoadSceneAsync(m_EnvironmentScene, LoadSceneMode.Additive);

        yield return lAsyncOperation;

        Application.backgroundLoadingPriority = ThreadPriority.Normal;

        UIController.Instance.GetScreen(eUIPanel.Load).Hide();

        if (OnArenaLoad != null)
        {
            OnArenaLoad(lScene);
        }

        SoundController.Instance.PlaySound(m_GameSounds.GetSound("GameLoaded"), Camera.main.transform, false, m_GameSounds.GetVolume("GameLoaded"));
    }
}
