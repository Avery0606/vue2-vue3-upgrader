# Vue2到Vue3迁移规则复杂度分析结果

## 概述

基于 migration-skills-analyst agent 对 skills 目录下89条迁移规则的分析结果。

## 统计汇总

- **总规则数：89条**
- **简单规则：49条（55.1%）**
- **复杂规则：40条（44.9%）**

## 详细分析结果

### 简单规则（共49条）

#### events-api.md（1条）
- events-api.md - 迁移规则2：根组件事件监听

#### vnode-lifecycle-events.md（3条）
- vnode-lifecycle-events.md - 迁移规则1：事件前缀变更
- vnode-lifecycle-events.md - 迁移规则2：生命周期钩子名称变更
- vnode-lifecycle-events.md - 迁移规则3：生命周期事件也可用于 HTML 元素

#### transition.md（4条）
- transition.md - 迁移规则1：过渡 class 名称变更
- transition.md - 迁移规则2：过渡组件 prop 名称变更
- transition.md - 迁移规则3：渲染函数中使用 leaveFromClass 和 enterFromClass
- transition.md - 迁移规则4：JSX 中使用 leaveFromClass 和 enterFromClass

#### keycode-modifiers.md（3条）
- keycode-modifiers.md - 迁移规则1：移除数字键码
- keycode-modifiers.md - 迁移规则3：特殊字符按键
- keycode-modifiers.md - 迁移规则4：无法匹配的特殊字符

#### key-attribute.md（4条）
- key-attribute.md - 迁移规则1：v-if/v-else 分支 key 不再必需
- key-attribute.md - 迁移规则2：手动 key 必须唯一
- key-attribute.md - 迁移规则3：template v-for 的 key 位置
- key-attribute.md - 迁移规则4：template v-for 子节点存在 v-if 时的 key 位置

#### global-api.md（6条）
- global-api.md - 迁移规则1：Vue.component 替换为 app.component
- global-api.md - 迁移规则2：Vue.directive 替换为 app.directive
- global-api.md - 迁移规则5：Vue.prototype 替换为 app.config.globalProperties
- global-api.md - 迁移规则7：移除 config.productionTip
- global-api.md - 迁移规则8：config.ignoredElements 替换为 isCustomElement
- global-api.md - 迁移规则10：应用 provide/inject

#### global-api-treeshaking.md（4条）
- global-api-treeshaking.md - 迁移规则2：实例方法替代全局方法
- global-api-treeshaking.md - 迁移规则3：插件中使用全局 API
- global-api-treeshaking.md - 迁移规则5：内部帮助器具名导出
- global-api-treeshaking.md - 迁移规则6：插件打包工具配置

#### functional-components.md（3条）
- functional-components.md - 迁移规则4：h 函数需要全局导入
- functional-components.md - 迁移规则5：SFC 中 props 需要改为 $props
- functional-components.md - 迁移规则6：listeners 已合并到 $attrs 中

#### custom-directives.md（4条）
- custom-directives.md - 迁移规则1：指令钩子重命名
- custom-directives.md - 迁移规则2：访问组件实例方式变更
- custom-directives.md - 迁移规则3：移除 update 钩子
- custom-directives.md - 迁移规则4：移除 binding.expression

#### attribute-coercion.md（2条）
- attribute-coercion.md - 迁移规则3：contenteditable 行为
- attribute-coercion.md - 迁移规则4：spellcheck 行为

#### async-components.md（1条）
- async-components.md - 迁移规则1：使用 defineAsyncComponent

#### attrs-includes-class-style.md（1条）
- attrs-includes-class-style.md - 迁移规则2：访问 class 和 style

#### custom-elements-interop.md（1条）
- custom-elements-interop.md - 迁移规则3：DOM 模板中使用 vue: 前缀

#### data-option.md（1条）
- data-option.md - 迁移规则1：data 必须是函数

#### emits-option.md（2条）
- emits-option.md - 迁移规则1：使用 emits 选项声明事件
- emits-option.md - 迁移规则3：未声明事件绑定到根元素

#### inline-template-attribute.md（1条）
- inline-template-attribute.md - 迁移规则1：移除 inline-template

#### mount-changes.md（1条）
- mount-changes.md - 迁移规则1：挂载行为变更

#### props-data.md（1条）
- props-data.md - 迁移规则1：移除 propsData 选项

#### render-function-api.md（1条）
- render-function-api.md - 迁移规则1：h 函数全局导入

#### slots-unification.md（1条）
- slots-unification.md - 迁移规则2：移除 $scopedSlots

#### transition-group.md（2条）
- transition-group.md - 迁移规则1：不再默认渲染根元素
- transition-group.md - 迁移规则2：依赖默认 span 根元素的情况

#### watch.md（1条）
- watch.md - 迁移规则1：侦听数组需要 deep 选项

#### filters.md（2条）
- filters.md - 迁移规则1：本地过滤器替换为计算属性
- filters.md - 迁移规则2：全局过滤器替换为 globalProperties

### 复杂规则（共40条）

#### events-api.md（4条）
- events-api.md - 迁移规则1：移除事件总线 API
- events-api.md - 迁移规则3：使用 Pinia 替代事件总线
- events-api.md - 迁移规则4：组件内部监听自身事件
- events-api.md - 迁移规则5：使用 provide/inject 和插槽替代事件总线

#### keycode-modifiers.md（1条）
- keycode-modifiers.md - 迁移规则2：移除 config.keyCodes

#### global-api.md（5条）
- global-api.md - 迁移规则3：Vue.config 替换为 app.config
- global-api.md - 迁移规则4：Vue.use 替换为 app.use（中等规则）
- global-api.md - 迁移规则6：Vue.extend 移除，改用 defineComponent
- global-api.md - 迁移规则9：app.mount 挂载行为变更
- global-api.md - 迁移规则11：Vue.mixin 替换为 app.mixin

#### global-api-treeshaking.md（2条）
- global-api-treeshaking.md - 迁移规则1：具名导入替代全局 API
- global-api-treeshaking.md - 迁移规则4：受影响的全局 API

#### functional-components.md（3条）
- functional-components.md - 迁移规则1：移除 functional 选项
- functional-components.md - 迁移规则2：SFC 中移除 functional attribute
- functional-components.md - 迁移规则3：函数式组件参数变更

#### custom-directives.md（1条）
- custom-directives.md - 迁移规则5：多根组件中自定义指令行为

#### attribute-coercion.md（2条）
- attribute-coercion.md - 迁移规则1：false 值不再移除 attribute
- attribute-coercion.md - 迁移规则2：枚举 attribute 变为普通 attribute

#### async-components.md（2条）
- async-components.md - 迁移规则2：带选项的异步组件（中等规则）
- async-components.md - 迁移规则3：loader 函数不再接收 resolve 和 reject

#### attrs-includes-class-style.md（1条）
- attrs-includes-class-style.md - 迁移规则1：$attrs 包含所有属性

#### children.md（1条）
- children.md - 迁移规则1：移除 $children

#### custom-elements-interop.md（2条）
- custom-elements-interop.md - 迁移规则1：配置自定义元素
- custom-elements-interop.md - 迁移规则2：is attribute 限制（中等规则）

#### data-option.md（1条）
- data-option.md - 迁移规则2：mixin 合并变为浅合并

#### emits-option.md（1条）
- emits-option.md - 迁移规则2：emits 选项对象形式（带验证）（中等规则）

#### inline-template-attribute.md（1条）
- inline-template-attribute.md - 迁移规则2：使用默认插槽（中等规则）

#### listeners-removed.md（2条）
- listeners-removed.md - 迁移规则1：移除 $listeners（中等规则）
- listeners-removed.md - 迁移规则2：$attrs 现在包含事件（中等规则）

#### props-default-this.md（1条）
- props-default-this.md - 迁移规则1：prop 默认函数无法访问 this（中等规则）

#### render-function-api.md（2条）
- render-function-api.md - 迁移规则2：VNode prop 结构扁平化
- render-function-api.md - 迁移规则3：组件注册和引用

#### slots-unification.md（1条）
- slots-unification.md - 迁移规则1：渲染函数中插槽用法变更

#### transition-as-root.md（1条）
- transition-as-root.md - 迁移规则1：根节点 transition 需要内部状态控制

#### v-on-native-modifier-removed.md（2条）
- v-on-native-modifier-removed.md - 迁移规则1：移除 .native 修饰符
- v-on-native-modifier-removed.md - 迁移规则2：emits 选项的使用

#### v-bind.md（1条）
- v-bind.md - 迁移规则1：v-bind 合并顺序行为变更

#### v-model.md（6条）
- v-model.md - 迁移规则1：组件 v-model 的默认 prop 和事件名称变更
- v-model.md - 迁移规则2：组件内部 prop 和事件声明变更
- v-model.md - 迁移规则3：v-bind.sync 替换为 v-model:prop
- v-model.md - 迁移规则4：多个 v-model 绑定
- v-model.md - 迁移规则5：自定义 v-model 修饰符
- v-model.md - 迁移规则6：移除 model 选项

#### v-if-v-for.md（1条）
- v-if-v-for.md - 迁移规则1：v-if 与 v-for 优先级变更

## 分析结论

1. **简单规则占多数**：55.1%的规则属于简单规则，主要是API重命名、语法调整等
2. **复杂规则比例较高**：44.9%的规则涉及架构变更或系统性重构
3. **关键复杂领域**：
   - 事件系统重构（events-api.md）
   - 全局API变更（global-api.md）
   - 组件通信模式变更（v-model.md, emits-option.md）
   - 渲染函数API变更（render-function-api.md）
   - 函数式组件重构（functional-components.md）

## 迁移建议

1. **优先处理简单规则**：快速完成55%的迁移工作
2. **重点规划复杂规则**：对40%的复杂规则制定详细的迁移策略
3. **分阶段实施**：按模块和影响范围分阶段进行迁移
4. **充分测试**：特别是复杂规则，需要全面的测试验证

---

*分析时间：2026-01-18*
*分析工具：migration-skills-analyst agent*