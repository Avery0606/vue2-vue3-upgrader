---
name: filters
description: 过滤器移除，需改用计算属性或方法调用来替换过滤器功能
---



# 迁移规则概览



## 迁移规则1：本地过滤器替换为计算属性

- Vue2: 使用 filters 选项定义本地过滤器
- Vue3: 移除过滤器，使用计算属性替换

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <h1>Bank Account Balance</h1>
  <p>{{ accountBalance | currencyUSD }}</p>
</template>

<script>
export default {
  props: {
    accountBalance: {
      type: Number,
      required: true
    }
  },
  filters: {
    currencyUSD(value) {
      return '$' + value
    }
  }
}
</script>

<!-- Vue3 写法 -->
<template>
  <h1>Bank Account Balance</h1>
  <p>{{ accountInUSD }}</p>
</template>

<script>
export default {
  props: {
    accountBalance: {
      type: Number,
      required: true
    }
  },
  computed: {
    accountInUSD() {
      return '$' + this.accountBalance
    }
  }
}
</script>
```

## 迁移规则2：全局过滤器替换为 globalProperties

- Vue2: 使用 Vue.filter 定义全局过滤器
- Vue3: 使用 app.config.globalProperties 定义全局方法

### 代码示例

```javascript
// Vue2 写法
Vue.filter('currencyUSD', (value) => {
  return '$' + value
})

// Vue3 写法
const app = createApp({})
app.config.globalProperties.$filters = {
  currencyUSD(value) {
    return '$' + value
  }
}
```

```html
<!-- Vue2 写法 -->
<p>{{ accountBalance | currencyUSD }}</p>

<!-- Vue3 写法 -->
<p>{{ $filters.currencyUSD(accountBalance) }}</p>
```
