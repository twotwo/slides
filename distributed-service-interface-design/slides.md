% 分布式服务接口设计
% liyan
% 2021-05-05

## 服务接口概览

### 应用到的协议

- RPC
  - 面向过程，以效率为第一目标
- DICOM
  - Digital Imaging and Communications in Medicine，一组通用的标准协定，规定医学影像如何处理、储存、打印和传输
  - 面向影像数据，基于 TCP/IP
- RESTful
  - Representation State Transfer，是面向资源的一种编程风格，基于 HTTP
  - 适用于一切网络没有成为性能瓶颈的应用场景

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

### 协议对比：只有选择不同，没有高下之分

- 面向过程是为了符合计算机世界中主流的交互方式，所以重点关注输入输出
  - 单体应用进程间调用
- 面向对象是为了符合现实世界的主流交互方式，所以数据与行为被封装成了对象
  - 进程内调用
- 面向资源是为了符合网络世界的主流的交互方式，所以把数据看成主体，把行为抽象成统一接口
  - 特别适用于前后端分离的业务场景

### 面向资源设计的通用部分

- HTTP Resouce / DICOM 数据集
- Representation / Softcopy Presentation
  - REST 一个内容的 HTML/PDF/RSS 版本
  - DICOM 一个图像的 彩色/灰度/不同窗宽窗位 显示
- State
  - 在特定语境中才能产生的上下文信息

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

### 基于资源的设计

### Reference 2

- <https://martinfowler.com/articles/richardsonMaturityModel.html>
- <http://wiki.li3huo.com/Idempotence>
- <https://cloud.google.com/apis/design>
