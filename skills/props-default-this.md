---
name: props-default-this
description: prop 默认函数无法访问 this，改为接收 props 参数
---



# 迁移规则概览



## 迁移规则1：prop 默认函数无法访问 this

- Vue2: prop 默认函数可以访问 this
- Vue3: prop 默认函数接收 props 参数，无法访问 this

### 代码示例

```javascript
// Vue2 写法
export default {
  props: {
    username: {
      type: String,
      default: 'guest'
    },
    theme: {
      default() {
        // 可以访问 this
        return this.isDark ? 'dark' : 'light'
      }
    }
  }
}

// Vue3 写法
import { inject } from 'vue'

export default {
  props: {
    username: {
      type: String,
      default: 'guest'
    },
    theme: {
      default(props) {
        // props 是原始值
        // 可以使用 inject 访问注入的属性
        return inject('theme', 'default-theme')
      }
    }
  }
}
```
