---
name: vue3-migration
description: 自动化 Vue2 到 Vue3 迁移技能。为 AI 编码代理提供 Vue2 大型项目到 Vue3 的迁移支持。保持 Options API 语法（不转换为 Composition API）。支持 10w+ 代码库的批量处理、vue-codemod 集成，以及基于清单的综合转换。
---

# Vue3 迁移技能

## 快速开始

```bash
# 步骤 1: 安装 vue-codemod
npm install -g @vue-codemod/cli

# 步骤 2: 运行 vue-codemod
npx @vue-codemod/cli <project-path> --transform=vue3

# 步骤 3: 修复 FIXME 问题
# 步骤 4: 执行清单修改
# 步骤 5: 构建并验证
```

## 工作流概述

此技能分 5 个阶段执行迁移：

1. **vue-codemod 批量转换** - 自动化语法转换
2. **FIXME 修复** - 复杂情况需要手动干预
3. **清单修改** - 按类别进行系统转换
4. **构建和错误修复** - 解决编译问题
5. **验证与循环** - 测试直到所有检查通过

## 第一阶段：vue-codemod

自动处理以下转换：

| 模式 | Vue 2 | Vue 3 |
|---------|-------|-------|
| 全局 API | `Vue.component()` | `app.component()` |
| v-model | `value`/`input` | `modelValue`/`update:modelValue` |
| .sync | `:prop.sync` | `v-model:prop` |
| $listeners | 独立对象 | 合并到 $attrs |
| $scopedSlots | `this.$scopedSlots` | `this.$slots`（作为函数） |
| 过滤器 | `{{ val | filter }}` | 已移除 |
| KeyCode | `.keycode.13` | `.enter` |
| 自定义指令 | `bind`/`inserted` | `beforeMount`/`mounted` |

```bash
# 先进行空运行
npx @vue-codemod/cli ./src --transform=vue3 --dry

# 应用更改
npx @vue-codemod/cli ./src --transform=vue3

# 生成报告
```

## 第二阶段：FIXME 修复

vue-codemod 用 `// FIXME: ` 注释标记复杂更改。

**常见的 FIXME 模式：**

```javascript
// FIXME: v-model prop/event 重命名 - 需要手动审查
// FIXME: 自定义指令钩子映射
// FIXME: 检测到事件总线使用 - 需要 mitt 替换
// FIXME: 函数式组件 - 必须重写为有状态组件
```

**修复策略：**

```bash
# 查找所有 FIXME 注释
rg "// FIXME:" --type vue --type js

# 按文件和类型分组
# 系统地修复，每组之后测试
```

## 第三阶段：清单修改

按优先级从高到低顺序执行这些修改：

### 3.1 全局 API（关键）

**文件：** `main.js`, `main.ts`, 插件文件, 全局注册

```javascript
// Vue 2 → Vue 3
Vue.component('name', opts) → app.component('name', opts)
Vue.directive('name', opts) → app.directive('name', opts)
Vue.mixin(opts) → app.mixin(opts)
Vue.use(plugin) → app.use(plugin)
Vue.prototype → app.config.globalProperties
Vue.config → app.config
Vue.extend(opts) → 已移除（使用 createApp）

beforeCreate → setup() 或保持在 options API 中
```

**模式搜索：**

```bash
rg "Vue\.component" --type vue
rg "Vue\.directive" --type vue
rg "Vue\.mixin" --type vue
rg "Vue\.use" --type vue
rg "Vue\.prototype" --type vue
rg "Vue\.config" --type vue
rg "Vue\.extend" --type vue
```

### 3.2 v-model（关键）

**子组件更改：**

```javascript
// 之前（Vue 2）
export default {
  props: ['value'],
  model: {
    prop: 'value',
    event: 'input'
  },
  methods: {
    update(value) {
      this.$emit('input', value)
    }
  }
}

// 之后（Vue 3）
export default {
  props: ['modelValue'],
  emits: ['update:modelValue'],
  methods: {
    update(value) {
      this.$emit('update:modelValue', value)
    }
  }
}
```

**.sync 替换：**

```html
<!-- 之前 -->
<ChildComponent :title.sync="pageTitle" />

<!-- 之后 -->
<ChildComponent v-model:title="pageTitle" />
```

**模式搜索：**

```bash
rg "v-model" --type vue
rg "\.sync" --type vue
rg "model:\s*\{" --type vue
rg "\$emit\('input'" --type vue
```

### 3.3 生命周期钩子（关键）

```javascript
// 重命名的钩子
beforeDestroy → beforeUnmount
destroyed → unmounted

// 查找并替换
rg "beforeDestroy" --type vue
rg "destroyed" --type vue
```

### 3.4 过滤器（关键 - 会破坏构建）

**替换策略：**

```javascript
// 过滤器定义
filters: {
  currencyUSD(value) {
    return '$' + value
  }
}

// 选项 A: 方法
methods: {
  currencyUSD(value) {
    return '$' + value
  }
}

// 模板使用
{{ currencyUSD(accountBalance) }}

// 选项 B: 计算属性
computed: {
  accountInUSD() {
    return '$' + this.accountBalance
  }
}
```

**模式搜索：**

```bash
rg "filters:" --type vue
rg "\|\s*\w+" --type vue
```

### 3.5 事件 API（关键 - 会破坏构建）

```javascript
// 完全移除
this.$on('event', handler) // 已移除
this.$off('event', handler) // 已移除
this.$once('event', handler) // 已移除

// 替换为 mitt
import mitt from 'mitt'
const emitter = mitt()

// 或 tiny-emitter
import tinyEmitter from 'tiny-emitter/instance'
```

**模式搜索：**

```bash
rg "\$on" --type vue
rg "\$off" --type vue
rg "\$once" --type vue
rg "eventBus" --type js
```

### 3.6 自定义指令（高优先级）

**钩子映射：**

| Vue 2 | Vue 3 |
|-------|-------|
| bind | beforeMount |
| inserted | mounted |
| update | 已移除（使用 updated） |
| componentUpdated | updated |
| unbind | unmounted |

**新的 Vue 3 钩子：**
- `created` - 属性应用之前
- `beforeUpdated` - 元素更新之前
- `beforeUnmount` - 元素卸载之前

**binding.expression 已移除：**

```javascript
// 之前
binding.expression

// 之后
binding.value
```

**模式搜索：**

```bash
rg "bind:" --type vue
rg "inserted:" --type vue
rg "update:" --type vue
rg "componentUpdated:" --type vue
rg "unbind:" --type vue
rg "binding\.expression" --type vue
```

### 3.7 异步组件（高优先级）

```javascript
// 之前（Vue 2）
const AsyncComponent = () => import('./Component.vue')
// 或
const AsyncComponent = {
  component: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000
}

// 之后（Vue 3）
import { defineAsyncComponent } from 'vue'
const AsyncComponent = defineAsyncComponent(() => import('./Component.vue'))
// 或
const AsyncComponent = defineAsyncComponent({
  loader: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000
})
```

**模式搜索：**

```bash
rg "component:\s*=>\s*import" --type vue
rg "component:\s*:" --type vue
```

### 3.8 函数式组件（高优先级）

```javascript
// 之前（Vue 2）
export default {
  functional: true,
  props: ['level'],
  render(h, { props, data, children }) {
    return h(`h${props.level}`, data, children)
  }
}

// 之后（Vue 3）- 必须转换为有状态组件
export default {
  props: ['level'],
  template: `<h{{ level }}><slot /></h{{ level }}>`
  // 或使用导入的 h 保留 render 函数
}
```

**模式搜索：**

```bash
rg "functional:\s*true" --type vue
rg "<template\s+functional>" --type vue
```

### 3.9 emits 选项（高优先级 - 推荐）

```javascript
export default {
  emits: ['click', 'update:value', 'close']
  // 验证
  emits: {
    click: null,
    update:value: (value) => typeof value === 'number'
  }
}
```

**模式搜索：**

```bash
rg "emits:" --type vue
rg "v-on:click" --type vue
```

### 3.10 插槽（中等优先级）

```javascript
// $scopedSlots 已移除
this.$scopedSlots.slotName → this.$slots.slotName()

// $slots 现在是函数
this.$slots.default → this.$slots.default()
```

**模式搜索：**

```bash
rg "\$scopedSlots" --type vue
rg "\$slots" --type vue
```

### 3.11 $attrs（中等优先级）

```javascript
// $attrs 现在包含 class 和 style
// 无需操作，但会影响 inheritAttrs 行为
```

### 3.12 v-on.native（中等优先级）

```html
<!-- 之前 -->
<ChildComponent @click.native="handler" />

<!-- 之后 -->
<ChildComponent @click="handler" />
```

**模式搜索：**

```bash
rg "\.native" --type vue
```

### 3.13 Data 选项（中等优先级）

```javascript
// Vue 2 允许对象
data: { count: 0 }

// Vue 3 必须是函数
data() {
  return { count: 0 }
}

// Mixin 浅合并
```

**模式搜索：**

```bash
rg "^\s+data:\s*\{" --type vue
```

### 3.14 Watch 数组（中等优先级）

```javascript
// Vue 2: 变更时触发
watch: {
  list() { /* 触发 */ }
}

// Vue 3: 仅替换时触发
watch: {
  list() { /* 变更时不会触发 */ }
}

// 添加 deep 选项
watch: {
  list: {
    handler() { /* 触发 */ },
    deep: true
  }
}
```

**模式搜索：**

```bash
rg "watch:\s*\{" --type vue
```

### 3.15 过渡类（低优先级）

```css
/* 之前 */
.v-enter,
.v-leave-to { opacity: 0; }

/* 之后 */
.v-enter-from,
.v-leave-to { opacity: 0; }
```

**模式搜索：**

```bash
rg "\.v-enter" --type css
rg "\.v-leave" --type css
```

### 3.16 模板 Key（低优先级）

```html
<!-- 之前 -->
<template v-for="item in list">
  <div :key="item.id">...</div>
</template>

<!-- 之后 -->
<template v-for="item in list" :key="item.id">
  <div>...</div>
</template>
```

**模式搜索：**

```bash
rg "<template\s+v-for" --type vue
```

### 3.17 v-if/v-for 优先级（低优先级）

```html
<!-- 避免在同一个元素上 -->
<!-- Vue 3 中 v-if 优先于 v-for -->

<!-- 使用计算属性替代 -->
<template v-for="item in visibleItems">
  <div v-if="item.isVisible">...</div>
</template>
```

### 3.18 v-bind 顺序（低优先级）

```html
<!-- Vue 3 中顺序很重要 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- 结果: id="blue"（v-bind 获胜） -->

<div v-bind="{ id: 'blue' }" id="red"></div>
<!-- 结果: id="red"（静态获胜） -->
```

## 第四阶段：构建和错误修复

```bash
# 运行构建
npm run build

# 常见错误：
# 1. 'Vue' 未定义 → import { createApp } from 'vue'
# 2. v-model prop 缺失 → 添加 modelValue prop
# 3. beforeDestroy 未找到 → 重命名为 beforeUnmount
# 4. 自定义指令钩子 → 更新名称
# 5. 过滤器未找到 → 转换为方法
# 6. $on/$off/$once → 替换为 mitt

# 迭代修复直到构建通过
```

## 第五阶段：验证

```bash
# 运行测试
npm test

# 手动验证
# - 所有页面渲染
# - 所有交互工作
# - API 调用功能
# - 无控制台错误

# 如果失败 → 返回第三阶段
```

## 完整清单

### 关键（破坏构建）
- [ ] Vue.extend → createApp/defineComponent
- [ ] v-model value → modelValue, input → update:modelValue
- [ ] beforeDestroy → beforeUnmount
- [ ] destroyed → unmounted
- [ ] 过滤器移除 → methods/computed
- [ ] $on/$off/$once 移除 → mitt/tiny-emitter
- [ ] 全局 API 移动到 app 实例

### 高优先级（功能）
- [ ] .sync → v-model:
- [ ] v-on.native 移除
- [ ] 自定义指令钩子重命名
- [ ] 异步组件使用 defineAsyncComponent
- [ ] 函数式组件已转换
- [ ] 添加 emit 选项

### 中等优先级（最佳实践）
- [ ] $scopedSlots → $slots（作为函数）
- [ ] $listeners 移除
- [ ] $attrs 包含 class/style
- [ ] Data 作为函数
- [ ] Mixin 浅合并
- [ ] Watch 数组 deep 选项

### 低优先级（清理）
- [ ] 过渡类重命名
- [ ] 模板 key 放置
- [ ] v-if/v-for 优先级
- [ ] v-bind 顺序
- [ ] 函数式模板属性移除

## 文件搜索模式

```bash
# 全局 API
rg "Vue\.component" --type vue
rg "Vue\.directive" --type vue
rg "Vue\.mixin" --type vue
rg "Vue\.use" --type vue
rg "Vue\.prototype" --type vue
rg "Vue\.extend" --type vue

# v-model
rg "v-model" --type vue
rg "\.sync" --type vue

# 生命周期
rg "beforeDestroy" --type vue
rg "destroyed" --type vue

# 事件
rg "\$on" --type vue
rg "\$off" --type vue
rg "\$once" --type vue

# 指令
rg "bind:" --type vue
rg "inserted:" --type vue

# 过滤器
rg "filters:" --type vue

# 插槽
rg "\$scopedSlots" --type vue
```

## 进度报告

```markdown
第一阶段: vue-codemod 转换
  ✅ 完成: /src/components/**/*.vue
  ⏳ 进行中: /src/views/**/*.vue
  ⏸ 待处理: /src/**/*.{js,ts}

第二阶段: FIXME 修复
  📍 发现 247 个 FIXME 注释
  📍 已修复 123 个 (50%)
  📍 剩余: 124 个

第三阶段: 清单执行
  📍 关键: 7/7 完成
  📍 高优先级: 6/6 完成
  📍 中等优先级: 5/6 完成
  📍 低优先级: 3/5 完成
```

## 成功标准

迁移完成当：
- ✅ npm run build 通过（退出码 0）
- ✅ 所有测试通过
- ✅ 未检测到 Vue2 语法
- ✅ 所有功能与之前一样工作
- ✅ 性能保持/改进

## 相关迁移

要完成 Vue3 迁移，还需要处理：
- **Vuex 3.x → Pinia**: 单独迁移
- **Vue Router 3.x → 4.x**: 单独迁移
- **Element UI → Element Plus**: 如果使用 Element UI

## 关键原则

1. **保留 Options API**: 除非被要求，否则不要转换为 Composition API
2. **业务逻辑**: 保持 methods、computed、watchers 完全相同
3. **测试**: 每个阶段后进行全面测试
4. **备份**: 开始前进行 Git 备份
5. **增量**: 分批处理，经常测试

## 使用场景

在以下情况使用此技能：
- 将 Vue2 项目迁移到 Vue3
- 保持 Options API 语法
- 处理 10w+ 代码库
- 需要系统化的、清单驱动的方法
- 需要变更审计追踪

不要在以下情况使用：
- 转换为 Composition API（不同的技能）
- 仅升级 Vue Router/Vuex（使用它们的迁移指南）
- 小项目（手动迁移更快）
