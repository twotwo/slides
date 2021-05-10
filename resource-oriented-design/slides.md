% 面向资源的接口设计
% liyan
% 2021-05-05

## 服务接口概览

### 应用到的协议

- RPC
  - 基于接口和方法设计，以效率为第一目标
- DICOM
  - Digital Imaging and Communications in Medicine，一组通用的标准协定，规定医学影像如何处理、储存、打印和传输
- RESTful
  - Representation State Transfer，是面向资源的一种编程风格，基于 HTTP
  - 适用于一切网络没有成为性能瓶颈的应用场景

::: notes

This is my note.

- RPC 面向过程，基于 socket
- DICOM 面向影像数据，传输基于 socket

:::

### GraphQL - 为 API 而生的查询语言

- 2018年11月7日，Facebook 将 GraphQL 项目转移到新成立的 GraphQL 基金会（隶属于非营利性的 Linux 基金会）
- 既是一种用于 API 的查询语言也是一个满足你数据查询的运行时
- 请求你所要的数据不多不少
  - 为 API 中的数据提供了一套易于理解的完整描述，使得客户端能够精准获取所需数据，没有任何冗余
- 获取多个资源只用一个请求
- 这种查询语言所带来的灵活性和丰富性的同时也增加了复杂性，简单 APIs 有可能不适合这种方式

### 补足 REST 缺乏对资源进行“部分”和“批量”的处理能力

- 缺少对资源的“部分”操作的支持
  - 避免 Overfetching：在 GET 方法的 Endpoint 上设计各种参数
- 缺少对资源的“批量”操作的支持
  - 要解决批量操作这类问题，目前一种从理论上看还比较优秀的解决方案是 GraphQL

### 面向过程 VS 面向对象 VS 面向资源

只有选择不同，没有高下之分

- 面向过程是为了符合计算机世界中主流的交互方式，所以重点关注输入输出
  - 单体应用进程间调用
- 面向对象是为了符合现实世界的主流交互方式，所以数据与行为被封装成了对象
  - 进程内调用
- 面向资源是为了符合网络世界的主流的交互方式，所以把数据看成主体，把行为抽象成统一接口
  - 特别适用于前后端分离的业务场景

### 面向资源设计的通用部分

||RESTful|DICOM|
|--|--|--|
|资源|HTTP Resouce | DICOM 数据集 |
|展示|Representation | SoP |
| |一个内容的 HTML/JSON/PDF 版本|/|
| |/ |一套图的 Presentation/Print/GSPS|
|State|上下文|/|

::: notes

- HTTP Resouce / DICOM 数据集
- Representation / Softcopy Presentation
  - REST 一个资源的 HTML/JSON/PDF 版本
  - DICOM 一个图像的彩色/灰度/不同窗宽窗位 显示
- State
  - 在特定语境中才能产生的上下文信息
:::

### 面向资源设计的优势： REST vs RPC

- 降低了服务接口的学习成本
- 资源天然具有集合与层次结构
- REST 绑定于 HTTP 协议
  - HTTP 协议有效运作了 30年，与其相关的技术基础设施已是千锤百炼，无比成熟

### Reference 1

- <http://wiki.li3huo.com/RPC>
- <http://wiki.li3huo.com/DICOM>
- <http://wiki.li3huo.com/Representational_State_Transfer>
- <http://wiki.li3huo.com/GraphQL>

## 理解 REST

### REST 风格的系统特征

- RESTful 是一种设计风格
- Client-Server 分离结构
  - Server-Side Rendering
- Stateless
  - 上下文信息，会话信息由客户端保存维护，服务器端依据客户端传递的状态信息来进行业务处理
- Cacheability
  - 运作良好的缓存机制可以减少客户端、服务器之间的交互，甚至有些场景中可以完全避免交互，从而提升服务性能

### REST 风格的系统特征 2

- Layered System
  - 客户端一般不需要知道是否直接连接到了最终的服务器
  - 可以利用中间服务器进行缓存、伸缩和安全策略的部署
- Uniform Interface
  - 软件系统设计的重点放在抽象系统该有哪些资源上，而不是抽象系统该有哪些行为（服务）上
  - 面向资源编程的抽象程度通常更高
  - HTTP Method as Interface
    - `GET`/`HEAD`/`POST`/`PUT`/`DELETE`/`TRACE`/`OPTIONS`

### Richardson 成熟度模型

- Richardson 成熟度模型（Richardson Maturity Model，RMM）让之前不使用 REST 的服务能够逐步导入 REST
- Richardson 将服务接口按照“REST 的程度”从低到高分为 0 至 3 共 4 级：
  - Level 0 //一个 URI 支持全部请求
  - Level 1 - Resources
  - Level 2 - HTTP Verbs
  - Level 3 - Hypermedia Controls //HATEOAS(Hypertext As The Engine Of Application State)

### Steps toward REST

![Steps toward REST](./maturity-model.png)

### REST 的不足与争议

- 争议1：面向资源的编程思想只适合做 CRUD，只有面向过程、面向对象编程才能处理复杂的业务逻辑
  - 所有基于网络的操作逻辑，都可以通过解决“信息在服务端与客户端之间如何流动”这个问题来理解
  - 比较抽象的场景，按 Google 推荐的 REST API 风格来拓展 HTTP 标准方法

### REST 的不足与争议 2

- 争议2：REST 与 HTTP 完全绑定，不适用于要求高性能传输的场景中
  - HTTP 是应用层协议，而不是传输层协议
  - 对于需要直接控制传输（如二进制细节 / 编码形式 / 报文格式 / 连接方式等）细节的场景，REST 确实不合适
- 争议3：REST 没有传输可靠性支持
  - REST 并没有提供对传输可靠性的支持
  - 当客户端没有收到有效返回时，重发请求是最佳策略
  - HTTP 协议要求 GET、PUT 和 DELETE 操作应该具有幂等性（Idempotency）

## 服务接口设计实践

### 面向资源的设计

- 面向过程设计接口的弊端
  - 随着功能的变化，可能是形成一堆庞大而混乱的 API 接口。开发者必须单独学习每种方法。显然，这既耗时又容易出错
- 面向资源的接口设计
  - 定义可以用少量方法控制的命名资源，方法自然映射为 HTTP 方法
  - 基于 RPC 实现的服务，改变面向过程来设计接口的思考方式，复用 RESTful 设计风格，从而提高可用性并降低复杂性
- Google API 设计指南

::: notes

面向资源来设计接口

- 这些资源和方法被称为 API 的“名词”和“动词”
- 让资源拥有的标准方法比较少，这使得要学习的内容减少了很多，因此开发人员可以专注于资源及其关系

RPC 接口也是可以应用面向资源的设计原则的

- RESTful 风格取得了巨大的成功，2010年有 74% 的公共网络 API 是 RESTful 的；
- 而在数据中心内，基于 socket 的 RPC API 来承载大多数网络流量，比前者高几个数量级

:::

### 标准方法

|标准方法|HTTP 映射|HTTP 请求正文|HTTP 响应正文|
|--|--|--|--|
|List	|GET <collection URL>|无|资源 * 列表|
|Get	|GET <resource URL>|资源 id|资源 * |
|Create	|POST <collection URL>|资源|资源 * |
|Update	|PUT or PATCH <resource URL>|资源|资源 * |
|Delete	|DELETE <resource URL>| 不适用|google.protobuf.Empty**|

### 自定义方法

|方法名称|自定义动词|HTTP 动词|备注|
|--|--|--|--|
|取消|:cancel|POST|取消一个未完成的操作|
|batchGet|:batchGet|GET|批量获取多个资源|
|移动|:move|POST|将资源从一个父级移动到另一个父级|
|搜索|:search|GET|List 的替代方法|
|恢复删除|:undelete|POST|恢复已删除资源|

::: notes

- 取消：operations.cancel
- 移动：folders.move
- 搜索：services.search
- 恢复删除：services.undelete。建议的保留期限为 30 天

接下来让我们看看怎么把一个接口改造成符合面向资源的设计风格

:::

### RMM Level 0 完全不 REST

- 我们的需求是设计一个门诊预约系统：查看某大夫在指定日期是否有空闲，以便预约
  - 医院开放了一个 /appointmentService 的 Web API，传入日期、医生姓名作为参数，就可以得到该时间段、该医生的空闲时间
  - 得到空闲结果后，提交预约信息：预约成功或者失败

![RMM Level 0](https://martinfowler.com/articles/images/richardsonMaturityModel/level0.png)

::: notes

RPC 风格

:::

### RMM Level 1 引入资源概念

![RMM Level 1](https://martinfowler.com/articles/images/richardsonMaturityModel/level1.png)

### RMM Level 2 引入统一接口

![RMM Level 2](https://martinfowler.com/articles/images/richardsonMaturityModel/level2.png)

::: notes

引入统一接口，映射到 HTTP Method 上

:::

### RMM Level 3 超文本驱动

![RMM Level 3](https://martinfowler.com/articles/images/richardsonMaturityModel/level3.png)

::: notes

- Hypermedia Controls：在咱们课程里面的说法是“超文本驱动”，
- Hypertext as the Engine of Application State（HATEOAS），都说的是同一件事情。
  - 在 Fielding 论文里

:::

### Reference 2

- <https://cloud.google.com/apis/design>
- <https://martinfowler.com/articles/richardsonMaturityModel.html>
- <http://wiki.li3huo.com/Idempotence>
