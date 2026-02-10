---
name: vue3-migration
description: Automated Vue2 to Vue3 migration skill for AI coding agents. Migrates large Vue2 projects to Vue3 while maintaining Options API syntax (no conversion to Composition API). Supports 10w+ codebases with batch processing, vue-codemod integration, and comprehensive checklist-based transformations.
---

# Vue3 Migration Skill

## Quick Start

```bash
# Step 1: Install vue-codemod
npm install -g @vue-codemod/cli

# Step 2: Run vue-codemod
npx @vue-codemod/cli <project-path> --transform=vue3

# Step 3: Fix FIXME issues
# Step 4: Execute checklist modifications
# Step 5: Build and verify
```

## Workflow Overview

This skill executes migration in 5 phases:

1. **vue-codemod Batch Transformation** - Automated syntax conversion
2. **FIXME Fixes** - Manual intervention for complex cases
3. **Checklist Modifications** - Systematic transformation by category
4. **Build & Error Fix** - Resolve compilation issues
5. **Verification & Loop** - Test until all checks pass

## Phase 1: vue-codemod

Handles these transformations automatically:

| Pattern | Vue 2 | Vue 3 |
|---------|-------|-------|
| Global API | `Vue.component()` | `app.component()` |
| v-model | `value`/`input` | `modelValue`/`update:modelValue` |
| .sync | `:prop.sync` | `v-model:prop` |
| $listeners | Separate object | Merged into $attrs |
| $scopedSlots | `this.$scopedSlots` | `this.$slots` (as functions) |
| Filters | `{{ val \| filter }}` | Removed |
| KeyCode | `.keycode.13` | `.enter` |
| Custom Directives | `bind`/`inserted` | `beforeMount`/`mounted` |

```bash
# Dry run first
npx @vue-codemod/cli ./src --transform=vue3 --dry

# Apply changes
npx @vue-codemod/cli ./src --transform=vue3

# Report generated
```

## Phase 2: FIXME Fixes

vue-codemod marks complex changes with `// FIXME: ` comments.

**Common FIXME patterns:**

```javascript
// FIXME: v-model prop/event renamed - manual review needed
// FIXME: Custom directive hook mapping
// FIXME: Event bus usage detected - requires mitt replacement
// FIXME: Functional component - must rewrite as stateful
```

**Fix strategy:**

```bash
# Find all FIXME comments
rg "// FIXME:" --type vue --type js

# Group by file and type
# Fix systematically, testing after each group
```

## Phase 3: Checklist Modifications

Execute these modifications in order (high to low priority):

### 3.1 Global API (Critical)

**Files:** `main.js`, `main.ts`, plugin files, global registrations

```javascript
// Vue 2 → Vue 3
Vue.component('name', opts) → app.component('name', opts)
Vue.directive('name', opts) → app.directive('name', opts)
Vue.mixin(opts) → app.mixin(opts)
Vue.use(plugin) → app.use(plugin)
Vue.prototype → app.config.globalProperties
Vue.config → app.config
Vue.extend(opts) → REMOVED (use createApp)

beforeCreate → setup() or keep in options API
```

**Pattern search:**

```bash
rg "Vue\\.component" --type vue
rg "Vue\\.directive" --type vue
rg "Vue\\.mixin" --type vue
rg "Vue\\.use" --type vue
rg "Vue\\.prototype" --type vue
rg "Vue\\.config" --type vue
rg "Vue\\.extend" --type vue
```

### 3.2 v-model (Critical)

**Child component changes:**

```javascript
// Before (Vue 2)
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

// After (Vue 3)
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

**.sync replacement:**

```html
<!-- Before -->
<ChildComponent :title.sync="pageTitle" />

<!-- After -->
<ChildComponent v-model:title="pageTitle" />
```

**Pattern search:**

```bash
rg "v-model" --type vue
rg "\\.sync" --type vue
rg "model:\\s*\\{" --type vue
rg "\\$emit\\('input'" --type vue
```

### 3.3 Lifecycle Hooks (Critical)

```javascript
// Renamed hooks
beforeDestroy → beforeUnmount
destroyed → unmounted

// Find and replace
rg "beforeDestroy" --type vue
rg "destroyed" --type vue
```

### 3.4 Filters (Critical - Break Build)

**Replacement strategies:**

```javascript
// Filter definition
filters: {
  currencyUSD(value) {
    return '$' + value
  }
}

// Option A: Method
methods: {
  currencyUSD(value) {
    return '$' + value
  }
}

// Template usage
{{ currencyUSD(accountBalance) }}

// Option B: Computed
computed: {
  accountInUSD() {
    return '$' + this.accountBalance
  }
}
```

**Pattern search:**

```bash
rg "filters:" --type vue
rg "\\|\\s*\\w+" --type vue
```

### 3.5 Events API (Critical - Break Build)

```javascript
// COMPLETELY REMOVED
this.$on('event', handler) // REMOVED
this.$off('event', handler) // REMOVED
this.$once('event', handler) // REMOVED

// Replacement: mitt
import mitt from 'mitt'
const emitter = mitt()

// Or tiny-emitter
import tinyEmitter from 'tiny-emitter/instance'
```

**Pattern search:**

```bash
rg "\\$on" --type vue
rg "\\$off" --type vue
rg "\\$once" --type vue
rg "eventBus" --type js
```

### 3.6 Custom Directives (High)

**Hook mapping:**

| Vue 2 | Vue 3 |
|-------|-------|
| bind | beforeMount |
| inserted | mounted |
| update | REMOVED (use updated) |
| componentUpdated | updated |
| unbind | unmounted |

**New Vue 3 hooks:**
- `created` - Before attributes applied
- `beforeUpdate` - Before element update
- `beforeUnmount` - Before element unmount

**binding.expression removed:**

```javascript
// Before
binding.expression

// After
binding.value
```

**Pattern search:**

```bash
rg "bind:" --type vue
rg "inserted:" --type vue
rg "update:" --type vue
rg "componentUpdated:" --type vue
rg "unbind:" --type vue
rg "binding\\.expression" --type vue
```

### 3.7 Async Components (High)

```javascript
// Before (Vue 2)
const AsyncComponent = () => import('./Component.vue')
// or
const AsyncComponent = {
  component: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000
}

// After (Vue 3)
import { defineAsyncComponent } from 'vue'
const AsyncComponent = defineAsyncComponent(() => import('./Component.vue'))
// or
const AsyncComponent = defineAsyncComponent({
  loader: () => import('./Component.vue'),
  delay: 200,
  timeout: 3000
})
```

**Pattern search:**

```bash
rg "component:\\s*=>\\s*import" --type vue
rg "component:\\s*:" --type vue
```

### 3.8 Functional Components (High)

```javascript
// Before (Vue 2)
export default {
  functional: true,
  props: ['level'],
  render(h, { props, data, children }) {
    return h(`h${props.level}`, data, children)
  }
}

// After (Vue 3) - Must convert to stateful
export default {
  props: ['level'],
  template: `<h{{ level }}><slot /></h{{ level }}>`
  // or keep render function with imported h
}
```

**Pattern search:**

```bash
rg "functional:\\s*true" --type vue
rg "<template\\s+functional>" --type vue
```

### 3.9 Emits Option (High - Recommended)

```javascript
export default {
  emits: ['click', 'update:value', 'close']
  // Validation
  emits: {
    click: null,
    update:value: (value) => typeof value === 'number'
  }
}
```

**Pattern search:**

```bash
rg "emits:" --type vue
rg "v-on:click" --type vue
```

### 3.10 Slots (Medium)

```javascript
// $scopedSlots removed
this.$scopedSlots.slotName → this.$slots.slotName()

// $slots now functions
this.$slots.default → this.$slots.default()
```

**Pattern search:**

```bash
rg "\\$scopedSlots" --type vue
rg "\\$slots" --type vue
```

### 3.11 $attrs (Medium)

```javascript
// $attrs now includes class and style
// No action needed, but affects inheritAttrs behavior
```

### 3.12 v-on.native (Medium)

```html
<!-- Before -->
<ChildComponent @click.native="handler" />

<!-- After -->
<ChildComponent @click="handler" />
```

**Pattern search:**

```bash
rg "\\.native" --type vue
```

### 3.13 Data Option (Medium)

```javascript
// Vue 2 object allowed
data: { count: 0 }

// Vue 3 must be function
data() {
  return { count: 0 }
}

// Mixin shallow merge
```

**Pattern search:**

```bash
rg "^\\s+data:\\s*\\{" --type vue
```

### 3.14 Watch Array (Medium)

```javascript
// Vue 2: triggered on mutation
watch: {
  list() { /* triggers */ }
}

// Vue 3: only on replacement
watch: {
  list: {
    handler() { /* triggers */ },
    deep: true  // Add for mutation
  }
}
```

**Pattern search:**

```bash
rg "watch:\\s*\\{" --type vue
```

### 3.15 Transition Classes (Low)

```css
/* Before */
.v-enter,
.v-leave-to { opacity: 0; }

/* After */
.v-enter-from,
.v-leave-to { opacity: 0; }
```

**Pattern search:**

```bash
rg "\\.v-enter" --type css
rg "\\.v-leave" --type css
```

### 3.16 Template Key (Low)

```html
<!-- Before -->
<template v-for="item in list">
  <div :key="item.id">...</div>
</template>

<!-- After -->
<template v-for="item in list" :key="item.id">
  <div>...</div>
</template>
```

**Pattern search:**

```bash
rg "<template\\s+v-for" --type vue
```

### 3.17 v-if/v-for Priority (Low)

```html
<!-- Avoid on same element -->
<!-- v-if now has priority over v-for -->

<!-- Use computed instead -->
<template v-for="item in visibleItems">
  <div v-if="item.isVisible">...</div>
</template>
```

### 3.18 v-bind Order (Low)

```html
<!-- Order matters in Vue 3 -->
<div id="red" v-bind="{ id: 'blue' }"></div>
<!-- Result: id="blue" (v-bind wins) -->

<div v-bind="{ id: 'blue' }" id="red"></div>
<!-- Result: id="red" (static wins) -->
```

## Phase 4: Build & Error Fix

```bash
# Run build
npm run build

# Common errors:
# 1. 'Vue' not defined → import { createApp } from 'vue'
# 2. v-model prop missing → add modelValue prop
# 3. beforeDestroy not found → rename to beforeUnmount
# 4. Custom directive hooks → update names
# 5. Filters not found → convert to methods
# 6. $on/$off/$once → replace with mitt

# Fix iteratively until build passes
```

## Phase 5: Verification

```bash
# Run tests
npm test

# Manual verification
# - All pages render
# - All interactions work
# - API calls function
# - No console errors

# If failures → return to Phase 3
```

## Complete Checklist

### Critical (Break Build)
- [ ] Vue.extend → createApp/defineComponent
- [ ] v-model value → modelValue, input → update:modelValue
- [ ] beforeDestroy → beforeUnmount
- [ ] destroyed → unmounted
- [ ] Filters removed → methods/computed
- [ ] $on/$off/$once removed → mitt/tiny-emitter
- [ ] Global API moved to app instance

### High Priority (Functionality)
- [ ] .sync → v-model:
- [ ] v-on.native removed
- [ ] Custom directive hooks renamed
- [ ] Async components use defineAsyncComponent
- [ ] Functional components converted
- [ ] emit option added

### Medium Priority (Best Practice)
- [ ] $scopedSlots → $slots (as functions)
- [ ] $listeners removed
- [ ] $attrs includes class/style
- [ ] Data as function
- [ ] Mixin shallow merge
- [ ] Watch array deep option

### Low Priority (Cleanup)
- [ ] Transition classes renamed
- [ ] Template key placement
- [ ] v-if/v-for priority
- [ ] v-bind order
- [ ] Functional template attribute removed

## File Search Patterns

```bash
# Global API
rg "Vue\\.component" --type vue
rg "Vue\\.directive" --type vue
rg "Vue\\.mixin" --type vue
rg "Vue\\.use" --type vue
rg "Vue\\.prototype" --type vue
rg "Vue\\.extend" --type vue

# v-model
rg "v-model" --type vue
rg "\\.sync" --type vue

# Lifecycle
rg "beforeDestroy" --type vue
rg "destroyed" --type vue

# Events
rg "\\$on" --type vue
rg "\\$off" --type vue
rg "\\$once" --type vue

# Directives
rg "bind:" --type vue
rg "inserted:" --type vue

# Filters
rg "filters:" --type vue

# Slots
rg "\\$scopedSlots" --type vue
```

## Progress Reporting

```markdown
Phase 1: vue-codemod transformation
  ✅ Completed: /src/components/**/*.vue
  ⏳ In progress: /src/views/**/*.vue
  ⏸ Pending: /src/**/*.{js,ts}

Phase 2: FIXME fixes
  📍 Found 247 FIXME comments
  📍 Fixed 123 (50%)
  📍 Remaining: 124

Phase 3: Checklist execution
  📍 Critical: 7/7 complete
  📍 High: 6/6 complete
  📍 Medium: 5/6 complete
  📍 Low: 3/5 complete
```

## Success Criteria

Migration complete when:
- ✅ npm run build passes (exit code 0)
- ✅ All tests pass
- ✅ No Vue2 syntax detected
- ✅ All features work as before
- ✅ Performance maintained/improved

## Related Migrations

For complete Vue3 migration, also handle:
- **Vuex 3.x → Pinia**: Separate migration
- **Vue Router 3.x → 4.x**: Separate migration
- **Element UI → Element Plus**: If using Element UI

## Key Principles

1. **Options API Preserved**: Never convert to Composition API unless requested
2. **Business Logic**: Keep methods, computed, watchers identical
3. **Testing**: Comprehensive testing after each phase
4. **Backup**: Git backup before starting
5. **Incremental**: Process in batches, test frequently

## When to Use

Use this skill when:
- Migrating Vue2 project to Vue3
- Maintaining Options API syntax
- Handling 10w+ codebases
- Need systematic, checklist-driven approach
- Require audit trail of changes

Do NOT use when:
- Converting to Composition API (different skill)
- Just upgrading Vue Router/Vuex (use their migration guides)
- Small project (manual migration faster)
