public abstract class GameStateBase
{
    public delegate void OnBeginEvent();
    public delegate void OnEndEvent();

    public event OnBeginEvent Begin;
    public event OnEndEvent End;

    protected virtual void OnBegin()
    {
        if (Begin != null)
        {
            Begin();
        }
    }

    public abstract void PushState();

    protected virtual void OnEnd()
    {
        if (End != null)
        {
            End();
        }
    }

    public abstract void PopState();
}
