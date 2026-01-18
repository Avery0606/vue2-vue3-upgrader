---
name: keycode-modifiers
description: 按键修饰符变化，不再支持数字键码，使用 kebab-case 命名的按键
---



# 迁移规则概览



## 迁移规则1：移除数字键码

- Vue2: 使用数字作为 v-on 修饰符
- Vue3: 不再支持数字，使用 kebab-case 按键名称

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- 键码版本 -->
<input v-on:keyup.13="submit" />

<!-- Vue3 写法 -->
<!-- 使用按键名称 -->
<input v-on:keyup.enter="submit" />
```

## 迁移规则2：移除 config.keyCodes

- Vue2: 使用 Vue.config.keyCodes 自定义别名
- Vue3: 移除此配置，直接使用按键名称

### 代码示例

```javascript
// Vue2 写法
Vue.config.keyCodes = {
  f1: 112
}
```

```html
<!-- Vue2 写法 -->
<!-- 自定义别名版本 -->
<input v-on:keyup.f1="showHelpText" />

<!-- Vue3 写法 -->
<!-- 直接使用按键名称 -->
<input v-on:keyup.page-down="nextPage">
<!-- 同时匹配 q 和 Q -->
<input v-on:keypress.q="quit">
```

## 迁移规则3：特殊字符按键

- Vue2: 使用 config.keyCodes 定义特殊字符
- Vue3: 对于标点符号键，直接包含在修饰符中

### 代码示例

```html
<!-- Vue3 写法 -->
<!-- 逗号键 -->
<input v-on:keypress.,="commaPress">

<!-- 某些特殊字符需要在监听器内处理 -->
<input v-on:keypress="handleKeyPress">
<script>
export default {
  methods: {
    handleKeyPress(event) {
      if (event.key === '"') {
        // 处理双引号
      }
    }
  }
}
</script>
```
