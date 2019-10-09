public abstract class GameStateBase
{
    public delegate void OnBeginEvent();
    public delegate void OnEndEvent();

    public event OnBeginEvent Begin;
    public event OnEndEvent End;

    protected virtual void OnBegin()
    {
        Begin?.Invoke();
    }

    public abstract void PushState();

    protected virtual void OnEnd()
    {
        End?.Invoke();
    }

    public abstract void PopState();
}
