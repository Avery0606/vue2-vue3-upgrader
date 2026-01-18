---
name: key-attribute
description: key attribute 变化，v-if/v-else 分支自动生成 key，v-for 的 key 放在 template 上
---



# 迁移规则概览



## 迁移规则1：v-if/v-else 分支 key 不再必需

- Vue2: 建议为 v-if/v-else 分支设置 key
- Vue3: 自动生成唯一 key，不需要设置

### 代码示例

```html
<!-- Vue2 写法 -->
<div v-if="condition" key="yes">Yes</div>
<div v-else key="no">No</div>

<!-- Vue3 写法 -->
<!-- 不需要 key，自动生成 -->
<div v-if="condition">Yes</div>
<div v-else>No</div>
```

## 迁移规则2：手动 key 必须唯一

- Vue2: 可以使用相同 key 强制重用分支
- Vue3: 每个分支必须使用唯一 key

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- 使用相同 key 强制重用 -->
<div v-if="condition" key="a">Yes</div>
<div v-else key="a">No</div>

<!-- Vue3 写法 -->
<!-- 移除 key 或确保唯一 -->
<div v-if="condition">Yes</div>
<div v-else>No</div>

<!-- 或者使用唯一 key -->
<div v-if="condition" key="a">Yes</div>
<div v-else key="b">No</div>
```

## 迁移规则3：template v-for 的 key 位置

- Vue2: key 放在子节点上
- Vue3: key 放在 template 标签上

### 代码示例

```html
<!-- Vue2 写法 -->
<template v-for="item in list">
  <div :key="'heading-' + item.id">...</div>
  <span :key="'content-' + item.id">...</span>
</template>

<!-- Vue3 写法 -->
<template v-for="item in list" :key="item.id">
  <div>...</div>
  <span>...</span>
</template>
```
