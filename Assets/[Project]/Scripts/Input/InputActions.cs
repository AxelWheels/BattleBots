// GENERATED AUTOMATICALLY FROM 'Assets/[Project]/Scripts/Input/InputActions.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

namespace BattleBots
{
    public class @InputActions : IInputActionCollection, IDisposable
    {
        private InputActionAsset asset;
        public @InputActions()
        {
            asset = InputActionAsset.FromJson(@"{
    ""name"": ""InputActions"",
    ""maps"": [
        {
            ""name"": ""Mech"",
            ""id"": ""d8455c87-4d83-43e5-9c03-9c435ad6e2f5"",
            ""actions"": [
                {
                    ""name"": ""Movement"",
                    ""type"": ""Value"",
                    ""id"": ""7a4b27a3-a051-432d-b8a7-656813cc1a2b"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""LightAttack"",
                    ""type"": ""Button"",
                    ""id"": ""c7c7ee2e-adf8-4f48-b566-2906e5fad476"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Heavy Attack"",
                    ""type"": ""Button"",
                    ""id"": ""9dcec7b3-528f-4edb-8537-fd89165919d4"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Shoot"",
                    ""type"": ""Button"",
                    ""id"": ""dfce95c4-887b-4f1f-a6c3-1f18aae0f0a8"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Dash"",
                    ""type"": ""Button"",
                    ""id"": ""89bb81fb-0cbe-4278-87d6-b960fd40047a"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Block"",
                    ""type"": ""Button"",
                    ""id"": ""9fc7d727-7560-4554-9af9-c829b8cc2354"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""Gamepad"",
                    ""id"": ""dc5b73c6-f183-40bc-a99a-7f597649f153"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""47d0c827-8d07-4acf-a286-230a108514c6"",
                    ""path"": ""<Gamepad>/leftStick/up"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""2def92c8-0e84-4e56-94f2-7ae66053d78d"",
                    ""path"": ""<Gamepad>/leftStick/down"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""1a149b5c-cfa9-45e3-809c-8fea344ed637"",
                    ""path"": ""<Gamepad>/leftStick/left"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""f16af3ac-69ec-481b-bd16-1c4f880542d6"",
                    ""path"": ""<Gamepad>/leftStick/right"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""Keyboard"",
                    ""id"": ""62b62745-a11e-4ce2-8469-edc5d3a299ec"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""2be4e402-f3a1-40a9-a239-8b5adbe34ae6"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""f981633d-8002-4747-a7cb-c96e77a828f7"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""a44c733d-6e7d-40bc-a22b-353bce1bcd57"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""1e74b56a-8560-47f3-b7b9-1707460b45c9"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""b2c69b74-106d-44e3-99ab-4616fb7172f1"",
                    ""path"": ""<Gamepad>/buttonWest"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""LightAttack"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b63dc56e-c448-4c9a-8da8-14118a9a02b2"",
                    ""path"": ""<Keyboard>/space"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""LightAttack"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""2a503c76-84e9-4e20-8896-4714a741cd1e"",
                    ""path"": ""<Gamepad>/rightTrigger"",
                    ""interactions"": ""Press(pressPoint=0.5)"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""dcb892b5-8f36-4c2b-a091-1c318c560b7c"",
                    ""path"": ""<Keyboard>/e"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""c1596735-2e50-4bf3-b51d-188156ba636b"",
                    ""path"": ""<Gamepad>/buttonEast"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Dash"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""1cc6e9fc-b1b8-427f-ad25-3d58547a7002"",
                    ""path"": ""<Keyboard>/q"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Dash"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b0a23228-cbd3-4d93-bc52-666d412329d9"",
                    ""path"": ""<Gamepad>/buttonNorth"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Heavy Attack"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f2d4b524-61af-4eab-b9e2-e2cc671479e3"",
                    ""path"": ""<Keyboard>/p"",
                    ""interactions"": ""Tap"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Heavy Attack"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""ecd2d2c1-3eb6-4979-9d35-fd57ebbf626c"",
                    ""path"": ""<Gamepad>/leftShoulder"",
                    ""interactions"": ""Hold"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Block"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""f4298783-11ce-4dd7-97e9-894c76deaf97"",
                    ""path"": ""<Keyboard>/o"",
                    ""interactions"": ""Hold"",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Block"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        },
        {
            ""name"": ""Pilot"",
            ""id"": ""99e46b11-7eae-450c-9158-512a05fc35dd"",
            ""actions"": [
                {
                    ""name"": ""New action"",
                    ""type"": ""Button"",
                    ""id"": ""0bc0db1e-a723-4035-b2c6-2e96b194fc1e"",
                    ""expectedControlType"": """",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""28f6af70-6f08-40b5-9057-026344930d4f"",
                    ""path"": """",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""New action"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
            // Mech
            m_Mech = asset.FindActionMap("Mech", throwIfNotFound: true);
            m_Mech_Movement = m_Mech.FindAction("Movement", throwIfNotFound: true);
            m_Mech_LightAttack = m_Mech.FindAction("LightAttack", throwIfNotFound: true);
            m_Mech_HeavyAttack = m_Mech.FindAction("Heavy Attack", throwIfNotFound: true);
            m_Mech_Shoot = m_Mech.FindAction("Shoot", throwIfNotFound: true);
            m_Mech_Dash = m_Mech.FindAction("Dash", throwIfNotFound: true);
            m_Mech_Block = m_Mech.FindAction("Block", throwIfNotFound: true);
            // Pilot
            m_Pilot = asset.FindActionMap("Pilot", throwIfNotFound: true);
            m_Pilot_Newaction = m_Pilot.FindAction("New action", throwIfNotFound: true);
        }

        public void Dispose()
        {
            UnityEngine.Object.Destroy(asset);
        }

        public InputBinding? bindingMask
        {
            get => asset.bindingMask;
            set => asset.bindingMask = value;
        }

        public ReadOnlyArray<InputDevice>? devices
        {
            get => asset.devices;
            set => asset.devices = value;
        }

        public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

        public bool Contains(InputAction action)
        {
            return asset.Contains(action);
        }

        public IEnumerator<InputAction> GetEnumerator()
        {
            return asset.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public void Enable()
        {
            asset.Enable();
        }

        public void Disable()
        {
            asset.Disable();
        }

        // Mech
        private readonly InputActionMap m_Mech;
        private IMechActions m_MechActionsCallbackInterface;
        private readonly InputAction m_Mech_Movement;
        private readonly InputAction m_Mech_LightAttack;
        private readonly InputAction m_Mech_HeavyAttack;
        private readonly InputAction m_Mech_Shoot;
        private readonly InputAction m_Mech_Dash;
        private readonly InputAction m_Mech_Block;
        public struct MechActions
        {
            private @InputActions m_Wrapper;
            public MechActions(@InputActions wrapper) { m_Wrapper = wrapper; }
            public InputAction @Movement => m_Wrapper.m_Mech_Movement;
            public InputAction @LightAttack => m_Wrapper.m_Mech_LightAttack;
            public InputAction @HeavyAttack => m_Wrapper.m_Mech_HeavyAttack;
            public InputAction @Shoot => m_Wrapper.m_Mech_Shoot;
            public InputAction @Dash => m_Wrapper.m_Mech_Dash;
            public InputAction @Block => m_Wrapper.m_Mech_Block;
            public InputActionMap Get() { return m_Wrapper.m_Mech; }
            public void Enable() { Get().Enable(); }
            public void Disable() { Get().Disable(); }
            public bool enabled => Get().enabled;
            public static implicit operator InputActionMap(MechActions set) { return set.Get(); }
            public void SetCallbacks(IMechActions instance)
            {
                if (m_Wrapper.m_MechActionsCallbackInterface != null)
                {
                    @Movement.started -= m_Wrapper.m_MechActionsCallbackInterface.OnMovement;
                    @Movement.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnMovement;
                    @Movement.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnMovement;
                    @LightAttack.started -= m_Wrapper.m_MechActionsCallbackInterface.OnLightAttack;
                    @LightAttack.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnLightAttack;
                    @LightAttack.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnLightAttack;
                    @HeavyAttack.started -= m_Wrapper.m_MechActionsCallbackInterface.OnHeavyAttack;
                    @HeavyAttack.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnHeavyAttack;
                    @HeavyAttack.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnHeavyAttack;
                    @Shoot.started -= m_Wrapper.m_MechActionsCallbackInterface.OnShoot;
                    @Shoot.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnShoot;
                    @Shoot.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnShoot;
                    @Dash.started -= m_Wrapper.m_MechActionsCallbackInterface.OnDash;
                    @Dash.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnDash;
                    @Dash.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnDash;
                    @Block.started -= m_Wrapper.m_MechActionsCallbackInterface.OnBlock;
                    @Block.performed -= m_Wrapper.m_MechActionsCallbackInterface.OnBlock;
                    @Block.canceled -= m_Wrapper.m_MechActionsCallbackInterface.OnBlock;
                }
                m_Wrapper.m_MechActionsCallbackInterface = instance;
                if (instance != null)
                {
                    @Movement.started += instance.OnMovement;
                    @Movement.performed += instance.OnMovement;
                    @Movement.canceled += instance.OnMovement;
                    @LightAttack.started += instance.OnLightAttack;
                    @LightAttack.performed += instance.OnLightAttack;
                    @LightAttack.canceled += instance.OnLightAttack;
                    @HeavyAttack.started += instance.OnHeavyAttack;
                    @HeavyAttack.performed += instance.OnHeavyAttack;
                    @HeavyAttack.canceled += instance.OnHeavyAttack;
                    @Shoot.started += instance.OnShoot;
                    @Shoot.performed += instance.OnShoot;
                    @Shoot.canceled += instance.OnShoot;
                    @Dash.started += instance.OnDash;
                    @Dash.performed += instance.OnDash;
                    @Dash.canceled += instance.OnDash;
                    @Block.started += instance.OnBlock;
                    @Block.performed += instance.OnBlock;
                    @Block.canceled += instance.OnBlock;
                }
            }
        }
        public MechActions @Mech => new MechActions(this);

        // Pilot
        private readonly InputActionMap m_Pilot;
        private IPilotActions m_PilotActionsCallbackInterface;
        private readonly InputAction m_Pilot_Newaction;
        public struct PilotActions
        {
            private @InputActions m_Wrapper;
            public PilotActions(@InputActions wrapper) { m_Wrapper = wrapper; }
            public InputAction @Newaction => m_Wrapper.m_Pilot_Newaction;
            public InputActionMap Get() { return m_Wrapper.m_Pilot; }
            public void Enable() { Get().Enable(); }
            public void Disable() { Get().Disable(); }
            public bool enabled => Get().enabled;
            public static implicit operator InputActionMap(PilotActions set) { return set.Get(); }
            public void SetCallbacks(IPilotActions instance)
            {
                if (m_Wrapper.m_PilotActionsCallbackInterface != null)
                {
                    @Newaction.started -= m_Wrapper.m_PilotActionsCallbackInterface.OnNewaction;
                    @Newaction.performed -= m_Wrapper.m_PilotActionsCallbackInterface.OnNewaction;
                    @Newaction.canceled -= m_Wrapper.m_PilotActionsCallbackInterface.OnNewaction;
                }
                m_Wrapper.m_PilotActionsCallbackInterface = instance;
                if (instance != null)
                {
                    @Newaction.started += instance.OnNewaction;
                    @Newaction.performed += instance.OnNewaction;
                    @Newaction.canceled += instance.OnNewaction;
                }
            }
        }
        public PilotActions @Pilot => new PilotActions(this);
        public interface IMechActions
        {
            void OnMovement(InputAction.CallbackContext context);
            void OnLightAttack(InputAction.CallbackContext context);
            void OnHeavyAttack(InputAction.CallbackContext context);
            void OnShoot(InputAction.CallbackContext context);
            void OnDash(InputAction.CallbackContext context);
            void OnBlock(InputAction.CallbackContext context);
        }
        public interface IPilotActions
        {
            void OnNewaction(InputAction.CallbackContext context);
        }
    }
}
