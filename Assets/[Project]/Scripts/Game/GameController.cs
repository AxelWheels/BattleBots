using System.Collections.Generic;
using UnityEngine;

public class GameController : SingletonManager<GameController>
{
    [SerializeField]
    private GameObject m_PlayerPrefab;

    [SerializeField]
    private GameObject m_MenuBackground;

    [SerializeField]
    private GameObject m_MenuMusicObject;

    [SerializeField]
    private GameModeData m_DefaultGameMode;

    [SerializeField]
    private PlayerColourData[] m_PlayerColours;

    [SerializeField]
    private KeyCode m_ExitKey;

    [SerializeField]
    private bool m_DebugMode = false;

    [SerializeField]
    private string m_TutorialArena;

    private GameStateBase m_CurrentState;

    private GameModeData m_CurrentGameMode;

    private List<int> m_ActivePlayerIDs = new List<int>();
    private List<int> m_ActiveAIIDs = new List<int>();

    private string m_Arena;
    private bool m_Paused = false;
    private bool m_Tutorial = false;
    private bool m_InSettings = false;
    private int m_NumberOfPlayers = 0;

    public delegate void GameStateChange(GameStateBase lState);
    public event GameStateChange OnGameStateChange;

    public GameObject PlayerPrefab { get { return m_PlayerPrefab; } }
    public GameObject MenuBackground { get { return m_MenuBackground; } }

    public GameStateBase CurrentState { get { return m_CurrentState; } }
    public GameModeData CurrentGameMode { get { return m_CurrentGameMode; } set { m_CurrentGameMode = value; } }
    public PlayerColourData[] PlayerColours { get { return m_PlayerColours; } }
    public List<int> ActivePlayerIDs { get { return m_ActivePlayerIDs; } set { m_ActivePlayerIDs = value; } }
    public List<int> ActiveAIIDs { get { return m_ActiveAIIDs; } set { m_ActiveAIIDs = value; } }

    public string Arena { set { m_Arena = value; } }
    public bool DebugMode { get { return m_DebugMode; } }
    public bool Paused { get { return m_Paused; } }
    public bool Tutorial { get { return m_Tutorial; } set { m_Tutorial = value; } }
    public bool InSettings { get { return m_InSettings; } set { m_InSettings = value; } }
    public int NumberOfPlayers { get { return m_NumberOfPlayers; } set { m_NumberOfPlayers = value; } }

    private void Awake()
    {
        ChangeState(new MenuState());
    }

    private void Start()
    {
        //Application.targetFrameRate = 30;
    }

    private void Update()
    {
        //TODO: Replace direction input access with an input layer and record who paused it
        if ((Input.GetKeyDown(m_ExitKey) || Input.GetButtonDown("Start_All")) && MatchController.Instance.InProgress && !m_InSettings)
        {
            //TODO: Replace with Escape menu
            TogglePauseMenu();
        }
    }

    public void ChangeState(GameStateBase lNewState)
    {
        if (m_CurrentState != null)
        {
            m_CurrentState.PopState();
        }

        m_CurrentState = lNewState;

        m_CurrentState.PushState();

        if (OnGameStateChange != null)
        {
            OnGameStateChange(m_CurrentState);
        }
    }

    public void TogglePauseMenu()
    {
        //If we're not in the game, we shouldn't be able to show the pause menu
        if (m_CurrentState.GetType() == typeof(GameState) || m_CurrentState.GetType() == typeof(PracticeState))
        {
            m_Paused = !m_Paused;
            if (m_Paused)
            {
                Time.timeScale = 0.0f;
                UIController.Instance.ChangePanel(eUIPanel.Pause);
            }
            else
            {
                Time.timeScale = 1.0f;
                UIController.Instance.ChangePanel(eUIPanel.Game);
            }

            if (MatchController.Instance.InProgress)
            {
                for (int i = 0; i < MatchController.Instance.CurrentPlayers.Count; i++)
                {
                    MatchController.Instance.CurrentPlayers[i].CanInput = !Paused;
                }
            }
        }
    }

    public void BackToMainMenu()
    {
        TogglePauseMenu();

        ChangeState(new MenuState());

        m_MenuMusicObject.SetActive(true);
    }

    public List<PlayerController> SpawnPlayers(int lPlayers)
    {
        List<PlayerController> lPlayerList = new List<PlayerController>();

        for (int i = 0; i < 4; i++)
        {
            if (m_ActivePlayerIDs.Contains(i) || m_DebugMode)
            {
                GameObject lPlayer = Instantiate(m_PlayerPrefab, new Vector3(0f, 10000f, 0f), Quaternion.identity);

                //Set the controller ID of the current player so that their controls work
                lPlayer.GetComponent<PlayerController>().Initialise(i, false);

                lPlayerList.Add(lPlayer.GetComponent<PlayerController>());
            }

            if (m_ActiveAIIDs.Contains(i))
            {
                GameObject lPlayer = Instantiate(m_PlayerPrefab, new Vector3(0f, 10000f, 0f), Quaternion.identity);

                //Set the controller ID of the current player so that their controls work
                lPlayer.GetComponent<PlayerController>().Initialise(i, true);

                lPlayerList.Add(lPlayer.GetComponent<PlayerController>());
            }

        }

        return lPlayerList;
    }

    public void StartGame()
    {
        m_MenuMusicObject.SetActive(false);

        m_Paused = false;
        ChangeState(new GameState());

        ArenaController.Instance.OnArenaLoad += OnArenaLoad;

        if (m_CurrentGameMode == null)
        {
            m_CurrentGameMode = m_DefaultGameMode;
        }

        Debug.Log(m_CurrentGameMode.name);
        MatchController.Instance.SetupMatch(m_Arena, m_CurrentGameMode, m_NumberOfPlayers);
    }

    public void StartTutorial()
    {
        m_Tutorial = true;
        m_MenuMusicObject.SetActive(false);

        m_Paused = false;
        ChangeState(new PracticeState());
        m_Arena = m_TutorialArena;

        ArenaController.Instance.OnArenaLoad += OnArenaLoad;

        m_ActivePlayerIDs.Add(0);
        m_ActivePlayerIDs.Add(1);

        m_CurrentGameMode = m_DefaultGameMode;

        MatchController.Instance.SetupMatch(m_Arena, m_CurrentGameMode, m_NumberOfPlayers);
    }

    private void OnArenaLoad(string lArena)
    {
        ArenaController.Instance.OnArenaLoad -= OnArenaLoad;
    }

    public void ExitGame()
    {
        Application.Quit();
    }

    public void SetMechMaterial(GameObject lMech, PlayerColourData lPlayerColour)
    {
        Renderer[] lRenderers = lMech.GetComponentsInChildren<Renderer>();
        for (int i = 0; i < lRenderers.Length; i++)
        {
            Material[] lMats = lRenderers[i].materials;
            for (int j = 0; j < lRenderers[i].materials.Length; j++)
            {
                lMats[j].SetFloat("_EMISColour", lPlayerColour.MatColour);
                lMats[j].SetFloat("_Hue", lPlayerColour.MatColour);
            }

        }
    }
}

