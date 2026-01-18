---
name: vnode-lifecycle-events
description: VNode 生命周期事件前缀变更，从 hook: 改为 vue:
---



# 迁移规则概览



## 迁移规则1：事件前缀变更

- Vue2: 使用 @hook: 前缀监听生命周期事件
- Vue3: 使用 @vue: 前缀监听生命周期事件

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <child-component @hook:updated="onUpdated">
  </template>
</template>

<script>
export default {
  methods: {
    onUpdated() {
      console.log('Component updated')
    }
  }
}
</script>

<!-- Vue3 写法 -->
<template>
  <child-component @vue:updated="onUpdated">
  </template>
</template>

<script>
export default {
  methods: {
    onUpdated() {
      console.log('Component updated')
    }
  }
}
</script>
```

## 迁移规则2：生命周期钩子名称变更

- Vue2: beforeDestroy、destroyed
- Vue3: beforeUnmount、unmounted

### 代码示例

```html
<!-- Vue2 写法 -->
<child-component @hook:beforeDestroy="onBeforeDestroy" />

<!-- Vue3 写法 -->
<child-component @vue:beforeUnmount="onBeforeUnmount" />
```

## 迁移规则3：生命周期事件也可用于 HTML 元素

- Vue2: 生命周期事件只能用于组件
- Vue3: 生命周期事件也可用于 HTML 元素，和组件上的用法一样

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <child-component @hook:updated="onUpdated">
</template>

<!-- Vue3 写法 -->
<template>
  <!-- 组件上使用 -->
  <child-component @vue:updated="onUpdated" />

  <!-- HTML 元素上也可以使用 -->
  <div @vue:updated="onUpdated" />
</template>
```
