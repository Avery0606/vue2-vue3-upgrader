---
name: v-bind
description: v-bind 合并行为变化，绑定顺序会影响渲染结果
---



# 迁移规则概览



## 迁移规则1：v-bind 合并顺序行为变更

- Vue2: 独立 attribute 总是覆盖 v-bind="object"
- Vue3: 声明顺序决定合并行为

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- 独立 attribute 总是获胜 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- 结果：<div id="red"></div> -->

<!-- Vue3 写法 -->
<!-- 先声明的被覆盖 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- 结果：<div id="blue"></div> -->

<!-- 独立 attribute 后声明时获胜 -->
<div v-bind="{ id: 'blue' }" id="red"></div>
<!-- 结果：<div id="red"></div> -->
```
