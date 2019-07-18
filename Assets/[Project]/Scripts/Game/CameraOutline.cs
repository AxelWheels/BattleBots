using UnityEngine;

public class CameraOutline : MonoBehaviour
{
    [SerializeField]
    private Camera m_Camera;

    [SerializeField]
    private Shader m_OutlineShader;
    [SerializeField]
    private Shader m_SilhouetteShader;

    [SerializeField]
    private RenderTexture m_TempRenderTexture;

    private Camera m_TempCamera;
    private Material m_PostMaterial;

    private void Start()
    {
        if (m_Camera == null)
        {
            m_Camera = GetComponent<Camera>();
        }

        m_TempCamera = new GameObject().AddComponent<Camera>();
        m_TempCamera.name = "Outline Camera";

        m_TempCamera.enabled = false;

        m_PostMaterial = new Material(m_OutlineShader);
    }

    private void OnRenderImage(RenderTexture lSource, RenderTexture lDestination)
    {
        if (m_Camera != null)
        {
            m_TempCamera.CopyFrom(m_Camera);
            m_TempCamera.clearFlags = CameraClearFlags.Color;
            m_TempCamera.backgroundColor = Color.black;

            m_TempCamera.cullingMask = 1 << LayerMask.NameToLayer("Outline");

            m_TempRenderTexture = new RenderTexture(lSource.width, lSource.height, 0, RenderTextureFormat.R8);
            m_TempRenderTexture.Create();

            m_TempCamera.targetTexture = m_TempRenderTexture;

            m_TempCamera.RenderWithShader(m_SilhouetteShader, "");

            m_PostMaterial.SetTexture("_SceneTex", lSource);

            Graphics.Blit(m_TempRenderTexture, lDestination, m_PostMaterial);

            m_TempRenderTexture.Release();
        }
        else
        {
            Debug.LogWarning("[OutlineRenderer] Camera was null. Has the camera moved in the hierarchy?");

            m_Camera = GetComponent<Camera>();
        }
    }
}
