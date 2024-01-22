#=
实现OpenJunars的输入格式
=#

# 导出
export BE_OpenJunars

"实现一个后端"
struct BE_OpenJunars <: BE_CommonCIN end


"实现OpenJunars的Narsese输入: CommonNarsese" # TODO: 后续需要对「真值括号」进行特化
transform(::BE_OpenJunars, cmd::CMD_NSE) = [narsese2data(StringParser_ascii, cmd.narsese)]

"实现OpenJunars的推理步进指令"
transform(::BE_OpenJunars, cmd::CMD_CYC) = [":c $(cmd.cycles)"]

"实现OpenJunars的信息打印"
transform(::BE_OpenJunars, ::CMD_INF) = [":p"]
