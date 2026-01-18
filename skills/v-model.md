---
name: v-model
description: v-model 指令的双向绑定 API 变化，包括 prop/event 默认名称更改、.sync 修饰符移除、支持多参数绑定和自定义修饰符
---



# 迁移规则概览



## 迁移规则1：组件 v-model 的默认 prop 和事件名称变更

- Vue2: 使用 `value` prop 和 `input` 事件
- Vue3: 使用 `modelValue` prop 和 `update:modelValue` 事件

### 代码示例

```html
<!-- Vue2 写法 -->
<ChildComponent v-model="pageTitle" />
<!-- 等价于 -->
<ChildComponent :value="pageTitle" @input="pageTitle = $event" />

<!-- Vue3 写法 -->
<ChildComponent v-model="pageTitle" />
<!-- 等价于 -->
<ChildComponent
  :modelValue="pageTitle"
  @update:modelValue="pageTitle = $event"
/>
```

## 迁移规则2：组件内部 prop 和事件声明变更

- Vue2: props 中使用 `value`，$emit 使用 'input'
- Vue3: props 中使用 `modelValue`，$emit 使用 'update:modelValue'，emits 中声明

### 代码示例

```javascript
// Vue2 写法
export default {
  props: {
    value: String
  },
  methods: {
    changeValue(newValue) {
      this.$emit('input', newValue)
    }
  }
}

// Vue3 写法
export default {
  props: {
    modelValue: String
  },
  emits: ['update:modelValue'],
  methods: {
    changeValue(newValue) {
      this.$emit('update:modelValue', newValue)
    }
  }
}
```

## 迁移规则3：v-bind.sync 替换为 v-model:prop

- Vue2: 使用 `v-bind:prop.sync` 语法
- Vue3: 使用 `v-model:prop` 语法，支持多参数绑定

### 代码示例

```html
<!-- Vue2 写法 -->
<ChildComponent :title.sync="pageTitle" />
<!-- 等价于 -->
<ChildComponent :title="pageTitle" @update:title="pageTitle = $event" />

<!-- Vue3 写法 -->
<ChildComponent v-model:title="pageTitle" />
<!-- 等价于 -->
<ChildComponent :title="pageTitle" @update:title="pageTitle = $event" />
```

## 迁移规则4：多个 v-model 绑定

- Vue2: 不支持，只能使用多个 .sync 或 model 选项
- Vue3: 支持在同一个组件上使用多个 v-model

### 代码示例

```html
<!-- Vue2 写法 -->
<ChildComponent
  :title.sync="pageTitle"
  :content.sync="pageContent"
/>

<!-- Vue3 写法 -->
<ChildComponent
  v-model:title="pageTitle"
  v-model:content="pageContent"
/>
```

## 迁移规则5：自定义 v-model 修饰符

- Vue2: 只支持硬编码修饰符如 .trim、.number
- Vue3: 支持自定义修饰符

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- 只能使用内置修饰符 -->
<input v-model.trim="text" />

<!-- Vue3 写法 -->
<!-- 支持自定义修饰符 -->
<ChildComponent v-model.capitalize="pageTitle" />
```

## 迁移规则6：移除 model 选项

- Vue2: 使用 `model` 选项自定义 v-model 的 prop 和事件
- Vue3: 移除 model 选项，改用 v-model 参数

### 代码示例

```javascript
// Vue2 写法
export default {
  model: {
    prop: 'title',
    event: 'change'
  },
  props: {
    title: {
      type: String,
      default: 'Default title'
    }
  }
}
<!-- 使用时： -->
<ChildComponent v-model="pageTitle" />
<!-- 等价于 -->
<ChildComponent :title="pageTitle" @change="pageTitle = $event" />

// Vue3 写法
export default {
  props: {
    title: {
      type: String,
      default: 'Default title'
    }
  },
  emits: ['update:title']
}
<!-- 使用时： -->
<ChildComponent v-model:title="pageTitle" />
<!-- 等价于 -->
<ChildComponent :title="pageTitle" @update:title="pageTitle = $event" />
```
