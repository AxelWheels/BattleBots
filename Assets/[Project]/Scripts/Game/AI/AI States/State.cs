/// <summary>
/// Abstract class all player/AI states must inherit from.
/// </summary>
/// 
/// Claudiu Gheorghica
///
public abstract class State<T>
{
    public abstract void EnterState(T lOwner);

    public abstract void ExitState(T lOwner);

    public abstract void UpdateState(T lOwner);
}
