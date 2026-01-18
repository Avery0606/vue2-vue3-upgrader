---
name: slots-unification
description: 插槽统一，this.$slots 现在是函数，移除 this.$scopedSlots
---



# 迁移规则概览



## 迁移规则1：渲染函数中插槽用法变更

- Vue2: 在内容节点上使用 slot 属性，使用 this.$scopedSlots 访问
- Vue3: 在第三个参数中定义插槽，this.$slots 统一包含所有插槽

### 代码示例

```javascript
// Vue2 写法
import { h } from 'vue'

h(LayoutComponent, [
  h('div', { slot: 'header' }, this.header),
  h('div', { slot: 'content' }, this.content)
])

// 访问作用域插槽
this.$scopedSlots.header({ data: 'some-data' })

// Vue3 写法
import { h } from 'vue'

h(LayoutComponent, {}, {
  header: () => h('div', this.header),
  content: () => h('div', this.content)
})

// 访问插槽，统一使用 $slots
this.$slots.header({ data: 'some-data' })
```

## 迁移规则2：移除 $scopedSlots

- Vue2: 使用 this.$scopedSlots 访问作用域插槽
- Vue3: 统一使用 this.$slots，插槽现在都是函数

### 代码示例

```javascript
// Vue2 写法
export default {
  render(h) {
    return h('div', this.$scopedSlots.default({ data: 'hello' }))
  }
}

// Vue3 写法
export default {
  render() {
    return h('div', this.$slots.default({ data: 'hello' }))
  }
}
```
