begin "模块导入"
    # JuNarsese(Parsers)
    push!(LOAD_PATH, "../JuNarsese")
    push!(LOAD_PATH, "../JuNarseseParsers")

    using JuNarsese
    using JuNarseseParsers

    # 导入NAVM
    if !(@isdefined NAVM)
        push!(LOAD_PATH, "../NAVM")
        using NAVM
        import NAVM: source_type, target_type, transform # 添加方法
        @info "NAVM导入成功！" names(NAVM)
    end

    using NAVM_Implements

end

# 启用测试用库
using Test

# 启用@debug
ENV["JULIA_DEBUG"] = "all"