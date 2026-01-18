---
name: transition-as-root
description: Transition 作为根节点时，从外部切换不再触发过渡效果
---



# 迁移规则概览



## 迁移规则1：根节点 transition 需要内部状态控制

- Vue2: 使用 <transition> 作为根节点，外部切换触发过渡
- Vue3: 外部切换不再触发过渡，需要通过 prop 控制

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- Modal.vue -->
<template>
  <transition>
    <div class="modal"><slot/></div>
  </transition>
</template>

<!-- 使用 -->
<modal v-if="showModal">hello</modal>

<!-- Vue3 写法 -->
<!-- Modal.vue -->
<template>
  <transition>
    <div v-if="show" class="modal"><slot/></div>
  </transition>
</template>
<script>
export default {
  props: ['show']
}
</script>

<!-- 使用 -->
<modal :show="showModal">hello</modal>
```
