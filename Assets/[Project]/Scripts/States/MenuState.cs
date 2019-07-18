/// <summary>
/// A class that controls the main menu during that state of the game
/// </summary>
/// 
/// Daniel Beard
///
public class MenuState : GameStateBase
{
    public override void PushState()
    {
        OnBegin();
    }

    protected override void OnBegin()
    {
        base.OnBegin();

        GameController.Instance.MenuBackground.SetActive(true);

        ArenaController.Instance.UnloadArena();

        UIController.Instance.ChangePanel(eUIPanel.Menu);
    }
    public override void PopState()
    {
        OnEnd();
    }

    protected override void OnEnd()
    {
        base.OnEnd();

        GameController.Instance.MenuBackground.SetActive(false);
    }
}
