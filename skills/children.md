---
name: children
description: $children 属性移除，使用模板引用访问子组件
---



# 迁移规则概览



## 迁移规则1：移除 $children

- Vue2: 使用 this.$children 访问子组件实例
- Vue3: 移除 $children，使用模板引用

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <div>
    <img alt="Vue logo" src="./assets/logo.png">
    <my-button>Change logo</my-button>
  </div>
</template>

<script>
import MyButton from './MyButton'

export default {
  components: {
    MyButton
  },
  mounted() {
    console.log(this.$children) // [VueComponent]
    this.$children[0].doSomething()
  }
}
</script>

<!-- Vue3 写法 -->
<template>
  <div>
    <img alt="Vue logo" src="./assets/logo.png">
    <my-button ref="myButton">Change logo</my-button>
  </div>
</template>

<script>
import MyButton from './MyButton'

export default {
  components: {
    MyButton
  },
  mounted() {
    console.log(this.$refs.myButton) // VueComponent
    this.$refs.myButton.doSomething()
  }
}
</script>
```
