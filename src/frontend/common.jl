begin "辅助开发的宏与工具函数"

    """
        @nair 指令名 参数...
    快速定义一个NAIR命令

    【20230825 13:50:44】注意：`@nair SAV 1`与`@nair :SAV 1`在参数传入上不同
    """
    macro nair(head::Symbol, params::Vararg)
        Expr(
            :call,
            Symbol(form_cmd),
            Val(QuoteNode(head)), # head需要被解析成符号，而非值
            params...
        ) |> esc
    end
    """
        @nair 指令名(参数...)
    """
    macro nair(call_ex::Expr)
        Expr(
            :call,
            Symbol(form_cmd),
            Val(QuoteNode(call_ex.args[1])), # head需要被解析成符号，而非值
            call_ex.args[2:end]...
        ) |> esc
    end
    
end
