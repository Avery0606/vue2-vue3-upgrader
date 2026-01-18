---
name: custom-elements-interop
description: 与自定义元素互操作性变化，is attribute 限制使用，isCustomElement 配置移至编译时
---



# 迁移规则概览



## 迁移规则1：配置自定义元素

- Vue2: 使用 Vue.config.ignoredElements 配置
- Vue3: 使用编译器选项配置

### 代码示例

```javascript
// Vue2 写法
Vue.config.ignoredElements = ['plastic-button']

// Vue3 写法 - 动态模板编译
const app = createApp({})
app.config.compilerOptions.isCustomElement = tag => tag === 'plastic-button'

// Vue3 写法 - 构建步骤（webpack）
module.exports = {
  rules: [
    {
      test: /\.vue$/,
      use: 'vue-loader',
      options: {
        compilerOptions: {
          isCustomElement: tag => tag === 'plastic-button'
        }
      }
    }
  ]
}
```

## 迁移规则2：is attribute 限制

- Vue2: is 可用于任何组件
- Vue3: is 限制在 <component> 标签

### 代码示例

```html
<!-- Vue2 写法 -->
<button is="plastic-button">点击我!</button>

<!-- Vue3 写法 - 自定义内置元素 -->
<button is="plastic-button">点击我!</button>
<!-- 渲染为原生 button，is 作为属性传递 -->

<!-- Vue3 写法 - 动态组件 -->
<component :is="plastic-button"></component>
```

## 迁移规则3：DOM 模板中使用 vue: 前缀

- Vue2: 使用 is 绕过 DOM 解析限制
- Vue3: 使用 vue: 前缀

### 代码示例

```html
<!-- Vue2 写法 -->
<table>
  <tr is="blog-post-row"></tr>
</table>

<!-- Vue3 写法 -->
<table>
  <tr is="vue:blog-post-row"></tr>
</table>
```
