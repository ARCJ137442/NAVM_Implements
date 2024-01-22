#=
实现NARS-Python的输入格式
- 最大特点：其陈述只使用圆括号
=#

# 导出
export BE_NARS_Python

"实现一个后端"
struct BE_NARS_Python <: BE_CommonCIN end

begin "NARS库"
    
    """
    新建一个NARS-Python字串解析器
    - 深拷贝原有解析器，并修改其内容
        - 不会影响原解析器
    """
    const StringParser_python::JuNarsese.Conversion.StringParser = deepcopy(JuNarsese.StringParser_ascii)
    # 修改属性
    StringParser_python.compound_brackets[Statement] = ("(", ")")
    # 修改自动生成的其它项
    empty!(StringParser_python.brackets_compound)
    push!(StringParser_python.brackets_compound, reverse.(collect(StringParser_python.compound_brackets))...) # 翻转字典
    empty!(StringParser_python.bracket_openers)
    push!(StringParser_python.bracket_openers, (left for (left,_) in values(StringParser_python.compound_brackets))...)
    empty!(StringParser_python.bracket_closures)
    push!(StringParser_python.bracket_closures, (right for (_,right) in values(StringParser_python.compound_brackets))...)

end

begin "方法实现"

    "实现NARS-Python的Narsese输入"
    transform(::BE_NARS_Python, cmd::CMD_NSE) = [narsese2data(StringParser_python, cmd.narsese)]

    """
    实现NARS-Python的推理步进指令
    - 📌注：NARS-Python中没有「强制推理器步进」的入口
    """
    transform(::BE_NARS_Python, cmd::CMD_CYC) = String[]

    # 参考自`InputChannel.py`
    "实现NARS-Python的信息打印"
    function transform(::BE_NARS_Python, cmd::CMD_INF)
        local f::String = lowercase(cmd.flag)
        if f == "cycle"
            return ["cycle"]
        elseif startswith("memory", f) || startswith("count", f)
            return ["count"]
        end
    end

    "实现NARS-Python的记忆存储" # 不一定有「存储路径」
    transform(::BE_NARS_Python, cmd::CMD_SAV) = ["save"] # 暂时不使用参数

    "实现NARS-Python的记忆读取" # 不一定有「存储路径」
    transform(::BE_NARS_Python, cmd::CMD_LOA) = (
        # 暂时不使用参数
        cmd.target == "input"
            ? ["load_input"]
            : ["load"]
    )
end
