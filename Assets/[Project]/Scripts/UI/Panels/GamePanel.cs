using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// A component that controls the in-game UI panel
/// </summary>
/// 
/// Daniel Beard
/// 
public class GamePanel : UIPanel
{
    [SerializeField] private Text timerText = null;
    [SerializeField] private GameObject timerObject = null;
    [SerializeField] private GameObject countdown = null;
    [SerializeField] private PlayerStatus[] players = null;

    public GameObject Countdown { get { return countdown; } }
    public PlayerStatus[] Players { get { return players; } }

    private void Start()
    {
        MatchController.Instance.OnMatchStarted += OnMatchStarted;
        MatchController.Instance.OnMatchEnded += OnMatchEnded;
    }

    private void OnMatchStarted(GameModeData lGameData)
    {
        timerObject.SetActive(!lGameData.UnlimitedTime);
    }

    private void OnMatchEnded()
    {
        timerObject.SetActive(false);
    }

    private new void Update()
    {
        if (MatchController.Instance.InProgress)
        {
            string lMinutes = (Mathf.Floor(MatchController.Instance.TimeLeft / 60)).ToString("00");
            string lSeconds = (Mathf.Floor(MatchController.Instance.TimeLeft % 60)).ToString("00");

            timerText.text = lMinutes + ":" + lSeconds;
        }
    }
}
