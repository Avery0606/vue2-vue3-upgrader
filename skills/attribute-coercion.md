---
name: attribute-coercion
description: attribute 强制行为变化，移除枚举概念，false 值改为字符串
---



# 迁移规则概览



## 迁移规则1：false 值不再移除 attribute

- Vue2: false 值移除 attribute
- Vue3: false 值设置为 attr="false"

### 代码示例

```html
<!-- Vue2 写法 -->
<div :aria-selected="false">content</div>
<!-- 结果：<div>content</div> （移除） -->

<!-- Vue3 写法 -->
<div :aria-selected="false">content</div>
<!-- 结果：<div aria-selected="false">content</div> -->

<!-- 要移除 attribute，使用 null 或 undefined -->
<div :aria-selected="null">content</div>
<!-- 结果：<div>content</div> （移除） -->
```

## 迁移规则2：枚举 attribute 变为普通 attribute

- Vue2: draggable 等枚举 attribute 有特殊处理
- Vue3: 视为普通非布尔 attribute

### 代码示例

```html
<!-- Vue2 写法 -->
<div :draggable="true">content</div>
<!-- 结果：<div draggable="true">content</div> -->

<div :draggable="false">content</div>
<!-- 结果：<div>content</div> （移除） -->

<!-- Vue3 写法 -->
<div :draggable="true">content</div>
<!-- 结果：<div draggable="true">content</div> -->

<div :draggable="false">content</div>
<!-- 结果：<div draggable="false">content</div> （不移除） -->

<div :draggable="null">content</div>
<!-- 结果：<div>content</div> （移除） -->
```

## 迁移规则3：contenteditable 行为

- Vue2: contenteditable null 值转为 'false'
- Vue3: 需要显式设置 false 或 'false'

### 代码示例

```html
<!-- Vue2 写法 -->
<div :contenteditable="null">content</div>
<!-- 结果：<div contenteditable="false">content</div> -->

<!-- Vue3 写法 -->
<div :contenteditable="false">content</div>
<!-- 结果：<div contenteditable="false">content</div> -->

<!-- 要保持原有行为，显式使用 false -->
<div :contenteditable="false">content</div>
```
