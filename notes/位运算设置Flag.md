```python
# 位运算在游戏多种状态时的应用
# 坏处1、不理解的人会造成代码无法维护
# 坏处2、不易调试Bug
# 提醒：慎用，小心被打
# 好处1、代码简单明了，思路清晰，就像系统设置权限一样，和chmod的用法类似
# 好处2、了解了解位运算，一些算法可以使用为运算，暂时不表

# 1&1 = 1、1&0 = 0、0&0 = 0
# 1 | 1 = 1、1 | 0 = 1、0 | 0 = 0
# 1 ^ 1 = 0、1 ^ 0 = 1、0 ^ 0 = 0
# 十进制 ~x = -(x+1), 二进制 ~1 = 0, ~0 = 1
# 按位异或满足交换律，即a ^ b = b ^ a
# 按位异或满足结合律，即(a^b)^c=a^(b^c)
# 任何数与0异或都等于它自己，比如a ^ 0 = a。即 a ^ a = 0

class Flag:
    # 1000 0000
    # 0100 0000
    # 通过位运算设置每个位置的状态分别代替True和False
    # 位运算每个位置代表一个开关，例如第一位为1表示发生碰撞为0表示未碰撞，第二位为1表示得分未得分
    FLAG_WALL = 1 << 7
    FLAG_GOAL = 1 << 6

    def __init__(self):
        self.flag = 0

    # 通过&核对要判断的位置是否为置为1，这里参数可以设置为f | f1 | f2这种组合状态
    def check(self, f):
        return (self.flag & f) != 0

    # 通过|设置位置状态，这里参数可以设置为f | f1 | f2这种组合状态
    def set(self, f):
        self.flag = self.flag | f

    # 通过reset重置某个位置的状态，这里参数可以设置为f | f1 | f2这种组合状态
    def reset(self, f):
        self.flag = self.flag & (~f)

    def print(self):
        print(self.flag)


if __name__ == '__main__':
    flag = Flag()
    flag.set(Flag.FLAG_WALL | Flag.FLAG_GOAL)
    flag.print()
    print(flag.check(Flag.FLAG_WALL))
    print(flag.check(Flag.FLAG_GOAL))
    print(flag.check(Flag.FLAG_WALL | Flag.FLAG_GOAL))
    flag.print()

```

