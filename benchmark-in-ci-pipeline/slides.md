% 把 Benchmark 集成到 CI Pipeline 中
% liyan
% 2021-07-21

## Benchmark 概览

### 软件为什么要进行基准测试呢？

- If you cannot measure it, you cannot improve it.
  - —   Lord Kelvin
- 性能优化是一个持续改进的过程，如果没有好的措施来看护软件的性能基线，就很容易导致软件系统的性能长期处于不稳定的状态
- 基准测试的目的，就是为软件系统获取一个已知的基线水平。这样，当软件修改变化导致性能发生劣化的时候，我们就可以在第一时间发现问题

::: notes

- 但是，如何对软件系统做好基准测试，是一件非常有挑战的事情！
- 就拿 RePACS 服务来说，要对其进行性能测试时，需要模拟很多种类型的用户请求，可是这在测试场景下是很难构造的。

:::

### 基准测试的分类

按照被测系统规模，可以分为微基准测试与宏基准测试

- 微基准测试主要针对的是软件编码实现层面上的性能基线测试
- 宏基准测试则是针对产品系统级所开展的性能基线测试

::: notes

微基准测试是对代码执行时间的一项测量活动

- 针对较小的代码段运行时间测不准的问题，微基准测试的一种可行方式，就是迭代、累积运行多次后获取的测试时间间隔，然后再平均到每一次的运行时间上，这样就可以减少获取的时间间隔误差对测量结果的影响

宏基准性能测试

- 全系统端到端的性能测试
- 组件 / 服务级的性能测试
- 在产品服务发布之后，人工进行性能测试

:::

### 系统级性能基准测试挑战

1. 全量系统规模大，不易复制
2. 引入多机 Cache 机制，仿真业务性能难
3. 引入安全机制，导致仿真用户难
4. 业务场景多样分布，测试难复制

::: notes

更高效的做法

- 通过软件系统架构分析，将系统级性能基准指标拆分成规模较小的子系统或服务上的性能测试
- 然后再通过小规模的性能基准测试结果组合，分析系统级的关键性能，从而实现使用比较低的成本获取更核心的性能指标的目的

:::

## 微基准测试 Pipeline 实战

### pytest-benchmark

- 引入测试框架：pytest 简介
- benchmark 设计与编写
  - 构造用例粒度的测试点
  - 利用已有的单元测试
- 统计结果查看
  - InterQuartile Range
  - Outliers 离群值
  - OPS 吞吐率
  - Rounds / Iterations 轮 / 次

::: notes

pytest tests/benchmark/test_api_users.py::test_benchmark2

1 Standard Deviation from Mean

- 一个标准差内 68%

1.5 IQR (InterQuartile Range) from 1st Quartile and 3rd Quartile

:::

### 本地集成 Pipeline

- [CI/CD pipelines](https://docs.gitlab.com/ee/ci/pipelines/)
  - pipeline 由 job 和 stage组成：job 定义做什么；stage 定义何时运行 job
  - job 被 runner 执行，相同 stage 的 jobs 并行执行，一般来说，当前 stage 的所有 jobs 都执行成功后，进入到下一个 stage
  - 可视化
- The [.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/yaml/gitlab_ci_yaml.html) file
  - [Reference](https://docs.gitlab.com/ee/ci/yaml/) Overview
  - [Schedule a Pipeline](https://docs.gitlab.com/ee/ci/pipelines/schedules.html)

::: notes

stages

- If a job does not specify a stage, the job is assigned the test stage.

image

script

- Shell script for the runner to execute

only / except

- Use `only` to define when a job runs.
- Use `except` to define when a job does not run.

retry

- Use `retry` to configure how many times a job is retried in case of a failure.

variables

- CI/CD `variables` are configurable values that are passed to jobs. They can be set globally and per-job.

:::

### gitlab-runner 执行 Pipeline

- 本地调试 pipeline
  - $ gitlab-runner exec shell build-dev-image
  - $ gitlab-runner exec shell unit-test-and-microbenchmarking
- 用 docker 模式: `image: ...`
  - $ gitlab-runner exec docker linters
- 使用当前用户在后台运行
  - $ nohup gitlab-runner run 1> runner.log 2>&1 &

## 宏基准测试 Pipeline 实战

### 编写性能测试用例

- [example-locustfile-py](https://docs.locust.io/en/stable/quickstart.html#example-locustfile-py)
- tests/performance/user-locustfile.py
- locust -f tests/performance/user-locustfile.py --users 10 --host http://0.0.0.0:8080 --headless --run-time 30m

### 监控指标

- 系统资源监控
- 内部服务处理结果监控
  - 埋点: gunicorn_wrapper.py

## 最佳实践总结

### 用自动化避免重复性工作

- 测试数据准备阶段
- 测试环境准备阶段
- 测试执行阶段
- 测试结果记录阶段

::: notes

测试环境准备阶段

- dev.dockerfile 是目前封装 Pipeline 的基础设施的方式
- docker-compose.yml 封装服务配置

测试执行阶段

- 微基准性能测试直接集成到单元测试阶段，commit 触发
- 宏基准性能测试，定义独立的测试阶段，定时触发
- .gitlab-ci.yml 封装执行逻辑

:::

### 集成面临的挑战

- 执行成本
- 稳定性要求
- 性能结果准确性要求

::: notes

- 性能测试的执行花销是不能忽视的：外部接口都可以 mock

- 需要考虑将性能系统中，软 / 硬件稳定性比较差的依赖项隔离出去

- 避免波动的一些方法：大粒度，重复多次

:::
