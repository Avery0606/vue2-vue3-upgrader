---
name: props-data
description: propsData 选项移除，改用 createApp 第二个参数传递 prop
---



# 迁移规则概览



## 迁移规则1：移除 propsData 选项

- Vue2: 使用 propsData 选项在创建实例时传入 prop
- Vue3: 使用 createApp 第二个参数传递 prop

### 代码示例

```javascript
// Vue2 写法
const Comp = Vue.extend({
  props: ['username'],
  template: '<div>{{ username }}</div>'
})

new Comp({
  propsData: {
    username: 'Evan'
  }
})

// Vue3 写法
const app = createApp(
  {
    props: ['username'],
    template: '<div>{{ username }}</div>'
  },
  { username: 'Evan' }
)
app.mount('#app')
```
