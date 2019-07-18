/// <summary>
/// A class that controls the end of the gameplay phase and cleans up anything from the game so far so that it can be cleanly restarted
/// </summary>
/// 
/// Daniel Beard
///
public class ResultState : GameStateBase
{
    public override void PushState()
    {
        OnBegin();
    }

    protected override void OnBegin()
    {
        base.OnBegin();
        UIController.Instance.ChangePanel(eUIPanel.Results);
        GameController.Instance.MenuBackground.SetActive(true);
    }

    public override void PopState()
    {
        OnEnd();
    }

    protected override void OnEnd()
    {
        base.OnEnd();
    }
}
