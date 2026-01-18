---
name: transition
description: 过渡 class 名称更改，v-enter 改为 v-enter-from，v-leave 改为 v-leave-from
---



# 迁移规则概览



## 迁移规则1：过渡 class 名称变更

- Vue2: 使用 v-enter 和 v-leave
- Vue3: 使用 v-enter-from 和 v-leave-from

### 代码示例

```css
/* Vue2 写法 */
.v-enter,
.v-leave-to {
  opacity: 0;
}

.v-leave,
.v-enter-to {
  opacity: 1;
}

/* Vue3 写法 */
.v-enter-from,
.v-leave-to {
  opacity: 0;
}

.v-leave-from,
.v-enter-to {
  opacity: 1;
}
```

## 迁移规则2：过渡组件 prop 名称变更

- Vue2: 使用 enter-class 和 leave-class
- Vue3: 使用 enter-from-class 和 leave-from-class

### 代码示例

```html
<!-- Vue2 写法 -->
<transition
  enter-class="fade-enter"
  leave-class="fade-leave"
>
  <div v-if="show">Hello</div>
</transition>

<!-- Vue3 写法 -->
<transition
  enter-from-class="fade-enter-from"
  leave-from-class="fade-leave-from"
>
  <div v-if="show">Hello</div>
</transition>
```

## 迁移规则3：渲染函数中使用 leaveFromClass 和 enterFromClass

- Vue2: 使用 props 中的 'leave-class' 和 'enter-class'
- Vue3: 使用 leaveFromClass 和 enterFromClass

### 代码示例

```javascript
// Vue2 写法
import { h } from 'vue'
import { Transition } from 'vue'

h(Transition, {
  props: {
    'leave-class': 'leave-active',
    'enter-class': 'enter-active'
  }
})

// Vue3 写法
import { h } from 'vue'
import { Transition } from 'vue'

h(Transition, {
  leaveFromClass: 'leave-from',
  enterFromClass: 'enter-from'
})
```

## 迁移规则4：JSX 中使用 leaveFromClass 和 enterFromClass

- Vue2: JSX 中使用 leaveClass 和 enterClass
- Vue3: JSX 中使用 leaveFromClass 和 enterFromClass

### 代码示例

```jsx
// Vue2 写法
<Transition leaveClass="leave-active" enterClass="enter-active">
  ...
</Transition>

// Vue3 写法
<Transition leaveFromClass="leave-from" enterFromClass="enter-from">
  ...
</Transition>
```
