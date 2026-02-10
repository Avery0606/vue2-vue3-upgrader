# Vue3 迁移清单

基于官方 Vue.js 3 迁移指南：https://v3-migration.vuejs.org/zh/breaking-changes/

## 1. 全局 API 变更

### 1.1 createApp（关键）

```javascript
// Vue 2
const app = new Vue({ /* 根选项 */ })

// Vue 3
import { createApp } from 'vue'
const app = createApp({ /* 根选项 */ })
```

### 1.2 组件注册

```javascript
// Vue 2
Vue.component('my-component', { /* 选项 */ })

// Vue 3
app.component('my-component', { /* 选项 */ })
```

### 1.3 指令注册

```javascript
// Vue 2
Vue.directive('my-directive', { /* 选项 */ })

// Vue 3
app.directive('my-directive', { /* 选项 */ })
```

### 1.4 插件安装

```javascript
// Vue 2
Vue.use(router)

// Vue 3
app.use(router)
```

### 1.5 Mixin

```javascript
// Vue 2
Vue.mixin({ /* 选项 */ })

// Vue 3
app.mixin({ /* 选项 */ })
```

### 1.6 Prototype

```javascript
// Vue 2
Vue.prototype.$http = axios

// Vue 3
app.config.globalProperties.$http = axios
```

### 1.7 Config

```javascript
// Vue 2
Vue.config.productionTip = false

// Vue 3
app.config.productionTip = false
```

### 1.8 Mount

```javascript
// Vue 2
app.$mount('#app')

// Vue 3
app.mount('#app')
```

### 1.9 Vue.extend 已移除

```javascript
// Vue 2
const Component = Vue.extend({ /* 选项 */ })

// Vue 3 - 使用 defineComponent
import { defineComponent } from 'vue'
const Component = defineComponent({ /* 选项 */ })

// 或直接在 createApp 中使用选项
```

### 1.10 全局属性

```javascript
// Vue 2 - 在根组件上提供
new Vue({
  provide: { userName: 'John' }
})

// Vue 3 - app.provide
app.provide('userName', 'John')
```

---

## 2. v-model 变更

### 2.1 基础 v-model

```html
<!-- Vue 2 -->
<ChildComponent v-model="pageTitle" />
<!-- 等同于 -->
<ChildComponent :value="pageTitle" @input="pageTitle = $event" />

<!-- Vue 3 -->
<ChildComponent v-model="pageTitle" />
<!-- 等同于 -->
<ChildComponent :modelValue="pageTitle" @update:modelValue="pageTitle = $event" />
```

### 2.2 组件变更

```javascript
// 子组件 - Vue 2
export default {
  props: ['value'],
  model: {
    prop: 'value',
    event: 'input'
  }
}

// 子组件 - Vue 3
export default {
  props: ['modelValue'],
  emits: ['update:modelValue']
}
```

### 2.3 .sync 替换

```html
<!-- Vue 2 -->
<ChildComponent :title.sync="pageTitle" />

<!-- Vue 3 -->
<ChildComponent v-model:title="pageTitle" />
```

### 2.4 多个 v-model

```html
<!-- Vue 3 支持多个 v-model -->
<ChildComponent
  v-model:title="pageTitle"
  v-model:content="pageContent"
/>
```

### 2.5 v-model 修饰符

```html
<!-- Vue 3 支持自定义修饰符 -->
<ChildComponent v-model.capitalize="text" />
```

---

## 3. 事件 API 移除

### 3.1 $on/$off/$once 已移除

```javascript
// Vue 2 - 已移除
this.$on('event', handler)
this.$off('event', handler)
this.$once('event', handler)
```

### 3.2 事件总线替换

```javascript
// 使用 mitt
import mitt from 'mitt'
const emitter = mitt()

// emitter.on(event, handler)
// emitter.off(event, handler)
// emitter.emit(event, data)
```

```javascript
// 使用 tiny-emitter
import tinyEmitter from 'tiny-emitter/instance'

export default {
  $on: (...args) => tinyEmitter.on(...args),
  $off: (...args) => tinyEmitter.off(...args),
  $once: (...args) => tinyEmitter.once(...args),
  $emit: (...args) => tinyEmitter.emit(...args)
}
```

### 3.3 根组件事件

```javascript
// Vue 3
createApp(App, {
  onExpand() {
    console.log('expand')
  }
})
```

---

## 4. v-on.native 已移除

```html
<!-- Vue 2 -->
<ChildComponent @click.native="handleClick" />

<!-- Vue 3 -->
<ChildComponent @click="handleClick" />
```

**注意：** 子组件必须在 `emits` 选项中声明该事件。

---

## 5. Emits 选项

### 5.1 基础用法

```javascript
export default {
  emits: ['click', 'update:value']
}
```

### 5.2 带验证

```javascript
export default {
  emits: {
    click: null,
    update:value: (value) => typeof value === 'string'
  }
}
```

### 5.3 为什么重要

如果没有 emits，事件会穿透到 $attrs 并导致重复事件。

---

## 6. 生命周期钩子

### 6.1 重命名

```javascript
// Vue 2 → Vue 3
beforeDestroy → beforeUnmount
destroyed → unmounted
```

```javascript
// 之前
beforeDestroy() {
  // 清理
}

// 之后
beforeUnmount() {
  // 清理
}
```

---

## 7. 过滤器已移除

### 7.1 过滤器定义

```javascript
// Vue 2
export default {
  filters: {
    currencyUSD(value) {
      return '$' + value
    }
  }
}

// Vue 3 - 已移除
```

### 7.2 替换为方法

```javascript
export default {
  methods: {
    currencyUSD(value) {
      return '$' + value
    }
  }
}
```

### 7.3 替换为计算属性

```javascript
export default {
  props: ['price'],
  computed: {
    formattedPrice() {
      return '$' + this.price
    }
  }
}
```

### 7.4 模板使用

```html
<!-- Vue 2 -->
{{ price | currencyUSD }}

<!-- Vue 3 -->
{{ currencyUSD(price) }}
<!-- 或 -->
{{ formattedPrice }}
```

### 7.5 全局过滤器

```javascript
// main.js - Vue 3
app.config.globalProperties.$filters = {
  currencyUSD(value) {
    return '$' + value
  }
}
```

```html
<!-- 模板使用 -->
{{ $filters.currencyUSD(price) }}
```

---

## 8. 自定义指令

### 8.1 钩子映射

| Vue 2 | Vue 3 | 描述 |
|-------|-------|------------|
| bind | beforeMount | 指令附着时 |
| inserted | mounted | 元素插入 DOM 时 |
| update | 已移除 | 使用 updated |
| componentUpdated | updated | 组件更新后 |
| unbind | unmounted | 指令移除时 |

### 8.2 新钩子

```javascript
export default {
  created(el, binding, vnode) {
    // 新！属性应用之前
  },
  beforeMount() {
    // 新！元素挂载之前
  },
  mounted() {},
  beforeUpdate() {
    // 新！元素更新之前
  },
  updated() {},
  beforeUnmount() {
    // 新！元素卸载之前
  },
  unmounted() {}
}
```

### 8.3 binding.expression 已移除

```javascript
// Vue 2
directives: {
  highlight: {
    bind(el, binding, vnode) {
      console.log(binding.expression) // 已移除
    }
  }
}

// Vue 3
directives: {
  highlight(el, binding, vnode) {
    console.log(binding.value) // 使用这个
  }
}
```

### 8.4 组件实例访问

```javascript
// Vue 2
mounted(el, binding, vnode) {
  const vm = vnode.context
}

// Vue 3
mounted(el, binding, vnode) {
  const vm = binding.instance
}
```

---

## 9. 异步组件

### 9.1 基础

```javascript
// Vue 2
const AsyncComponent = () => import('./Component.vue')

// Vue 3
import { defineAsyncComponent } from 'vue'
const AsyncComponent = defineAsyncComponent(() => import('./Component.vue'))
```

### 9.2 带选项

```javascript
// Vue 2
const AsyncComponent = {
  component: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000,
  error: ErrorComponent,
  loading: LoadingComponent
}

// Vue 3
const AsyncComponent = defineAsyncComponent({
  loader: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000,
  errorComponent: ErrorComponent,
  loadingComponent: LoadingComponent
})
```

**注意：** `component` → `loader`

---

## 10. 函数式组件

### 10.1 完全重写

```javascript
// Vue 2
export default {
  functional: true,
  props: ['level'],
  render(h, { props, data, children }) {
    return h(`h${props.level}`, data, children)
  }
}

// Vue 3 - 必须是有状态组件
export default {
  props: ['level'],
  template: `<h{{ level }}><slot /></h{{ level }}>`
  // 或使用导入的 h 的 render 函数
}
```

### 10.2 模板函数式已移除

```html
<!-- Vue 2 -->
<template functional>
  <component :is="`h${props.level}`" v-bind="attrs" v-on="listeners" />
</template>

<!-- Vue 3 - 移除 functional 属性 -->
<template>
  <component :is="`h${$props.level}`" v-bind="$attrs" />
</template>
```

---

## 11. 插槽

### 11.1 $scopedSlots 已移除

```javascript
// Vue 2
this.$scopedSlots.header

// Vue 3
this.$slots.header()
```

### 11.2 所有插槽作为函数

```javascript
// Vue 2
this.$slots.default
this.$scopedSlots.footer

// Vue 3
this.$slots.default()
this.$slots.footer()
```

### 11.3 Render 函数语法

```javascript
// Vue 2
h(LayoutComponent, [
  h('div', { slot: 'header' }, this.header)
])

// Vue 3
h(LayoutComponent, {
  header: () => h('div', this.header)
})
```

---

## 12. $listeners 已移除

```javascript
// Vue 2
this.$listeners

// Vue 3 - 合并到 $attrs
this.$attrs  // 现在包含 onClick 等
```

**模板变更：**

```html
<!-- Vue 2 -->
<input v-bind="$attrs" v-on="$listeners" />

<!-- Vue 3 -->
<input v-bind="$attrs" />
```

---

## 13. $attrs 包含 class 和 style

### 13.1 之前

```javascript
// Vue 2 - $attrs 排除 class 和 style
this.$attrs  // { id: 'my-id' }
```

### 13.2 之后

```javascript
// Vue 3 - $attrs 包含所有内容
this.$attrs  // { id: 'my-id', class: 'my-class', style: 'color: red' }
```

---

## 14. Data 选项

### 14.1 必须是函数

```javascript
// Vue 2 - 根组件允许对象
data: { count: 0 }

// Vue 3 - 所有组件都必须用函数
data() {
  return { count: 0 }
}
```

### 14.2 Mixin 浅合并

```javascript
// Vue 2 - 深度合并
// 结果: { user: { id: 2, name: 'Jack' } }

// Vue 3 - 浅合并
// 结果: { user: { id: 2 } }
```

---

## 15. Watch 数组

### 15.1 行为变更

```javascript
// Vue 2 - 变更时触发
watch: {
  list() { /* 触发 */ }
}

// Vue 3 - 仅替换时触发
watch: {
  list() { /* 变更时不会触发 */ }
}

// 添加 deep 选项
watch: {
  list: {
    handler() { /* 触发 */ },
    deep: true
  }
}
```

---

## 16. 过渡类

### 16.1 重命名

```css
/* Vue 2 */
.v-enter,
.v-leave-to { opacity: 0; }

/* Vue 3 */
.v-enter-from,
.v-leave-to { opacity: 0; }
```

### 16.2 Props 重命名

```javascript
// Vue 2
leave-class: 'my-leave'
enter-class: 'my-enter'

// Vue 3
leave-from-class: 'my-leave'
enter-from-class: 'my-enter'
```

---

## 17. 模板 Key 属性

### 17.1 template v-for

```html
<!-- Vue 2 -->
<template v-for="item in list">
  <div :key="item.id">...</div>
</template>

<!-- Vue 3 -->
<template v-for="item in list" :key="item.id">
  <div>...</div>
</template>
```

### 17.2 v-if/v-else

```html
<!-- Vue 2 -->
<div v-if="condition" key="yes">Yes</div>
<div v-else key="no">No</div>

<!-- Vue 3 - key 可选，自动生成 -->
<div v-if="condition">Yes</div>
<div v-else>No</div>
```

---

## 18. v-if/v-for 优先级

```html
<!-- Vue 2 - v-for 优先 -->
<div v-for="item in items" v-if="item.visible">...</div>

<!-- Vue 3 - v-if 优先 -->

<!-- 最佳实践 - 使用计算属性 -->
<div v-for="item in visibleItems">...</div>
```

---

## 19. v-bind 顺序

```html
<!-- Vue 3 中顺序很重要 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- 结果: id="blue"（v-bind 获胜） -->

<div v-bind="{ id: 'blue' }" id="red"></div>
<!-- 结果: id="red"（静态获胜） -->
```

---

## 20. 自定义元素互操作性

### 20.1 config.ignoredElements

```javascript
// Vue 2
Vue.config.ignoredElements = ['plastic-button']

// Vue 3 - 编译器选项
// webpack vue-loader
{
  test: /\.vue$/,
  use: 'vue-loader',
  options: {
    compilerOptions: {
      isCustomElement: tag => tag === 'plastic-button'
    }
  }
}
```

### 20.2 is 属性

```html
<!-- Vue 2 - 解释为 Vue 组件 -->
<button is="plastic-button">Click</button>

<!-- Vue 3 -->
<!-- 对于 Vue 组件 -->
<component is="bar" />
<!-- 对于原生自定义元素 -->
<button is="plastic-button">Click</button>
```

### 20.3 vue: 前缀

```html
<!-- 用于 DOM 模板组件使用 -->
<table>
  <tr is="vue:blog-post-row"></tr>
</table>
```

---

## 21. 过渡组根元素

### 21.1 没有默认根元素

```html
<!-- Vue 2 - 有 span 根元素 -->
<transition-group>
  <li v-for="item in items" :key="item">{{ item }}</li>
</transition-group>
<!-- 渲染为: <span><li>...</li><li>...</li></span> -->

<!-- Vue 3 - 没有根元素 -->
<transition-group tag="span">
  <!-- 或没有 tag 属性 -->
  <li v-for="item in items" :key="item">{{ item }}</li>
</transition-group>
```

---

## 22. 挂载变更

```javascript
// Vue 2 - 替换元素
const app = new Vue({ template: '<div>App</div>' })
app.$mount('#app')
<!-- 如果 #app 有内容，会被替换 -->

// Vue 3 - 追加为子元素
const app = createApp({ template: '<div>App</div>' })
app.mount('#app')
<!-- #app 的 innerHTML 被替换 -->
```

---

## 23. KeyCode 修饰符

### 23.1 已移除

```html
<!-- Vue 2 - KeyCode -->
<input @keyup.13="submit" />

<!-- Vue 3 - 使用按键名称 -->
<input @keyup.enter="submit" />
```

### 23.2 config.keyCodes 已移除

```javascript
// Vue 2
Vue.config.keyCodes = {
  f1: 112
}

// Vue 3 - 已移除
```

### 23.3 支持的按键

```html
<input @keyup.page-down="nextPage" />
<input @keypress.q="quit" />
```

---

## 24. 全局 API 树摇

### 24.1 命名导出

```javascript
// Vue 2
Vue.nextTick(() => {})
Vue.observable({})
Vue.version

// Vue 3
import { nextTick, reactive, version } from 'vue'
nextTick(() => {})
reactive({})
version
```

### 24.2 受影响的 API

| Vue 2 | Vue 3 |
|-------|-------|
| Vue.nextTick | nextTick |
| Vue.observable | reactive |
| Vue.version | version |
| Vue.compile | import { compile } from 'vue' |
| Vue.set | 已移除（不需要） |
| Vue.delete | 已移除（不需要） |

---

## 25. Props 默认工厂

```javascript
// Vue 2
props: {
  theme: {
    default(props) {
      return this.theme  // 可以访问 this
    }
  }
}

// Vue 3
import { inject } from 'vue'
props: {
  theme: {
    default(props) {
      return props.theme  // props 参数
      // 或使用 inject('theme', 'default')
    }
  }
}
```

---

## 26. Render 函数 API

### 26.1 h 导入

```javascript
// Vue 2 - h 作为参数传递
export default {
  render(h) {
    return h('div')
  }
}

// Vue 3 - 导入 h
import { h } from 'vue'
export default {
  render() {
    return h('div')
  }
}
```

### 26.2 VNode Props 扁平化

```javascript
// Vue 2
{
  staticClass: 'button',
  class: { 'is-outlined': isOutlined },
  staticStyle: { color: '#34495E' },
  style: { backgroundColor: buttonColor },
  attrs: { id: 'submit' },
  domProps: { innerHTML: '' },
  on: { click: submitForm }
}

// Vue 3
{
  class: ['button', { 'is-outlined': isOutlined }],
  style: [{ color: '#34495E' }, { backgroundColor: buttonColor }],
  id: 'submit',
  innerHTML: '',
  onClick: submitForm
}
```

### 26.3 解析组件

```javascript
// Vue 2 - 字符串可用
render(h) {
  return h('my-component')
}

// Vue 3 - 必须使用 resolveComponent
import { h, resolveComponent } from 'vue'
render() {
  const MyComponent = resolveComponent('my-component')
  return h(MyComponent)
}
```

---

## 总结表

| 类别 | Vue 2 | Vue 3 | 优先级 |
|----------|-------|-------|----------|
| 全局 API | Vue.component | app.component | 关键 |
| v-model | value/input | modelValue/update:modelValue | 关键 |
| 生命周期 | beforeDestroy | beforeUnmount | 关键 |
| 过滤器 | {{ | filter }} | methods/computed | 关键 |
| 事件 | $on/$off/$once | mitt/tiny-emitter | 关键 |
| .sync | :prop.sync | v-model:prop | 高 |
| 指令 | bind/inserted | beforeMount/mounted | 高 |
| 异步 | component 选项 | loader 选项 | 高 |
| 函数式 | functional: true | 仅限有状态 | 高 |
| .native | @click.native | @click | 高 |
| $scopedSlots | this.$scopedSlots | this.$slots() | 中等 |
| $listeners | 独立 | 在 $attrs 中 | 中等 |
| Data | 对象或函数 | 仅函数 | 中等 |
| Watch | 变更触发 | 仅替换触发 | 中等 |
| 过渡 | .v-enter | .v-enter-from | 低 |
| Key | 在子元素上 | 在模板上 | 低 |
