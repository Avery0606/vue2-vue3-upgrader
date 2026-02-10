# Vue3 Migration Checklist

Based on official Vue.js 3 Migration Guide: https://v3-migration.vuejs.org/zh/breaking-changes/

## 1. Global API Changes

### 1.1 createApp (Critical)

```javascript
// Vue 2
const app = new Vue({ /* root options */ })

// Vue 3
import { createApp } from 'vue'
const app = createApp({ /* root options */ })
```

### 1.2 Component Registration

```javascript
// Vue 2
Vue.component('my-component', { /* options */ })

// Vue 3
app.component('my-component', { /* options */ })
```

### 1.3 Directive Registration

```javascript
// Vue 2
Vue.directive('my-directive', { /* options */ })

// Vue 3
app.directive('my-directive', { /* options */ })
```

### 1.4 Plugin Installation

```javascript
// Vue 2
Vue.use(router)

// Vue 3
app.use(router)
```

### 1.5 Mixin

```javascript
// Vue 2
Vue.mixin({ /* options */ })

// Vue 3
app.mixin({ /* options */ })
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

### 1.9 Vue.extend REMOVED

```javascript
// Vue 2
const Component = Vue.extend({ /* options */ })

// Vue 3 - Use defineComponent
import { defineComponent } from 'vue'
const Component = defineComponent({ /* options */ })

// Or just use options directly with createApp
```

### 1.10 Global Properties

```javascript
// Vue 2 - provide on root
new Vue({
  provide: { userName: 'John' }
})

// Vue 3 - app.provide
app.provide('userName', 'John')
```

---

## 2. v-model Changes

### 2.1 Basic v-model

```html
<!-- Vue 2 -->
<ChildComponent v-model="pageTitle" />
<!-- Same as -->
<ChildComponent :value="pageTitle" @input="pageTitle = $event" />

<!-- Vue 3 -->
<ChildComponent v-model="pageTitle" />
<!-- Same as -->
<ChildComponent :modelValue="pageTitle" @update:modelValue="pageTitle = $event" />
```

### 2.2 Component Changes

```javascript
// Child component - Vue 2
export default {
  props: ['value'],
  model: {
    prop: 'value',
    event: 'input'
  }
}

// Child component - Vue 3
export default {
  props: ['modelValue'],
  emits: ['update:modelValue']
}
```

### 2.3 .sync Replacement

```html
<!-- Vue 2 -->
<ChildComponent :title.sync="pageTitle" />

<!-- Vue 3 -->
<ChildComponent v-model:title="pageTitle" />
```

### 2.4 Multiple v-model

```html
<!-- Vue 3 supports multiple v-model -->
<ChildComponent
  v-model:title="pageTitle"
  v-model:content="pageContent"
/>
```

### 2.5 v-model Modifiers

```html
<!-- Custom modifiers supported in Vue 3 -->
<ChildComponent v-model.capitalize="text" />
```

---

## 3. Events API Removal

### 3.1 $on/$off/$once REMOVED

```javascript
// Vue 2 - REMOVED
this.$on('event', handler)
this.$off('event', handler)
this.$once('event', handler)
```

### 3.2 Event Bus Replacement

```javascript
// Using mitt
import mitt from 'mitt'
const emitter = mitt()

// emitter.on(event, handler)
// emitter.off(event, handler)
// emitter.emit(event, data)
```

```javascript
// Using tiny-emitter
import tinyEmitter from 'tiny-emitter/instance'

export default {
  $on: (...args) => tinyEmitter.on(...args),
  $off: (...args) => tinyEmitter.off(...args),
  $once: (...args) => tinyEmitter.once(...args),
  $emit: (...args) => tinyEmitter.emit(...args)
}
```

### 3.3 Root Component Events

```javascript
// Vue 3
createApp(App, {
  onExpand() {
    console.log('expand')
  }
})
```

---

## 4. v-on.native Removed

```html
<!-- Vue 2 -->
<ChildComponent @click.native="handleClick" />

<!-- Vue 3 -->
<ChildComponent @click="handleClick" />
```

**Note:** Child component must declare the event in `emits` option.

---

## 5. Emits Option

### 5.1 Basic Usage

```javascript
export default {
  emits: ['click', 'update:value']
}
```

### 5.2 With Validation

```javascript
export default {
  emits: {
    click: null,
    update:value: (value) => typeof value === 'string'
  }
}
```

### 5.3 Why Important

Without emits, events are fallthrough to $attrs and cause duplicate events.

---

## 6. Lifecycle Hooks

### 6.1 Renamed

```javascript
// Vue 2 → Vue 3
beforeDestroy → beforeUnmount
destroyed → unmounted
```

```javascript
// Before
beforeDestroy() {
  // cleanup
}

// After
beforeUnmount() {
  // cleanup
}
```

---

## 7. Filters REMOVED

### 7.1 Filter Definition

```javascript
// Vue 2
export default {
  filters: {
    currencyUSD(value) {
      return '$' + value
    }
  }
}

// Vue 3 - REMOVED
```

### 7.2 Replacement - Method

```javascript
export default {
  methods: {
    currencyUSD(value) {
      return '$' + value
    }
  }
}
```

### 7.3 Replacement - Computed

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

### 7.4 Template Usage

```html
<!-- Vue 2 -->
{{ price | currencyUSD }}

<!-- Vue 3 -->
{{ currencyUSD(price) }}
<!-- or -->
{{ formattedPrice }}
```

### 7.5 Global Filters

```javascript
// main.js - Vue 3
app.config.globalProperties.$filters = {
  currencyUSD(value) {
    return '$' + value
  }
}
```

```html
<!-- Template usage -->
{{ $filters.currencyUSD(price) }}
```

---

## 8. Custom Directives

### 8.1 Hook Mapping

| Vue 2 | Vue 3 | Description |
|-------|-------|-------------|
| bind | beforeMount | When directive attaches |
| inserted | mounted | Element inserted in DOM |
| update | REMOVED | Use updated |
| componentUpdated | updated | After component update |
| unbind | unmounted | Directive removes |

### 8.2 New Hooks

```javascript
export default {
  created(el, binding, vnode) {
    // New! Before attributes applied
  },
  beforeMount() {
    // New! Before element mounted
  },
  mounted() {},
  beforeUpdate() {
    // New! Before element updates
  },
  updated() {},
  beforeUnmount() {
    // New! Before element unmounts
  },
  unmounted() {}
}
```

### 8.3 binding.expression REMOVED

```javascript
// Vue 2
directives: {
  highlight: {
    bind(el, binding, vnode) {
      console.log(binding.expression) // REMOVED
    }
  }
}

// Vue 3
directives: {
  highlight(el, binding, vnode) {
    console.log(binding.value) // Use this instead
  }
}
```

### 8.4 Component Instance Access

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

## 9. Async Components

### 9.1 Basic

```javascript
// Vue 2
const AsyncComponent = () => import('./Component.vue')

// Vue 3
import { defineAsyncComponent } from 'vue'
const AsyncComponent = defineAsyncComponent(() => import('./Component.vue'))
```

### 9.2 With Options

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

**Note:** `component` → `loader`

---

## 10. Functional Components

### 10.1 Completely Rewritten

```javascript
// Vue 2
export default {
  functional: true,
  props: ['level'],
  render(h, { props, data, children }) {
    return h(`h${props.level}`, data, children)
  }
}

// Vue 3 - Must be stateful
export default {
  props: ['level'],
  template: `<h{{ level }}><slot /></h{{ level }}>`
  // or use render function with imported h
}
```

### 10.2 Template Functional Removed

```html
<!-- Vue 2 -->
<template functional>
  <component :is="`h${props.level}`" v-bind="attrs" v-on="listeners" />
</template>

<!-- Vue 3 - Remove functional attribute -->
<template>
  <component :is="`h${$props.level}`" v-bind="$attrs" />
</template>
```

---

## 11. Slots

### 11.1 $scopedSlots Removed

```javascript
// Vue 2
this.$scopedSlots.header

// Vue 3
this.$slots.header()
```

### 11.2 All Slots as Functions

```javascript
// Vue 2
this.$slots.default
this.$scopedSlots.footer

// Vue 3
this.$slots.default()
this.$slots.footer()
```

### 11.3 Render Function Syntax

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

## 12. $listeners Removed

```javascript
// Vue 2
this.$listeners

// Vue 3 - Merged into $attrs
this.$attrs  // Now includes onClick, etc.
```

**Template change:**

```html
<!-- Vue 2 -->
<input v-bind="$attrs" v-on="$listeners" />

<!-- Vue 3 -->
<input v-bind="$attrs" />
```

---

## 13. $attrs Includes class & style

### 13.1 Before

```javascript
// Vue 2 - $attrs excludes class and style
this.$attrs  // { id: 'my-id' }
```

### 13.2 After

```javascript
// Vue 3 - $attrs includes everything
this.$attrs  // { id: 'my-id', class: 'my-class', style: 'color: red' }
```

---

## 14. Data Option

### 14.1 Must Be Function

```javascript
// Vue 2 - Object allowed for root
data: { count: 0 }

// Vue 3 - Function required for ALL
data() {
  return { count: 0 }
}
```

### 14.2 Mixin Shallow Merge

```javascript
// Vue 2 - Deep merge
// Result: { user: { id: 2, name: 'Jack' } }

// Vue 3 - Shallow merge
// Result: { user: { id: 2 } }
```

---

## 15. Watch Array

### 15.1 Behavior Change

```javascript
// Vue 2 - Triggers on mutation
watch: {
  list() { /* triggers */ }
}

// Vue 3 - Only triggers on replacement
watch: {
  list() { /* won't trigger on mutation */ }
}

// Add deep option
watch: {
  list: {
    handler() { /* triggers */ },
    deep: true
  }
}
```

---

## 16. Transition Classes

### 16.1 Renamed

```css
/* Vue 2 */
.v-enter,
.v-leave-to { opacity: 0; }

/* Vue 3 */
.v-enter-from,
.v-leave-to { opacity: 0; }
```

### 16.2 Props Renamed

```javascript
// Vue 2
leave-class: 'my-leave'
enter-class: 'my-enter'

// Vue 3
leave-from-class: 'my-leave'
enter-from-class: 'my-enter'
```

---

## 17. Template Key Attribute

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

<!-- Vue 3 - key optional, auto-generated -->
<div v-if="condition">Yes</div>
<div v-else>No</div>
```

---

## 18. v-if/v-for Priority

```html
<!-- Vue 2 - v-for has priority -->
<div v-for="item in items" v-if="item.visible">...</div>

<!-- Vue 3 - v-if has priority -->

<!-- Best practice - use computed -->
<div v-for="item in visibleItems">...</div>
```

---

## 19. v-bind Order

```html
<!-- Order matters in Vue 3 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- Result: id="blue" (v-bind wins) -->

<div v-bind="{ id: 'blue' }" id="red"></div>
<!-- Result: id="red" (static wins) -->
```

---

## 20. Custom Elements Interop

### 20.1 config.ignoredElements

```javascript
// Vue 2
Vue.config.ignoredElements = ['plastic-button']

// Vue 3 - Compiler option
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

### 20.2 is Attribute

```html
<!-- Vue 2 - Interpreted as Vue component -->
<button is="plastic-button">Click</button>

<!-- Vue 3 -->
<!-- For Vue component -->
<component is="bar" />
<!-- For native custom element -->
<button is="plastic-button">Click</button>
```

### 20.3 vue: Prefix

```html
<!-- For DOM template component usage -->
<table>
  <tr is="vue:blog-post-row"></tr>
</table>
```

---

## 21. Transition Group Root

### 21.1 No Default Root

```html
<!-- Vue 2 - Has span root -->
<transition-group>
  <li v-for="item in items" :key="item">{{ item }}</li>
</transition-group>
<!-- Renders: <span><li>...</li><li>...</li></span> -->

<!-- Vue 3 - No root -->
<transition-group tag="span">
  <!-- or no tag attribute -->
  <li v-for="item in items" :key="item">{{ item }}</li>
</transition-group>
```

---

## 22. Mount Changes

```javascript
// Vue 2 - Replaces element
const app = new Vue({ template: '<div>App</div>' })
app.$mount('#app')
<!-- If #app has content, it's replaced -->

// Vue 3 - Appends as child
const app = createApp({ template: '<div>App</div>' })
app.mount('#app')
<!-- #app's innerHTML is replaced -->
```

---

## 23. KeyCode Modifiers

### 23.1 Removed

```html
<!-- Vue 2 - KeyCode -->
<input @keyup.13="submit" />

<!-- Vue 3 - Use key names -->
<input @keyup.enter="submit" />
```

### 23.2 config.keyCodes REMOVED

```javascript
// Vue 2
Vue.config.keyCodes = {
  f1: 112
}

// Vue 3 - REMOVED
```

### 23.3 Supported Keys

```html
<input @keyup.page-down="nextPage" />
<input @keypress.q="quit" />
```

---

## 24. Global API Tree-shaking

### 24.1 Named Exports

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

### 24.2 Affected APIs

| Vue 2 | Vue 3 |
|-------|-------|
| Vue.nextTick | nextTick |
| Vue.observable | reactive |
| Vue.version | version |
| Vue.compile | import { compile } from 'vue' |
| Vue.set | REMOVED (not needed) |
| Vue.delete | REMOVED (not needed) |

---

## 25. Props Default Factory

```javascript
// Vue 2
props: {
  theme: {
    default(props) {
      return this.theme  // Has access to this
    }
  }
}

// Vue 3
import { inject } from 'vue'
props: {
  theme: {
    default(props) {
      return props.theme  // props parameter
      // or use inject('theme', 'default')
    }
  }
}
```

---

## 26. Render Function API

### 26.1 h Import

```javascript
// Vue 2 - h passed as parameter
export default {
  render(h) {
    return h('div')
  }
}

// Vue 3 - h imported
import { h } from 'vue'
export default {
  render() {
    return h('div')
  }
}
```

### 26.2 VNode Props Flattened

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

### 26.3 Resolve Component

```javascript
// Vue 2 - String works
render(h) {
  return h('my-component')
}

// Vue 3 - Must use resolveComponent
import { h, resolveComponent } from 'vue'
render() {
  const MyComponent = resolveComponent('my-component')
  return h(MyComponent)
}
```

---

## Summary Table

| Category | Vue 2 | Vue 3 | Priority |
|----------|-------|-------|----------|
| Global API | Vue.component | app.component | Critical |
| v-model | value/input | modelValue/update:modelValue | Critical |
| Lifecycle | beforeDestroy | beforeUnmount | Critical |
| Filters | {{ \| filter }} | methods/computed | Critical |
| Events | $on/$off/$once | mitt/tiny-emitter | Critical |
| .sync | :prop.sync | v-model:prop | High |
| Directives | bind/inserted | beforeMount/mounted | High |
| Async | component option | loader option | High |
| Functional | functional: true | stateful only | High |
| .native | @click.native | @click | High |
| $scopedSlots | this.$scopedSlots | this.$slots() | Medium |
| $listeners | Separate | In $attrs | Medium |
| Data | Object or function | Function only | Medium |
| Watch | Mutation triggers | Replacement only | Medium |
| Transitions | .v-enter | .v-enter-from | Low |
| Key | On children | On template | Low |
