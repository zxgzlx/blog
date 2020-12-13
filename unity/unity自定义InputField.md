####  需求是自定义输入类型和区分输入文本字节类型
```c#
using UnityEngine.UI;

public class UIInput : InputField
{
    private InputField mInputField;

    protected override void Awake()
    {
        mInputField = gameObject.GetComponent<InputField>();
        mInputField.onValueChanged.AddListener(OnCheckStr);
    }
    // 中文使用2个字节检测，英文使用1个字节
    public void OnCheckStr(string str)
    {
        string outPutString = "";
        int count = 0;
        for (int i = 0; i < str.Length; i++)
        {
            char ch = str[i];
            if (ch >= 0x4e00 && ch <= 0x9fa5)
            {
                count += 2;
            }
            if (ch >= 'A' && ch <= 'Z')
            {
                count += 1;
            }
            if (ch >= 'a' && ch <= 'z')
            {
                count += 1;
            }
            if (ch >= '0' && ch <= '9')
            {
                count += 1;
            }
            if (count <= characterLimit)
            {
                outPutString += str[i];
            }
            else
            {
                mInputField.text = outPutString;
                return;
            }
        }
        mInputField.text = outPutString;
    }
	// 重新Append方法,自定义输入的文本类型
    protected override void Append(char input)
    {
        base.Append(CusValidate(input));
    }
    private char CusValidate(char ch)
    {
        if (ch >= 0x4e00 && ch <= 0x9fa5)
        {
            return ch;//这个主要是汉字的范围  
        }
        if (ch >= 'A' && ch <= 'Z') 
        { 
            return ch; 
        }
        if (ch >= 'a' && ch <= 'z')
        {
            return ch;
        }
        if (ch >= '0' && ch <= '9')
        {
            return ch;
        }

        return '\0';
    }
}
```

