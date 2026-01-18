---
name: functional-components
description: 函数式组件变化，移除 functional 选项，函数式组件接收 props 和 context
---



# 迁移规则概览



## 迁移规则1：移除 functional 选项

- Vue2: 使用 { functional: true } 定义函数式组件
- Vue3: 函数式组件是普通函数，无需 functional 选项

### 代码示例

```javascript
// Vue2 写法
export default {
  functional: true,
  props: ['level'],
  render(h, { props, data, children }) {
    return h(`h${props.level}`, data, children)
  }
}

// Vue3 写法
import { h } from 'vue'

const DynamicHeading = (props, context) => {
  return h(`h${props.level}`, context.attrs, context.slots)
}

DynamicHeading.props = ['level']
export default DynamicHeading
```

## 迁移规则2：SFC 中移除 functional attribute

- Vue2: <template functional> 定义函数式组件
- Vue3: 移除 functional，改为普通组件

### 代码示例

```html
<!-- Vue2 写法 -->
<template functional>
  <component
    :is="`h${props.level}`"
    v-bind="attrs"
    v-on="listeners"
  />
</template>

<script>
export default {
  props: ['level']
}
</script>

<!-- Vue3 写法 -->
<template>
  <component
    :is="`h${$props.level}`"
    v-bind="$attrs"
  />
</template>

<script>
export default {
  props: ['level']
}
</script>
```

## 迁移规则3：函数式组件参数变更

- Vue2: render 函数接收 h、context
- Vue3: 函数式组件接收 props、context

### 代码示例

```javascript
// Vue2 写法
export default {
  functional: true,
  render(h, { props, children, slots, data, listeners, parent }) {
    return h('div', {
      attrs: data.attrs,
      on: listeners
    }, children)
  }
}

// Vue3 写法
import { h } from 'vue'

export default (props, { attrs, slots, emit, expose }) => {
  return h('div', attrs, slots.default ? slots.default() : [])
}
```

## 迁移规则4：h 函数需要全局导入

- Vue2: h 函数作为 render 函数的第一个参数传入
- Vue3: 需要从 'vue' 显式导入 h 函数

### 代码示例

```javascript
// Vue2 写法
export default {
  functional: true,
  render(h, { props }) {
    return h('div', props.text)
  }
}

// Vue3 写法
import { h } from 'vue'

const MyComponent = (props) => {
  return h('div', props.text)
}

export default MyComponent
```

## 迁移规则5：SFC 中 props 需要改为 $props

- Vue2: 函数式模板中直接使用 props
- Vue3: 改为使用 $props

### 代码示例

```html
<!-- Vue2 写法 -->
<template functional>
  <div>{{ props.text }}</div>
</template>

<!-- Vue3 写法 -->
<template>
  <div>{{ $props.text }}</div>
</template>
```

## 迁移规则6：listeners 已合并到 $attrs 中

- Vue2: 使用 v-bind="attrs" v-on="listeners"
- Vue3: listeners 已合并到 $attrs，可以删除

### 代码示例

```html
<!-- Vue2 写法 -->
<template functional>
  <component
    v-bind="attrs"
    v-on="listeners"
  />
</template>

<!-- Vue3 写法 -->
<template>
  <component
    v-bind="$attrs"
  />
</template>
```
