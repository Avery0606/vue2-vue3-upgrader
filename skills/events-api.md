---
name: events-api
description: 事件 API 变化，移除 $on、$off、$once 实例方法，推荐使用外部事件库或 Pinia 状态管理
---



# 迁移规则概览



## 迁移规则1：移除事件总线 API

- Vue2: 使用 $on、$off、$once 实现事件总线
- Vue3: 移除这些方法，推荐使用外部库

### 代码示例

```javascript
// Vue2 写法
// eventBus.js
const eventBus = new Vue()
export default eventBus

// ChildComponent.vue
import eventBus from './eventBus'
export default {
  mounted() {
    eventBus.$on('custom-event', () => {
      console.log('Custom event triggered!')
    })
  },
  beforeDestroy() {
    eventBus.$off('custom-event')
  }
}

// ParentComponent.vue
import eventBus from './eventBus'
export default {
  methods: {
    callGlobalCustomEvent() {
      eventBus.$emit('custom-event')
    }
  }
}

// Vue3 写法
// eventBus.js
import emitter from 'tiny-emitter/instance'
export default {
  $on: (...args) => emitter.on(...args),
  $once: (...args) => emitter.once(...args),
  $off: (...args) => emitter.off(...args),
  $emit: (...args) => emitter.emit(...args),
}
```

## 迁移规则2：根组件事件监听

- Vue2: 使用 $on、$off 监听根组件事件
- Vue3: 通过 createApp 第二个参数传递事件监听器

### 代码示例

```javascript
// Vue2 写法
const app = new Vue({
  el: '#app',
  mounted() {
    this.$on('expand', () => console.log('expand'))
  }
})

// Vue3 写法
createApp(App, {
  onExpand() {
    console.log('expand')
  }
})
```

## 迁移规则3：使用 Pinia 替代事件总线

- Vue2: 使用事件总线进行跨组件通信
- Vue3: 推荐使用 Pinia 进行状态管理

### 代码示例

```javascript
// Vue2 写法 - 事件总线
const eventBus = new Vue()

// Vue3 写法 - Pinia
import { defineStore } from 'pinia'

export const useEventStore = defineStore('events', {
  state: () => ({
    listeners: {}
  }),
  actions: {
    on(event, callback) {
      if (!this.listeners[event]) {
        this.listeners[event] = []
      }
      this.listeners[event].push(callback)
    },
    emit(event, data) {
      if (this.listeners[event]) {
        this.listeners[event].forEach(callback => callback(data))
      }
    }
  }
})
```
