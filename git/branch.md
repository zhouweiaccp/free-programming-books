** [url](http://blog.csdn.net/googdev/article/details/51880064)

切换到 develop 分支

git checkout develop

如果把以上两步合并，即新建并且自动切换到 develop 分支：

git checkout -b develop

把 develop 分支推送到远程仓库

git push origin develop

如果你远程的分支想取名叫 develop2 ，那执行以下代码：

git push origin develop:develop2

但是强烈不建议这样，这会导致很混乱，很难管理，所以建议本地分支跟远程分支名要保持一致。

查看本地分支列表

git branch

查看远程分支列表

git branch -r

删除本地分支

git branch -d develop

git branch -D develop (强制删除)

删除远程分支

git push origin :develop

如果远程分支有个 develop ，而本地没有，你想把远程的 develop 分支迁到本地：

git checkout develop origin/develop

同样的把远程分支迁到本地顺便切换到该分支：

git checkout -b develop origin/develop