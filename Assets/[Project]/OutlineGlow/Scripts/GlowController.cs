using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

/// <summary>
/// Creates and maintains a command buffer to set up the textures used in the glowing object image effect.
/// </summary>
public class GlowController : SingletonManager<GlowController>
{
    [SerializeField]
    private float m_BlurSize = 1.5f;

    private CommandBuffer m_CommandBuffer;

    private List<GlowObjectCmd> m_GlowableObjects = new List<GlowObjectCmd>();
    private Material m_GlowMaterial;
    private Material m_BlurMaterial;
    private Vector2 m_BlurTexelSize;

    private int m_PrePassRenderTexID;
    private int m_BlurPassRenderTexID;
    private int m_TempRenderTexID;
    private int m_BlurSizeID;
    private int m_GlowColorID;

    /// <summary>
    /// On Awake, we cache various values and setup our command buffer to be called Before Image Effects.
    /// </summary>
    private void Awake()
    {
        m_GlowMaterial = new Material(Shader.Find("Hidden/GlowCmdShader"));
        m_BlurMaterial = new Material(Shader.Find("Hidden/Blur"));

        m_PrePassRenderTexID = Shader.PropertyToID("_GlowPrePassTex");
        m_BlurPassRenderTexID = Shader.PropertyToID("_GlowBlurredTex");
        m_TempRenderTexID = Shader.PropertyToID("_TempTex0");
        m_BlurSizeID = Shader.PropertyToID("_BlurSize");
        m_GlowColorID = Shader.PropertyToID("_GlowColor");

        m_CommandBuffer = new CommandBuffer();
        m_CommandBuffer.name = "Glowing Objects Buffer";
        GetComponent<Camera>().AddCommandBuffer(CameraEvent.BeforeImageEffects, m_CommandBuffer);
    }

    /// <summary>
    /// TODO: Add a degister method.
    /// </summary>
    public void RegisterObject(GlowObjectCmd lGlowObject)
    {
        m_GlowableObjects.Add(lGlowObject);
    }

    public void DeregisterObject(GlowObjectCmd lGlowObject)
    {
        m_GlowableObjects.Remove(lGlowObject);
    }

    /// <summary>
    /// Adds all the commands, in order, we want our command buffer to execute.
    /// Similar to calling sequential rendering methods insde of OnRenderImage().
    /// </summary>
    private void RebuildCommandBuffer()
    {
        m_CommandBuffer.Clear();

        m_CommandBuffer.GetTemporaryRT(m_PrePassRenderTexID, Screen.width, Screen.height, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default, QualitySettings.antiAliasing);
        m_CommandBuffer.SetRenderTarget(m_PrePassRenderTexID);
        m_CommandBuffer.ClearRenderTarget(true, true, Color.clear);

        for (int i = 0; i < m_GlowableObjects.Count; i++)
        {
            m_CommandBuffer.SetGlobalColor(m_GlowColorID, m_GlowableObjects[i].CurrentColor);

            for (int j = 0; j < m_GlowableObjects[i].Renderers.Length; j++)
            {
                m_CommandBuffer.DrawRenderer(m_GlowableObjects[i].Renderers[j], m_GlowMaterial);
            }
        }

        m_CommandBuffer.GetTemporaryRT(m_BlurPassRenderTexID, Screen.width >> 1, Screen.height >> 1, 0, FilterMode.Bilinear);
        m_CommandBuffer.GetTemporaryRT(m_TempRenderTexID, Screen.width >> 1, Screen.height >> 1, 0, FilterMode.Bilinear);
        m_CommandBuffer.Blit(m_PrePassRenderTexID, m_BlurPassRenderTexID);

        m_BlurTexelSize = new Vector2(m_BlurSize / (Screen.width >> 1), m_BlurSize / (Screen.height >> 1));
        m_CommandBuffer.SetGlobalVector(m_BlurSizeID, m_BlurTexelSize);

        for (int i = 0; i < 4; i++)
        {
            m_CommandBuffer.Blit(m_BlurPassRenderTexID, m_TempRenderTexID, m_BlurMaterial, 0);
            m_CommandBuffer.Blit(m_TempRenderTexID, m_BlurPassRenderTexID, m_BlurMaterial, 1);
        }
    }

    /// <summary>
    /// Rebuild the Command Buffer each frame to account for changes in color.
    /// This could be improved to only rebuild when necessary when colors are changing.
    /// 
    /// Could be further optimized to not include objects which are currently black and not
    /// affect thing the glow image.
    /// </summary>
    private void Update()
    {
        RebuildCommandBuffer();
    }
}
