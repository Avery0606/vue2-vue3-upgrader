---
name: async-components
description: 异步组件 API 变化，使用 defineAsyncComponent，component 选项改名为 loader
---



# 迁移规则概览



## 迁移规则1：使用 defineAsyncComponent

- Vue2: 返回 Promise 的函数定义异步组件
- Vue3: 使用 defineAsyncComponent 包裹

### 代码示例

```javascript
// Vue2 写法
const asyncModal = () => import('./Modal.vue')

// Vue3 写法
import { defineAsyncComponent } from 'vue'
const asyncModal = defineAsyncComponent(() => import('./Modal.vue'))
```

## 迁移规则2：带选项的异步组件

- Vue2: 使用 component 选项
- Vue3: 使用 loader 选项，属性名变更

### 代码示例

```javascript
// Vue2 写法
const asyncModal = {
  component: () => import('./Modal.vue'),
  delay: 200,
  timeout: 3000,
  error: ErrorComponent,
  loading: LoadingComponent
}

// Vue3 写法
import { defineAsyncComponent } from 'vue'

const asyncModal = defineAsyncComponent({
  loader: () => import('./Modal.vue'),
  delay: 200,
  timeout: 3000,
  errorComponent: ErrorComponent,
  loadingComponent: LoadingComponent
})
```

## 迁移规则3：loader 函数不再接收 resolve 和 reject

- Vue2: loader 函数接收 resolve 和 reject 参数
- Vue3: loader 函数必须返回 Promise

### 代码示例

```javascript
// Vue2 写法
const asyncComponent = (resolve, reject) => {
  setTimeout(() => {
    resolve({
      template: '<div>Async Component</div>'
    })
  }, 1000)
}

// Vue3 写法
const asyncComponent = defineAsyncComponent(
  () => new Promise((resolve) => {
    setTimeout(() => {
      resolve({
        template: '<div>Async Component</div>'
      })
    }, 1000)
  })
)
```
