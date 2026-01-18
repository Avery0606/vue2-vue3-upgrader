---
name: data-option
description: data 选项变化，只接受函数，mixin 合并变为浅合并
---



# 迁移规则概览



## 迁移规则1：data 必须是函数

- Vue2: data 可以是对象或函数
- Vue3: data 必须是函数

### 代码示例

```javascript
// Vue2 写法
const app = new Vue({
  data: {
    apiKey: 'a1b2c3'
  }
})

// Vue3 写法
createApp({
  data() {
    return {
      apiKey: 'a1b2c3'
    }
  }
}).mount('#app')
```

## 迁移规则2：mixin 合并变为浅合并

- Vue2: data 深度合并
- Vue3: data 浅合并（只合并根级属性）

### 代码示例

```javascript
// Vue2 写法
const Mixin = {
  data() {
    return {
      user: {
        name: 'Jack',
        id: 1
      }
    }
  }
}

const CompA = {
  mixins: [Mixin],
  data() {
    return {
      user: {
        id: 2
      }
    }
  }
}
// 结果：user: { id: 2, name: 'Jack' } （深度合并）

// Vue3 写法
const Mixin = {
  data() {
    return {
      user: {
        name: 'Jack',
        id: 1
      }
    }
  }
}

const CompA = {
  mixins: [Mixin],
  data() {
    return {
      user: {
        id: 2
      }
    }
  }
}
// 结果：user: { id: 2 } （浅合并，name 被覆盖）
```
