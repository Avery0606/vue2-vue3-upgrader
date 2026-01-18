---
name: listeners-removed
description: 移除 $listeners，事件监听器现在是 $attrs 的一部分
---



# 迁移规则概览



## 迁移规则1：移除 $listeners

- Vue2: 使用 $attrs 访问属性，使用 $listeners 访问事件
- Vue3: $attrs 包含所有属性和事件，移除 $listeners

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <label>
    <input type="text" v-bind="$attrs" v-on="$listeners" />
  </label>
</template>
<script>
export default {
  inheritAttrs: false
}
</script>

<!-- Vue3 写法 -->
<template>
  <label>
    <!-- $attrs 现在包含所有属性和事件 -->
    <input type="text" v-bind="$attrs" />
  </label>
</template>
<script>
export default {
  inheritAttrs: false
}
</script>
```

## 迁移规则2：$attrs 现在包含事件

- Vue2: 事件监听器通过 $listeners 访问
- Vue3: 事件监听器作为 $attrs 的一部分

### 代码示例

```javascript
// Vue2 写法
export default {
  inheritAttrs: false,
  mounted() {
    console.log(this.$attrs) // { id: 'my-input' }
    console.log(this.$listeners) // { onClose: function }
  }
}

// Vue3 写法
export default {
  inheritAttrs: false,
  mounted() {
    console.log(this.$attrs) // { id: 'my-input', onClose: function }
  }
}
```
