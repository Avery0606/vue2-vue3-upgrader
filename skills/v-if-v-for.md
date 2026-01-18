---
name: v-if-v-for
description: v-if 与 v-for 的优先级对比变化，v-if 现在优先于 v-for 生效
---



# 迁移规则概览



## 迁移规则1：v-if 与 v-for 优先级变更

- Vue2: v-for 拥有比 v-if 更高的优先级
- Vue3: v-if 拥有比 v-for 更高的优先级

### 代码示例

```html
<!-- Vue2 写法 -->
<!-- v-for 先执行 -->
<div v-for="item in items" :key="item.id" v-if="item.isActive">
  {{ item.name }}
</div>

<!-- Vue3 写法 -->
<!-- v-if 先执行，推荐使用计算属性替代 -->
<div v-for="item in activeItems" :key="item.id">
  {{ item.name }}
</div>

<script>
// Vue3 推荐写法
export default {
  computed: {
    activeItems() {
      return this.items.filter(item => item.isActive)
    }
  }
}
</script>
```
