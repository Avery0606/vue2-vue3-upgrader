---
name: watch
description: watch 侦听器数组行为变化，需要指定 deep 选项才能侦听数组变化
---



# 迁移规则概览



## 迁移规则1：侦听数组需要 deep 选项

- Vue2: 侦听数组时，数组改变会自动触发回调
- Vue3: 只有数组替换时触发回调，需要指定 deep 选项

### 代码示例

```javascript
// Vue2 写法
export default {
  watch: {
    bookList(val, oldVal) {
      console.log('book list changed')
    }
  }
}

// Vue3 写法
export default {
  watch: {
    bookList: {
      handler(val, oldVal) {
        console.log('book list changed')
      },
      deep: true // 必须指定 deep 选项
    }
  }
}
```
