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

## 迁移规则4：组件内部监听自身事件

- Vue2: 可以通过 $on 方法在组件内部监听其自身通过 $emit 触发的事件
- Vue3: $on、$off 和 $once 方法已被移除，无法在组件内部监听自身事件

### 代码示例

```javascript
// Vue2 写法
export default {
  mounted() {
    this.$on('custom-event', this.handleEvent)
  },
  methods: {
    triggerEvent() {
      this.$emit('custom-event', { data: 'test' })
    },
    handleEvent(payload) {
      console.log('Received event:', payload)
    }
  }
}

// Vue3 写法 - 推荐方案：直接调用方法
export default {
  methods: {
    triggerEvent() {
      this.handleEvent({ data: 'test' })
    },
    handleEvent(payload) {
      console.log('Received:', payload)
    }
  }
}

// Vue3 写法 - 替代方案：使用事件总线（如 mitt）
import mitt from 'mitt'
const emitter = mitt()

export default {
  mounted() {
    emitter.on('custom-event', this.handleEvent)
  },
  beforeUnmount() {
    emitter.off('custom-event', this.handleEvent)
  },
  methods: {
    triggerEvent() {
      emitter.emit('custom-event', { data: 'test' })
    },
    handleEvent(payload) {
      console.log('Received:', payload)
    }
  }
}
```

## 迁移规则5：使用 provide/inject 和插槽替代事件总线

- Vue2: 使用事件总线进行组件间通信
- Vue3: 推荐使用 provide/inject 或插槽进行通信，避免 prop 逐级透传

### 代码示例

```javascript
// Vue2 写法 - Props 和事件用于父子组件通信
export default {
  props: ['message'],
  methods: {
    handleClick() {
      this.$emit('update', 'new value')
    }
  }
}

// Vue3 写法 - Props 和事件用于父子组件通信
export default {
  props: ['message'],
  emits: ['update'],
  methods: {
    handleClick() {
      this.$emit('update', 'new value')
    }
  }
}

// Vue2 写法 - provide/inject 用于插槽内容通信
export default {
  provide() {
    return {
      data: this.someData,
      method: this.someMethod
    }
  }
}

// Vue3 写法 - provide/inject 用于插槽内容通信
export default {
  provide() {
    return {
      data: this.someData,
      method: this.someMethod
    }
  }
}

// Vue2 写法 - provide/inject 用于远距离通信，避免 prop 逐级透传
export default {
  provide() {
    return {
      theme: this.theme,
      setTheme: this.setTheme
    }
  }
}

// Vue3 写法 - provide/inject 用于远距离通信
export default {
  provide() {
    return {
      theme: this.theme,
      setTheme: this.setTheme
    }
  }
}

// 深层组件使用
export default {
  inject: ['theme', 'setTheme']
}

// Vue2 写法 - 通过插槽避免 prop 逐级透传
export default {
  props: ['title', 'content']
}

// Vue3 写法 - 通过插槽避免 prop 逐级透传
export default {
  // 不需要 props，直接使用插槽
}
```
