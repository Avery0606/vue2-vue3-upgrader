---
name: v-on-native-modifier-removed
description: 移除 v-on.native 修饰符，未声明的事件自动绑定到根元素
---



# 迁移规则概览



## 迁移规则1：移除 .native 修饰符

- Vue2: 使用 .native 修饰符添加原生 DOM 监听器
- Vue3: 移除 .native，未在 emits 中声明的事件自动绑定到根元素

### 代码示例

```html
<!-- Vue2 写法 -->
<my-component
  v-on:close="handleComponentEvent"
  v-on:click.native="handleNativeClickEvent"
/>

<!-- Vue3 写法 -->
<my-component
  v-on:close="handleComponentEvent"
  v-on:click="handleNativeClickEvent"
/>

<script>
// MyComponent.vue
export default {
  emits: ['close'] // 声明组件事件，其他事件自动绑定到根元素
}
</script>
```

## 迁移规则2：emits 选项的使用

- Vue2: 不需要声明组件触发的事件
- Vue3: 使用 emits 选项声明组件触发的事件

### 代码示例

```javascript
// Vue2 写法
export default {
  methods: {
    handleClick() {
      this.$emit('click', event)
    }
  }
}

// Vue3 写法
export default {
  emits: ['click'], // 声明此事件由组件触发
  methods: {
    handleClick() {
      this.$emit('click', event)
    }
  }
}
```
