### UGUI基础学习

####  ScrollRect + VerticalLayoutGroup

1. 新建ScrollRect
2. 再ScrollRect下面新建VerticalLayoutGroup
3. VerticalLayoutGroup添加组件ContentSizeFitter（VerticalFit-PreferredSize），这么做的目的是自适应VerticalLayoutGroup高度，否则超出后不自动更新高度，需要手动计算高度。

#### Toggle、Button等监听事件添加

```c#
using UnityEngine;
using UnityEngine.UI;

public class NewBehaviourScript : MonoBehaviour
{
    [SerializeField]
    private Toggle[] mToggles;

    private void Awake()
    {
        foreach(var toggle in mToggles)
        {
            toggle.onValueChanged.RemoveAllListeners();
            toggle.onValueChanged.AddListener((bool value) => onToggle(toggle, value));
        }
        mToggles[0].isOn = false;
        mToggles[0].isOn = true;
    }

    private void onToggle(Toggle toggle, bool value)
    {
        if (value)
            Debug.Log(" toggle change" + toggle.gameObject.name);
    }
}
```

