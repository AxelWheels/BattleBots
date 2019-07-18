using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GlowObjectCmd : MonoBehaviour
{
    public Renderer[] Renderers
    {
        get;
        private set;
    }

    public Color CurrentColor
    {
        get { return m_CurrentColour; }
    }

    private Color m_CurrentColour;
    private Color m_TargetColour;

    void Start()
    {
        enabled = true;

        m_TargetColour = GetComponentInParent<PlayerController>().PlayerColour.PColour;

        Renderers = GetComponentsInChildren<Renderer>();

        for (int i = 0; i < Renderers.Length; i++)
        {
            if (Renderers[i].GetType() == typeof(ParticleSystemRenderer))
            {
                List<Renderer> lRenderersList = Renderers.ToList();
                lRenderersList.Remove(lRenderersList[i]);

                Renderers = lRenderersList.ToArray();

                //There's only one particle system we're looking for so we can break - Not really great for modular code but in this instance we should ignore that in favour of optimisation
                break;
            }
        }
    }

    private void OnEnable()
    {
        if (GlowController.Instance != null)
        {
            GlowController.Instance.RegisterObject(this);
        }
    }

    private void OnDisable()
    {
        if (GlowController.Instance != null)
        {
            GlowController.Instance.DeregisterObject(this);
        }
    }

    /// <summary>
    /// Update color.
    /// </summary>
    private void Update()
    {
        m_CurrentColour = m_TargetColour;
    }
}
