---
name: render-function-api
description: 渲染函数 API 变化，h 改为全局导入，VNode prop 结构扁平化
---



# 迁移规则概览



## 迁移规则1：h 函数全局导入

- Vue2: h 作为参数自动传递给渲染函数
- Vue3: h 需要全局导入

### 代码示例

```javascript
// Vue2 写法
export default {
  render(h) {
    return h('div', 'Hello World')
  }
}

// Vue3 写法
import { h } from 'vue'

export default {
  render() {
    return h('div', 'Hello World')
  }
}
```

## 迁移规则2：VNode prop 结构扁平化

- Vue2: 使用嵌套结构（staticClass、domProps、on 等）
- Vue3: 使用扁平结构

### 代码示例

```javascript
// Vue2 写法
{
  staticClass: 'button',
  class: { 'is-outlined': isOutlined },
  staticStyle: { color: '#34495E' },
  style: { backgroundColor: buttonColor },
  attrs: { id: 'submit' },
  domProps: { innerHTML: '' },
  on: { click: submitForm },
  key: 'submit-button'
}

// Vue3 写法
{
  class: ['button', { 'is-outlined': isOutlined }],
  style: [{ color: '#34495E' }, { backgroundColor: buttonColor }],
  id: 'submit',
  innerHTML: '',
  onClick: submitForm,
  key: 'submit-button'
}
```

## 迁移规则3：组件注册和引用

- Vue2: 可以通过字符串 ID 引用组件
- Vue3: 需要使用 resolveComponent 引用组件

### 代码示例

```javascript
// Vue2 写法
Vue.component('button-counter', {
  template: '<button @click="count++">Clicked {{ count }} times.</button>'
})

export default {
  render(h) {
    return h('button-counter')
  }
}

// Vue3 写法
import { h, resolveComponent } from 'vue'

export default {
  setup() {
    const ButtonCounter = resolveComponent('button-counter')
    return () => h(ButtonCounter)
  }
}
```
