# ARPG-Village

This is a ARPG game demo called Village. Using Godot Engine.

Godot Version = 4.2

### 项目说明
- 该项目于学习Godot教程时创建，用于记录学习过程，包含代码的关键注释，以及 Godot 4 相对于 Godot 3 改变的解决方法
- 原作者教程视频： https://www.youtube.com/watch?v=mAbG8Oi-SvQ
- 在此感谢原作者的付出，教程非常好
  
### 提交记录
* feat: 新增摄像机边界，角色移动边界
* feat: p22 新增音效，闪烁效果，fix: 修复角色受到固定伤害，而不是hitbox传过来的伤害的问题
* feat: p21 新增敌人空闲时移动AI
* feat: p20 添加摄像机随角色移动，fix: 修复血量UI不随摄像机移动的问题，修复角色死亡后摄像机归位的问题
* feat: p19 给敌人增加软碰撞
* feat: p18 引入树，给玩家/bush添加影子
* feat: p18 新增生命值UI
* fix: 更改hurtbox的实现方式，增加攻击之后的延迟，解决collision重叠时无法触发攻击的问题
* feat: p17 角色属性创建为全局自动加载单例，新增敌人攻击角色（hitbox，hurtbox）
* feat: p16 新增玩家检测区域，新增敌人状态机，新增敌人追逐AI
* fix: 修复草上也有打击动画的问题
* feat: p16 新增打击特效
* fix: 添加特效采用用其父节点生成子节点的方法，修复草特效出现在角色上层的问题，添加敌人死亡动画
* fix: 将load改为preload
* feat: p15 将base_effect.tscn抽离成一个抽象的scene（称为模板），若要使用模板，其脚本采用继承的方式，继承effect.gd
* fix: 修复游戏开始时动作方向与朝向不同的问题，将AniTree中不同动作的初始指向统一（这里设置为向下）
* feat: p14 新增敌人属性（血量），创建角色伤害继承关系
* feat: p13 新建敌人bat，设置hurtbox，添加受打击后的击退效果
* feat: p12 新增翻滚动作
* feat: p11 更改碰撞检测层，使Hurtbox只处于Hitbox能够碰撞的层，同时更改场景的碰撞层级关系
* feat: p11 新增hurtbox和hitbox，并让hurtbox随角色方向旋转
* feat: p10 新增草消失动画，创建动画结束信号关联，实时实例化特效节点
* feat: p9 新增攻击动画，新增简单的状态机
* feat: p8 新增有碰撞体的TileMap
* feat: p7 TileMap设置，背景设置，路径地形绘制
* feat: p6 建立动画树，关联方向动画
* feat: p5 新建动画
* feat: p4 y sort 确定层级
* feat: p3 创建角色碰撞体，场景碰撞面积

### 问题记录
- p20: Godot 3 中似乎存在每次运行游戏时，随机数种子不变的问题，解决方法是在任意位置调用`randomize()`方法， 但 Godot 4 中似乎不存在这个问题
- p21: Godot 加载同源资源的时候会共享该资源，因此，当制作闪烁动画的时候，当一个bat闪烁，其他也会闪烁，这个问题可以通过设置`meterial/Resource/Local to Scene`实现独立单例
