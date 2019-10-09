using UnityEngine;

/// <summary>
/// Toggles the selected component using the key selected in the inspector
/// </summary>
/// 
/// Daniel Beard
/// 
public class ComponentToggle : MonoBehaviour
{
    [SerializeField] private Behaviour component = null;

    [SerializeField] private KeyCode keyTopress = KeyCode.None;

    private void Update()
    {
        if (Input.GetKeyDown(keyTopress))
        {
            component.enabled = !component.enabled;
        }
    }
}
