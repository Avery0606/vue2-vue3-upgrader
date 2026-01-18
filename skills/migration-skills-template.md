---
name: migration-skills-template
description: 迁移skills模板文件
---



# 迁移规则概览



## 迁移规则1

- Vue2: 使用 :value.sync
- Vue3: 使用 v-model:value.sync

### 代码示例

```html
<!-- Vue2 写法 -->
<el-dialog :visible.sync="visible" />

<!-- Vue3 写法 -->
<el-dialog v-model:visible="visible" />
```

## 迁移规则2

- Vue2: xxx
- Vue3: xxx

### 代码示例

```javascript
// Vue2 写法

// Vue3 写法
```