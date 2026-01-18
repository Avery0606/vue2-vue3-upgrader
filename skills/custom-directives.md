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

## 迁移规则4：移除 binding.expression

- Vue2: binding 对象包含 expression 属性，包含指令的表达式字符串
- Vue3: binding 对象不再包含 expression 属性

### 代码示例

```javascript
// Vue2 写法
Vue.directive('my-directive', {
  bind(el, binding) {
    console.log(binding.expression)
  }
})

// Vue3 写法
app.directive('my-directive', {
  mounted(el, binding) {
    // binding 对象中不再包含 expression 属性
  }
})
```

## 迁移规则5：多根组件中自定义指令行为

- Vue2: 单根组件，自定义指令正常工作
- Vue3: 多根组件上自定义指令将被忽略并抛出警告

### 代码示例

```vue
<!-- Vue2 写法 -->
<template>
  <div>
    <!-- 单根组件 -->
  </div>
</template>

<script>
export default {
  directives: {
    focus: {
      inserted: el => el.focus()
    }
  }
}
</script>

<!-- Vue3 写法 -->
<template>
  <!-- 多根组件 -->
  <div v-if="condition">...</div>
  <div v-else>...</div>
</template>

<script>
export default {
  directives: {
    focus: {
      mounted: el => el.focus()
    }
  },
  mounted() {
    // 避免在多根组件上使用自定义指令
    // 如果必须使用，确保组件只有一个根节点
  }
}
</script>
```
