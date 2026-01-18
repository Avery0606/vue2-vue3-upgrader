---
name: global-api-treeshaking
description: 全局 API Treeshaking，改用具名导入支持 tree-shaking
---



# 迁移规则概览



## 迁移规则1：具名导入替代全局 API

- Vue2: 使用 Vue.nextTick 等全局 API
- Vue3: 使用具名导入以支持 tree-shaking

### 代码示例

```javascript
// Vue2 写法
import Vue from 'vue'
Vue.nextTick(() => {
  // DOM 相关代码
})

// Vue3 写法
import { nextTick } from 'vue'
nextTick(() => {
  // DOM 相关代码
})
```

## 迁移规则2：实例方法替代全局方法

- Vue2: 使用 Vue.nextTick，$nextTick 是别名
- Vue3: 直接导入 nextTick

### 代码示例

```javascript
// Vue2 写法
import { shallowMount } from '@vue/test-utils'
import { MyComponent } from './MyComponent.vue'

test('an async feature', async () => {
  const wrapper = shallowMount(MyComponent)
  await wrapper.vm.$nextTick()
})

// Vue3 写法
import { shallowMount } from '@vue/test-utils'
import { MyComponent } from './MyComponent.vue'
import { nextTick } from 'vue'

test('an async feature', async () => {
  const wrapper = shallowMount(MyComponent)
  await nextTick()
})
```

## 迁移规则3：插件中使用全局 API

- Vue2: 插件中使用 Vue.nextTick
- Vue3: 插件中显式导入

### 代码示例

```javascript
// Vue2 写法
const plugin = {
  install: Vue => {
    Vue.nextTick(() => {
      // ...
    })
  }
}

// Vue3 写法
import { nextTick } from 'vue'

const plugin = {
  install: app => {
    nextTick(() => {
      // ...
    })
  }
}
```

## 迁移规则4：受影响的全局 API

- Vue2: Vue.nextTick、Vue.observable、Vue.version 等
- Vue3: nextTick、reactive、version 等具名导入

### 代码示例

```javascript
// Vue2 写法
import Vue from 'vue'
Vue.nextTick(() => {})
Vue.observable({ count: 0 })
console.log(Vue.version)

// Vue3 写法
import { nextTick, reactive, version } from 'vue'
nextTick(() => {})
reactive({ count: 0 })
console.log(version)
```

## 迁移规则5：内部帮助器具名导出

- Vue2: 内部组件和帮助器打包时会全部引入
- Vue3: 内部帮助器具名导出，支持 tree-shaking

### 代码示例

```html
<!-- 编译结果示例 -->
<!-- Vue2 写法 -->
<transition>
  <div v-show="ok">hello</div>
</transition>

<!-- 编译为 -->
import Vue from 'vue'
export function render() {
  return Vue.h('transition', [Vue.h('div', { directives: [{ name: 'show', value: this.ok }] }, 'hello')])
}

<!-- Vue3 写法 -->
<transition>
  <div v-show="ok">hello</div>
</transition>

<!-- 编译为 -->
import { h, Transition, withDirectives, vShow } from 'vue'
export function render() {
  return h(Transition, [withDirectives(h('div', 'hello'), [[vShow, this.ok]])])
}
```

## 迁移规则6：插件打包工具配置

- Vue2: 插件依赖全局 API
- Vue3: 插件必须配置 externals/external 避免 Vue 源代码打包到插件中

### 代码示例

```javascript
// webpack 配置
// webpack.config.js
module.exports = {
  externals: {
    vue: 'Vue'
  }
}

// Rollup 配置
// rollup.config.js
export default {
  external: ['vue']
}
```
