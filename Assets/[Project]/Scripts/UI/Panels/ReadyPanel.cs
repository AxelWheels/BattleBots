using UnityEngine;

public class ReadyPanel : UIPanel
{
    [System.Serializable]
    private struct MechUIPanels
    {
        public GameObject m_MechSelectPanel;
        public GameObject m_APanel;
        public GameObject m_BotText;
        public bool playerControlled;
    }

    [SerializeField] private MechUIPanels[] m_MechUIPanels;
    [SerializeField] private GameObject m_ReadyImage;

    private void OnEnable()
    {
        m_ReadyImage.SetActive(false);

        GameController.Instance.NumberOfPlayers = 0;
        GameController.Instance.ActiveAIIDs.Clear();
        GameController.Instance.ActivePlayerIDs.Clear();

        for (int i = 0; i < 4; i++)
        {
            m_MechUIPanels[i].m_MechSelectPanel.SetActive(false);
            m_MechUIPanels[i].m_BotText.SetActive(false);
            m_MechUIPanels[i].m_APanel.SetActive(true);
        }
    }

    // Use this for initialization
    void Start()
    {
        if (GameController.Instance.DebugMode)
        {
            GameController.Instance.NumberOfPlayers = 4;
            GameController.Instance.ActivePlayerIDs.Add(0);
            GameController.Instance.ActivePlayerIDs.Add(1);
            GameController.Instance.ActivePlayerIDs.Add(2);
            GameController.Instance.ActivePlayerIDs.Add(3);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("B_All") && GameController.Instance.CurrentState.GetType() != typeof(GameState))
        {
            UIController.Instance.ChangePanel(eUIPanel.Setup);
        }

        if (GameController.Instance.DebugMode)
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                GameController.Instance.StartGame();
            }
            GameController.Instance.NumberOfPlayers = 2;
        }
        else
        {
            if (Input.GetButtonDown("A_1"))
            {
                TogglePlayer(0, !m_MechUIPanels[0].m_MechSelectPanel.activeSelf, false);
            }
            if (Input.GetButtonDown("A_2"))
            {
                TogglePlayer(1, !m_MechUIPanels[1].m_MechSelectPanel.activeSelf, false);
            }
            if (Input.GetButtonDown("A_3"))
            {
                TogglePlayer(2, !m_MechUIPanels[2].m_MechSelectPanel.activeSelf, false);
            }
            if (Input.GetButtonDown("A_4"))
            {
                TogglePlayer(3, !m_MechUIPanels[3].m_MechSelectPanel.activeSelf, false);
            }
        }

        if (Input.GetButtonDown("X_All") && GameController.Instance.CurrentState.GetType() != typeof(GameState))
        {
            for (int i = 0; i < 4; i++)
            {
                if (!GameController.Instance.ActivePlayerIDs.Contains(i) && !GameController.Instance.ActiveAIIDs.Contains(i))
                {
                    TogglePlayer(i, true, true);
                    break;
                }
            }
        }

        if (Input.GetButtonDown("Y_All") && GameController.Instance.CurrentState.GetType() != typeof(GameState))
        {
            foreach (int i in GameController.Instance.ActiveAIIDs)
                Debug.Log(i);

            GameController.Instance.ActiveAIIDs.Sort();
            if (GameController.Instance.ActiveAIIDs.Count > 0)
                TogglePlayer(GameController.Instance.ActiveAIIDs[GameController.Instance.ActiveAIIDs.Count - 1], false, true);
        }

        if (GameController.Instance.NumberOfPlayers > 1)
        {
            m_ReadyImage.SetActive(true);
            if (Input.GetButtonDown("Start_All") && GameController.Instance.CurrentState.GetType() != typeof(GameState))
            {
                GameController.Instance.StartGame();
            }
        }
        else
        {
            m_ReadyImage.SetActive(false);
        }
    }

    private void TogglePlayer(int lIndex, bool lEnable, bool lAI)
    {
        if (!GameController.Instance.DebugMode)
        {
            m_MechUIPanels[lIndex].m_BotText.SetActive(false);

            if (lEnable)
            {
                if (GameController.Instance.NumberOfPlayers < 4)
                {
                    if (lAI)
                    {
                        GameController.Instance.ActiveAIIDs.Add(lIndex);
                        m_MechUIPanels[lIndex].m_BotText.SetActive(true);
                    }
                    else
                    {

                        GameController.Instance.ActivePlayerIDs.Add(lIndex);
                    }
                }

                GameController.Instance.NumberOfPlayers = Mathf.Min(GameController.Instance.NumberOfPlayers + 1, 4);
            }
            else
            {
                if (GameController.Instance.NumberOfPlayers > 0)
                {
                    if (lAI)
                    {
                        GameController.Instance.ActiveAIIDs.Remove(lIndex);
                    }
                    else
                    {
                        if (GameController.Instance.ActiveAIIDs.Contains(lIndex))
                            GameController.Instance.ActiveAIIDs.Remove(lIndex);

                        GameController.Instance.ActivePlayerIDs.Remove(lIndex);
                    }
                }

                GameController.Instance.NumberOfPlayers = Mathf.Max(GameController.Instance.NumberOfPlayers - 1, 0);

            }

            m_MechUIPanels[lIndex].m_MechSelectPanel.SetActive(lEnable);
            m_MechUIPanels[lIndex].m_APanel.SetActive(!lEnable);
        }
    }
}
