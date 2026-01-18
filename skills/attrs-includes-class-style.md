---
name: attrs-includes-class-style
description: $attrs 包含 class 和 style，不再特殊处理
---



# 迁移规则概览



## 迁移规则1：$attrs 包含所有属性

- Vue2: class 和 style 不在 $attrs 中
- Vue3: $attrs 包含所有属性，包括 class 和 style

### 代码示例

```html
<!-- Vue2 写法 -->
<template>
  <label>
    <input type="text" v-bind="$attrs" />
  </label>
</template>
<script>
export default {
  inheritAttrs: false
}
</script>

<!-- 使用：<my-component id="my-id" class="my-class"></my-component> -->
<!-- 结果：<label class="my-class"><input type="text" id="my-id" /></label> -->
<!-- class 仍然在 label 上 -->

<!-- Vue3 写法 -->
<template>
  <label>
    <input type="text" v-bind="$attrs" />
  </label>
</template>
<script>
export default {
  inheritAttrs: false
}
</script>

<!-- 使用：<my-component id="my-id" class="my-class"></my-component> -->
<!-- 结果：<label><input type="text" id="my-id" class="my-class" /></label> -->
<!-- class 和所有属性都在 input 上 -->
```

## 迁移规则2：访问 class 和 style

- Vue2: class 和 style 单独处理
- Vue3: 通过 $attrs 访问

### 代码示例

```javascript
// Vue2 写法
export default {
  inheritAttrs: false,
  mounted() {
    console.log(this.$attrs) // { id: 'my-id', title: 'my-title' }
    // class 和 style 不在这里
  }
}

// Vue3 写法
export default {
  inheritAttrs: false,
  mounted() {
    console.log(this.$attrs)
    // { id: 'my-id', title: 'my-title', class: 'my-class', style: { color: 'red' } }
  }
}
```
