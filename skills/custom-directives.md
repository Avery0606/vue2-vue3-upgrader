---
name: custom-directives
description: 自定义指令生命周期钩子重命名，与组件生命周期保持一致
---



# 迁移规则概览



## 迁移规则1：指令钩子重命名

- Vue2: 使用 bind、inserted、update、componentUpdated、unbind
- Vue3: 使用 beforeMount、mounted、beforeUpdate、updated、beforeUnmount、unmounted

### 代码示例

```javascript
// Vue2 写法
Vue.directive('highlight', {
  bind(el, binding) {
    el.style.background = binding.value
  },
  inserted(el) {
    el.focus()
  },
  update(el, binding) {
    el.style.background = binding.value
  },
  componentUpdated(el) {
    // 组件和子级更新后
  },
  unbind(el) {
    // 移除指令
  }
})

// Vue3 写法
const app = createApp({})
app.directive('highlight', {
  created(el, binding) {
    // 元素属性应用前调用
  },
  beforeMount(el, binding) {
    el.style.background = binding.value
  },
  mounted(el, binding) {
    el.focus()
  },
  beforeUpdate(el, binding) {
    // 元素更新前调用
  },
  updated(el, binding) {
    el.style.background = binding.value
  },
  beforeUnmount(el) {
    // 元素卸载前调用
  },
  unmounted(el) {
    // 元素卸载后调用
  }
})
```

## 迁移规则2：访问组件实例方式变更

- Vue2: 通过 vnode.context 访问组件实例
- Vue3: 通过 binding.instance 访问组件实例

### 代码示例

```javascript
// Vue2 写法
Vue.directive('my-directive', {
  bind(el, binding, vnode) {
    const vm = vnode.context
    console.log(vm.someData)
  }
})

// Vue3 写法
app.directive('my-directive', {
  mounted(el, binding, vnode) {
    const vm = binding.instance
    console.log(vm.someData)
  }
})
```

## 迁移规则3：移除 update 钩子

- Vue2: 使用 update 钩子在元素更新时触发
- Vue3: 移除 update，统一使用 updated

### 代码示例

```javascript
// Vue2 写法
Vue.directive('color', {
  bind(el, binding) {
    el.style.color = binding.value
  },
  update(el, binding) {
    // 元素更新时，子元素尚未更新
    el.style.color = binding.value
  },
  componentUpdated(el, binding) {
    // 组件和子级都更新后
  }
})

// Vue3 写法
app.directive('color', {
  beforeMount(el, binding) {
    el.style.color = binding.value
  },
  beforeUpdate(el, binding) {
    // 元素更新前调用（新增）
  },
  updated(el, binding) {
    // 元素更新后调用
    el.style.color = binding.value
  }
})
```
