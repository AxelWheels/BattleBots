using UnityEngine;

/// <summary>
/// A component that controls the game setup UI panel
/// </summary>
/// 
/// Daniel Beard
/// 
public class SetupPanel : UIPanel
{
    [SerializeField] private string[] m_Arenas;
    [SerializeField] private GameModeData[] m_GameModes;

    [SerializeField] private Carousel m_ArenaSelect;
    [SerializeField] private Carousel m_GameModeSelect;

    private bool m_AxisInUse = false;

    public string[] Arenas { get { return m_Arenas; } }

    private void OnEnable()
    {
        SetGameControllerArena();
        SetGameMode();
    }

    new void Update()
    {
        if (UIController.Instance.CurrentPanel == eUIPanel.Setup)
        {
            if (Input.GetButtonDown("B_All"))
            {
                UIController.Instance.ChangePanel(eUIPanel.Menu);
            }

            if (Input.GetButtonDown("RB_All"))
            {
                m_ArenaSelect.NextItem();
            }

            if (Input.GetButtonDown("LB_All"))
            {
                m_ArenaSelect.PrevItem();
            }

            float lLTAxis = Input.GetAxis("LT_All");
            float lRTAxis = Input.GetAxis("RT_All");

            if (lRTAxis > 0)
            {
                if (!m_AxisInUse)
                {
                    m_AxisInUse = true;
                    m_GameModeSelect.NextItem();
                }
            }

            if (lLTAxis > 0)
            {
                if (!m_AxisInUse)
                {
                    m_AxisInUse = true;
                    m_GameModeSelect.PrevItem();
                }
            }

            if (lLTAxis < 0.1f && lRTAxis < 0.1f)
            {
                m_AxisInUse = false;
            }
        }
        CheckEventSystem();
    }

    public void SetGameMode()
    {
        //ToDo: Set game mode to use before game start
        GameController.Instance.CurrentGameMode = m_GameModes[(int)m_GameModeSelect.CurrentIndex];
    }
    public void SetGameControllerArena()
    {
        //Debug.Log( m_Arenas[(int)m_ArenaSelect.CurrentIndex] );
        GameController.Instance.Arena = m_Arenas[(int)m_ArenaSelect.CurrentIndex];
    }
}
