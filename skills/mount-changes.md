---
name: mount-changes
description: 挂载 API 变化，应用不再替换目标元素，而是插入其中
---



# 迁移规则概览



## 迁移规则1：挂载行为变更

- Vue2: new Vue 或 $mount 替换目标元素
- Vue3: app.mount 将内容插入目标元素，保留元素本身

### 代码示例

```javascript
// Vue2 写法
new Vue({
  el: '#app',
  template: '<div id="rendered">{{ message }}</div>',
  data() {
    return {
      message: 'Hello Vue!'
    }
  }
})
// 原始：<div id="app">Some app content</div>
// 结果：<div id="rendered">Hello Vue!</div> （替换）

// Vue3 写法
const app = createApp({
  template: '<div id="rendered">{{ message }}</div>',
  data() {
    return {
      message: 'Hello Vue!'
    }
  }
})
app.mount('#app')
// 原始：<div id="app">Some app content</div>
// 结果：<div id="app" data-v-app><div id="rendered">Hello Vue!</div></div> （插入）
```
