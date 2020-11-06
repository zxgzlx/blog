#### DOTween学习

> 下面是一下DOTween的一些用法使用

```c#
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class NewBehaviourScript : MonoBehaviour
{
    [SerializeField]
    private Text m_Text;
    
    private Sequence mScoreSequence;
    private int mOldScore = 0;
    private int newScore = 0;

    private void Awake()
    {
        mScoreSequence = DOTween.Sequence();
        mScoreSequence.SetAutoKill(false);
    }
    // Start is called before the first frame update
    void Start()
    {
        //DOTween.To(() => value, x => value = x, new Vector3(10, 10, 0), 2); 获取插值的值，下面有滚动计数器的实例
        //m_Text.DOText("这个游戏好玩吗", 2);
        //m_Text.DOColor(Color.red, 2);
        //Camera.main.transform.DOShakePosition(1, 0.5f);
        //transform.DOMoveX(5, 1).From();
        //transform.DOMoveX(5, 1).SetEase(Ease.InOutBack).SetLoops(2).OnStart(() => {
        //    Debug.Log("开始了");
        //}).OnComplete(() => {
        //    Debug.Log("结束了End");
        //});
        //m_Text.DOFade(1, 10);
        DigitalAnimation();
    }

    void DigitalAnimation()
    {
        // 滚动计数器
        //mScoreSequence.Append(DOTween.To((value) =>
        //{
        //    var temp = Mathf.Floor(value);
        //    m_Text.text = temp + "";
        //}, mOldScore, newScore, 0.4f));
        //mOldScore = newScore;

        // 模拟洗牌过程
        mScoreSequence.Append(transform.DOMoveX(5, 1));
        mScoreSequence.Append(transform.DOMoveX(0, 1));
        mScoreSequence.Append(transform.DOMoveX(-5, 1));
        mScoreSequence.Append(transform.DOMoveX(0, 1));
        mScoreSequence.SetLoops(10);
        DOTween.Sequence().Append(mScoreSequence).AppendCallback(() => { Debug.Log("结束了"); });

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            newScore += 1024;
            DigitalAnimation();
        }
    }
}
```



#### DOTween翻牌动画

```c#
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum CardState
{
    Front,
    Back
}
public class Flip : MonoBehaviour
{
    public GameObject mFront;
    public GameObject mBack;
    public CardState mCardState = CardState.Front;
    public float mTime = 0.3f;
    private bool isActive = false; // true正在执行动画
    // Start is called before the first frame update
    void Start()
    {
        Init();
    }
    /// <summary>
    /// 初始化卡牌角度，根据mCardState
    /// </summary>
    public void Init()
    {
        if (mCardState == CardState.Front)
        {
            //如果是从正面开始，则将背面旋转90度，这样就看不见背面了
            mFront.transform.eulerAngles = Vector3.zero;
            mBack.transform.eulerAngles = new Vector3(0, 90, 0);
        }
        else
        {
            //从背面开始，同理
            mFront.transform.eulerAngles = new Vector3(0, 90, 0);
            mBack.transform.eulerAngles = Vector3.zero;
        }
    }
    /// <summary>
    /// 留给外界调用的接口
    /// </summary>
    public void StartBack()
    {
        if (isActive)
        {
            return;
        }
        //StartCoroutine(ToFront());
        FlipToFront();
    }
    /// <summary>
    /// 留给外界调用的接口
    /// </summary>
    public void StartFront()
    {
        if (isActive)
        {
            return;
        }
        //StartCoroutine(ToBack());
        FlipToBack();
    }
    /// <summary>
    /// 翻转到背面
    /// </summary>
    private void FlipToBack()
    {
        isActive = true;
        DOTween.Sequence()
            .Append(mFront.transform.DORotate(new Vector3(0, 90, 0), mTime))
            .Append(mBack.transform.DORotate(new Vector3(0, 0, 0), mTime))
            .AppendCallback(() => { isActive = false; });
    }
    /// <summary>
    /// 翻转到正面
    /// </summary>
    private void FlipToFront()
    {
        isActive = true;
        DOTween.Sequence()
            .Append(mBack.transform.DORotate(new Vector3(0, 90, 0), mTime))
            .Append(mFront.transform.DORotate(Vector3.zero, mTime))
            .AppendCallback(() => { isActive = false; });
    }
    //IEnumerator ToBack()
    //{
    //    isActive = true;
    //    mFront.transform.DORotate(new Vector3(0, 90, 0), mTime);
    //    for (float i = mTime; i >= 0; i -= Time.deltaTime)
    //        yield return 0;
    //    mBack.transform.DORotate(new Vector3(0, 0, 0), mTime);
    //    isActive = false;
    //}
    //IEnumerator ToFront()
    //{
    //    isActive = true;
    //    mBack.transform.DORotate(new Vector3(0, 90, 0), mTime);
    //    for (float i = mTime; i >= 0; i -= Time.deltaTime)
    //    {
    //        yield return 0;
    //    }
    //    mFront.transform.DORotate(Vector3.zero, mTime);
    //    isActive = false;
    //}
}

```

