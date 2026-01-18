---
name: emits-option
description: 新增 emits 选项，用于声明组件触发的事件
---



# 迁移规则概览



## 迁移规则1：使用 emits 选项声明事件

- Vue2: 不需要声明组件触发的事件
- Vue3: 使用 emits 选项声明

### 代码示例

```vue
<!-- Vue2 写法 -->
<template>
  <div>
    <p>{{ text }}</p>
    <button @click="$emit('accepted')">OK</button>
  </div>
</template>
<script>
export default {
  props: ['text']
}
</script>

<!-- Vue3 写法 -->
<template>
  <div>
    <p>{{ text }}</p>
    <button @click="$emit('accepted')">OK</button>
  </div>
</template>
<script>
export default {
  props: ['text'],
  emits: ['accepted']
}
</script>
```

## 迁移规则2：emits 选项对象形式（带验证）

- Vue2: 无法验证事件参数
- Vue3: emits 支持对象形式，可验证参数

### 代码示例

```javascript
// Vue3 写法
export default {
  emits: {
    click: (payload) => {
      // 验证参数
      if (payload && typeof payload !== 'string') {
        console.warn('Click payload must be a string')
        return false
      }
      return true
    },
    submit: null // 简单声明
  }
}
```

## 迁移规则3：未声明事件绑定到根元素

- Vue2: 事件监听器只通过 $emit 触发
- Vue3: 未在 emits 声明的事件监听器自动绑定到根元素

### 代码示例

```html
<!-- 父组件 -->
<my-button @click="handleClick"></my-button>

<!-- Vue2 写法 -->
<!-- 需要使用 .native 添加原生事件 -->
<my-button @click.native="handleClick"></my-button>

<!-- Vue3 写法 -->
<!-- Button.vue -->
<template>
  <button @click="$emit('click', $event)">OK</button>
</template>
<script>
export default {
  emits: [] // 不声明，@click 会绑定到根元素
}
</script>
```
