/// <summary>
/// A class that controls AI/player states.
/// </summary>
/// 
/// Claudiu Gheorghica
///
public class StateMachine<T>
{
    private State<T> m_CurrentState;
    private T m_Owner;

    #region Properties
    public State<T> CurrentState
    {
        get
        {
            return m_CurrentState;
        }

        private set
        {
            m_CurrentState = value;
        }
    }

    public T Owner
    {
        get
        {
            return m_Owner;
        }

        set
        {
            m_Owner = value;
        }
    }
    #endregion

    public StateMachine(T lOwner)
    {
        m_Owner = lOwner;
        m_CurrentState = null;
    }

    public void ChangeState(State<T> lNewState)
    {
        if (m_CurrentState != null)
        {
            m_CurrentState.ExitState(m_Owner);
        }
        m_CurrentState = lNewState;
        m_CurrentState.EnterState(m_Owner);
    }

    //To be ran in Unity's Update function
    public void Update()
    {
        if (m_CurrentState != null)
        {
            m_CurrentState.UpdateState(m_Owner);
        }
    }
}
