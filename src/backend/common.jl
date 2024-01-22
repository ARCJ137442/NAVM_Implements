"""
一个CIN普遍通用的后端定义
"""
abstract type BE_CommonCIN <: BackendModule end

"JuNarsese中所有Narsese元素的类型"
TNarsese::Type = Union{ATerm, ASentence, ATask}

"目标类型：字符串"
target_type(::BE_CommonCIN) = String

"实现注释" # !【2024-01-22 19:11:40】移除「转换时输出」的副作用
transform(::BE_CommonCIN, ::CMD_REM)::Vector{String} = String[] # 空数组

"对未知指令的处理：静默失败，debug警告"
function transform(be::BE_CommonCIN, cmd::NAIR_CMD)::Vector{String}
    @debug "$be: 未知的指令「$cmd」"
    String[] # 空数组
end
