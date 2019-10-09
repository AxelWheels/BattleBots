using UnityEngine;

public class CameraOutline : MonoBehaviour
{
    [SerializeField] private new Camera camera = null;

    [SerializeField] private Shader outlineShader = null;
    [SerializeField] private Shader silhouetteShader = null;

    [SerializeField] private RenderTexture tempRenderTexture = null;

    private Camera tempCamera;
    private Material postMaterial;

    private void Start()
    {
        if (camera == null)
        {
            camera = GetComponent<Camera>();
        }

        tempCamera = new GameObject().AddComponent<Camera>();
        tempCamera.name = "Outline Camera";

        tempCamera.enabled = false;

        postMaterial = new Material(outlineShader);
    }

    private void OnRenderImage(RenderTexture lSource, RenderTexture lDestination)
    {
        if (camera != null)
        {
            tempCamera.CopyFrom(camera);
            tempCamera.clearFlags = CameraClearFlags.Color;
            tempCamera.backgroundColor = Color.black;

            tempCamera.cullingMask = 1 << LayerMask.NameToLayer("Outline");

            tempRenderTexture = new RenderTexture(lSource.width, lSource.height, 0, RenderTextureFormat.R8);
            tempRenderTexture.Create();

            tempCamera.targetTexture = tempRenderTexture;

            tempCamera.RenderWithShader(silhouetteShader, "");

            postMaterial.SetTexture("_SceneTex", lSource);

            Graphics.Blit(tempRenderTexture, lDestination, postMaterial);

            tempRenderTexture.Release();
        }
        else
        {
            Debug.LogWarning("[OutlineRenderer] Camera was null. Has the camera moved in the hierarchy?");

            camera = GetComponent<Camera>();
        }
    }
}
