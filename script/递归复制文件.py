import os
import glob

# 删除指定后缀的文件
# tail = input('输入指定后缀')
# path ='D:\\PycharmProjects\\mypython'
# for infile in glob.glob(os.path.join(path, '*.'+tail)):
# while(True):
#     path = input('输入文件目录路径')
#     for infile in glob.glob(os.path.join(path, '*.json')):
#         os.remove(infile) # 删除指定文件

root = input('输入文件目录路径: ')
# 更改文件下所有文件的后缀名
def changename(rootPath):
    listDir = os.listdir(rootPath)
    for i in range(0, len(listDir)):
        path = os.path.join(rootPath, listDir[i])
        if os.path.isdir(path):
            changename(path)
        else:
            # print(path)
            title, ext = os.path.splitext(os.path.basename(path))
            if ext == '.yml':
                os.rename(path, os.path.join(rootPath, title + '.json'))
            # print('title: ', title, 'ext: ', ext ,'\n')

copyPath = input('输入copy文件目录路径: ')
# 拷贝文件夹下所有文件到另外一个文件夹，并更改文件的扩展名
def copyfile(rootPath, makeDir):
    if not os.path.exists(makeDir):
        os.mkdir(makeDir)
    listDir = os.listdir(rootPath)
    for i in range(0, len(listDir)):
        path = os.path.join(rootPath, listDir[i])
        tempath = os.path.join(makeDir, listDir[i])
        if os.path.isdir(path):
            print(tempath)
            copyfile(path, tempath)
        else:
            with open(path, 'r', encoding='UTF-8') as f1:
                with open(tempath + '.config', 'w', encoding='UTF-8') as f2:
                    for line in f1.readlines():
                        f2.write(line)

if __name__ == "__main__":
    # changename(rootPath)
    copyfile(root, copyPath)