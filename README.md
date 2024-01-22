# NAVM-Implements

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

该项目使用[语义化版本 2.0.0](https://semver.org/)进行版本号管理。

基于**抽象语法支持库**[NAVM](https://github.com/ARCJ137442/NAVM.jl)的**具体CIN实现**

- 对接的两端
  - 前端：
  - 后端NARS实现（OpenNARS、ONA、NARS-Python、PyNARS、OpenJunars、Narjure、NARS-Swift……）
- 为其它使用Narsese的库提供数据结构表征、存取、互转支持

## 概念

相关概念可参考[NAVM.jl的相应部分](https://github.com/ARCJ137442/NAVM.jl?tab=readme-ov-file#%E6%A6%82%E5%BF%B5)

## 安装

作为一个**Julia包**，您只需：

1. 在安装`Pkg`包管理器的情况下，
2. 在REPL(`julia.exe`)运行如下代码：

```julia
using Pkg
Pkg.add(url="https://github.com/ARCJ137442/NAVM_Implements.jl")
```

## 代码目录概览

- `src`: 源码
  - `frontend`: 各类前端实现
  - `backend`: 各类后端实现
- `test`: 测试用例

## 作者注

1. 此项目目前仅用于学习，不建议用于生产环境
2. 此项目最初从另一个接口项目「JuNEI」中分离出来，API、文档等资料可能欠缺
3. 此项目是**JuNarsese**、**JuNarseseParsers**的进阶应用

## 参考

### CIN

- [OpenNARS (Java)](https://github.com/opennars/opennars)
- [ONA (C)](https://github.com/opennars/OpenNARS-for-Applications)
- [NARS-Python (Python)](https://github.com/ccrock4t/NARS-Python)
- [PyNARS (Python)](https://github.com/bowen-xu/PyNARS)
- [OpenJunars (Julia)](https://github.com/AIxer/OpenJunars)
- [Narjure (Clojure)](https://github.com/opennars/Narjure)
- [NARS-Swift (Swift)](https://github.com/maxeeem/NARS-Swift)

### 依赖

- [JuNarsese](https://github.com/ARCJ137442/JuNarsese.jl)
- [JuNarsese-Parsers](https://github.com/ARCJ137442/JuNarseseParsers.jl)
- [PikaParser](https://github.com/LCSB-BioCore/PikaParser.jl)
- [NAVM](https://github.com/ARCJ137442/NAVM.jl)
