---
name: transition-group
description: Transition Group 根元素变更，不再默认渲染包裹器元素
---



# 迁移规则概览



## 迁移规则1：不再默认渲染根元素

- Vue2: 默认渲染 <span> 作为根元素
- Vue3: 不再默认渲染根元素，需要显式指定 tag 属性

### 代码示例

```html
<!-- Vue2 写法 -->
<transition-group>
  <li v-for="item in items" :key="item">
    {{ item }}
  </li>
</transition-group>
<!-- 默认渲染 <span> 包裹 -->

<!-- Vue3 写法 -->
<!-- 需要显式指定 tag -->
<transition-group tag="ul">
  <li v-for="item in items" :key="item">
    {{ item }}
  </li>
</transition-group>

<!-- 或者不需要根元素 -->
<transition-group>
  <li v-for="item in items" :key="item">
    {{ item }}
  </li>
</transition-group>
<!-- 不渲染包裹元素，直接渲染 li -->
```

## 迁移规则2：依赖默认 span 根元素的情况

- Vue2: 默认使用 <span> 作为根元素
- Vue3: 需要显式指定 tag="span" 来保持原有行为

### 代码示例

```html
<!-- Vue2 写法 -->
<transition-group>
  <div v-for="item in items" :key="item">
    {{ item }}
  </div>
</transition-group>

<!-- Vue3 写法 - 如果依赖 span 包裹 -->
<transition-group tag="span">
  <div v-for="item in items" :key="item">
    {{ item }}
  </div>
</transition-group>
```
