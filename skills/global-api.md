---
name: global-api
description: 全局 API 应用实例化，从 Vue2 的全局配置改为 Vue3 的应用实例，包括 createApp、挂载方式、provide/inject 等变化
---



# 迁移规则概览



## 迁移规则1：Vue.component 替换为 app.component

- Vue2: 使用 Vue.component 注册全局组件
- Vue3: 使用 app.component 注册应用级组件

### 代码示例

```javascript
// Vue2 写法
Vue.component('button-counter', {
  data: () => ({
    count: 0
  }),
  template: '<button @click="count++">Clicked {{ count }} times.</button>'
})

const app = new Vue({
  el: '#app'
})

// Vue3 写法
const app = createApp({})
app.component('button-counter', {
  data: () => ({
    count: 0
  }),
  template: '<button @click="count++">Clicked {{ count }} times.</button>'
})
app.mount('#app')
```

## 迁移规则2：Vue.directive 替换为 app.directive

- Vue2: 使用 Vue.directive 注册全局指令
- Vue3: 使用 app.directive 注册应用级指令

### 代码示例

```javascript
// Vue2 写法
Vue.directive('focus', {
  inserted: (el) => el.focus()
})

// Vue3 写法
const app = createApp({})
app.directive('focus', {
  mounted: (el) => el.focus()
})
```

## 迁移规则3：Vue.config 替换为 app.config

- Vue2: 使用 Vue.config 进行全局配置
- Vue3: 使用 app.config 进行应用级配置

### 代码示例

```javascript
// Vue2 写法
Vue.config.productionTip = false

// Vue3 写法
const app = createApp({})
app.config.errorHandler = (err, vm, info) => {
  console.error(err, info)
}
```

## 迁移规则4：Vue.use 替换为 app.use

- Vue2: 使用 Vue.use 全局安装插件
- Vue3: 使用 app.use 为应用安装插件

### 代码示例

```javascript
// Vue2 写法
import VueRouter from 'vue-router'
Vue.use(VueRouter)

// Vue3 写法
import { createRouter, createWebHistory } from 'vue-router'
const router = createRouter({
  history: createWebHistory(),
  routes: []
})

const app = createApp({})
app.use(router)
```

## 迁移规则5：Vue.prototype 替换为 app.config.globalProperties

- Vue2: 使用 Vue.prototype 添加全局属性
- Vue3: 使用 app.config.globalProperties 添加应用全局属性

### 代码示例

```javascript
// Vue2 写法
Vue.prototype.$http = () => {}

// Vue3 写法
const app = createApp({})
app.config.globalProperties.$http = () => {}
```

## 迁移规则6：Vue.extend 移除，改用 defineComponent

- Vue2: 使用 Vue.extend 创建组件构造器
- Vue3: 移除 Vue.extend，使用 defineComponent 提供类型推断

### 代码示例

```javascript
// Vue2 写法
const Profile = Vue.extend({
  template: '<p>{{firstName}} {{lastName}}</p>',
  data() {
    return {
      firstName: 'Walter',
      lastName: 'White'
    }
  }
})
new Profile().$mount('#mount-point')

// Vue3 写法
import { defineComponent } from 'vue'

const Profile = defineComponent({
  template: '<p>{{firstName}} {{lastName}}</p>',
  data() {
    return {
      firstName: 'Walter',
      lastName: 'White'
    }
  }
})
createApp(Profile).mount('#mount-point')
```

## 迁移规则7：移除 config.productionTip

- Vue2: 使用 Vue.config.productionTip 控制生产提示
- Vue3: 移除此配置，生产提示仅在 dev+full build 中显示

### 代码示例

```javascript
// Vue2 写法
Vue.config.productionTip = false

// Vue3 写法
// 不再需要此配置，使用 ES 模块构建版本时自动处理
```

## 迁移规则8：config.ignoredElements 替换为 isCustomElement

- Vue2: 使用 Vue.config.ignoredElements 配置自定义元素
- Vue3: 使用 app.config.compilerOptions.isCustomElement 配置

### 代码示例

```javascript
// Vue2 写法
Vue.config.ignoredElements = ['my-el', /^ion-/]

// Vue3 写法
const app = createApp({})
app.config.compilerOptions.isCustomElement = (tag) => tag.startsWith('ion-')
```

## 迁移规则9：app.mount 挂载行为变更

- Vue2: new Vue({ el: '#app' }) 替换目标元素
- Vue3: app.mount('#app') 将内容插入目标元素，保留元素本身

### 代码示例

```javascript
// Vue2 写法
new Vue({
  el: '#app',
  template: '<div id="rendered">{{ message }}</div>'
})
// 结果：<div id="rendered">Hello</div> （替换了 #app）

// Vue3 写法
const app = createApp({
  template: '<div id="rendered">{{ message }}</div>'
})
app.mount('#app')
// 结果：<div id="app" data-v-app><div id="rendered">Hello</div></div>
```

## 迁移规则10：应用 provide/inject

- Vue2: 在根实例使用 provide 选项
- Vue3: 应用实例提供 app.provide 方法

### 代码示例

```javascript
// Vue2 写法
new Vue({
  provide: {
    guide: 'Vue 2 Guide'
  }
})

// Vue3 写法
const app = createApp({})
app.provide('guide', 'Vue 3 Guide')
```
