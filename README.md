# ZHYCodingModel

## 中文

### 综述

`ZHYCodingModel`是一个实现了Cocoa框架(Mac)或者Cocoa Touch(iOS)框架中`NSCoding`协议的类。

继承自`ZHYCodingModel`的类不再需要你自己手写那些序列化和反序列化的重复代码。这使子类的代码更加清爽和简洁。

`ZHYCodingModel`会对类中的实例变量进行Coding。

支持以下特性：

> 1. 自动序列化和反序列化
> 2. 跳过特定实例变量的序列化
> 3. 针对特定实例变量序列化和反序列化的替换
> 4. 友好的为空检查和上报
> 5. 自定义'-initWithCoder:'方法

不支持以下类型：

> 1. C字符串
> 2. C指针
> 3. 结构体
> 4. C数组
> 5. 联合体

`ZHYCodingModel`基于MIT协议开源，如果你在使用中发现了BUG或者不能满足你的要求，请联系我。也欢迎其他开发者一起参与`ZHYCodingModel`的开发维护。