---
name: inline-template-attribute
description: 移除内联模板 attribute，推荐使用 script 标签或默认插槽
---



# 迁移规则概览



## 迁移规则1：移除 inline-template

- Vue2: 使用 inline-template attribute 将内部内容作为组件模板
- Vue3: 移除此特性

### 代码示例

```html
<!-- Vue2 写法 -->
<my-component inline-template>
  <div>
    <p>它们将被编译为组件自己的模板</p>
  </div>
</my-component>

<!-- Vue3 写法 - 方案1：使用 script 标签 -->
<script type="text/html" id="my-comp-template">
  <div>
    <p>这是组件模板</p>
  </div>
</script>

<script>
const MyComp = {
  template: '#my-comp-template'
}
</script>
```

## 迁移规则2：使用默认插槽

- Vue2: 使用 inline-template
- Vue3: 使用默认插槽

### 代码示例

```html
<!-- Vue2 写法 -->
<my-comp inline-template :msg="parentMsg">
  {{ msg }} {{ childState }}
</my-comp>

<!-- Vue3 写法 -->
<my-comp v-slot="{ childState }">
  {{ parentMsg }} {{ childState }}
</my-comp>

<!-- 子组件 -->
<template>
  <slot :childState="childState" />
</template>

<script>
export default {
  data() {
    return {
      childState: 'some data'
    }
  }
}
</script>
```
