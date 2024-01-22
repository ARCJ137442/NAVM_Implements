# %% Jupyter Notebook | Julia 1.10.0 @ julia | format 2~4
# % language_info: {"file_extension":".jl","mimetype":"application/julia","name":"julia","version":"1.10.0"}
# % kernelspec: {"name":"julia-1.10","display_name":"Julia 1.10.0","language":"julia"}
# % nbformat: 4
# % nbformat_minor: 2

# %% [1] markdown
# # NAVM.jl 测试

# %% [2] markdown
# ✨Powered by [**IpynbCompile.jl**](https://github.com/ARCJ137442/IpynbCompile.jl)

# %% [3] markdown
# ## 模块导入

# %% [4] markdown
# 模块清单：
# 
# - JuNarsese
# - NAVM
# - Test

# %% [5] code
include("#import.jl")

# %% [6] markdown
# ## 测试 / 前端

# %% [7] code
fea = FE_TextParser(StringParser_ascii)
fes = FE_TextParser(SExprParser)

@show transform(fea, "<A --> B>.")
@show fes([
    "(Inheritance (Word A) (Word B))"
    "12"
])

@show fea("/VOL 10")

# %% [8] markdown
# ## 测试 / 后端

# %% [9] code
ben = BE_OpenNARS()
beo = BE_ONA()
bep = BE_NARS_Python()
bey = BE_PyNARS()
bej = BE_OpenJunars()

for be in [ben, beo, bep, bey, bej]
    @info be be([
        NAVM.CMD_REM("这是一段不会被翻译的注释")
        NAVM.CMD_NSE(nse"<A --> B>.")
        NAVM.CMD_NSE(nse"<B --> C>.")
        NAVM.CMD_CYC(5)
        # NAVM.CMD_UNK(5, Operator, Int, :a123, r"123", nse"<A --> B>.")
    ])
end

# %% [10] markdown
# # 测试 / 前后端协同

# %% [11] code
chain_f::Function = chain(fea, bej)
@show chain_f
@show chain_f([
    # 多行文本测试
    """
    # 下面输入一段基本的三段论推理
    # 基本逻辑：「A是B」「B是C」⇒「A是C」
    """
    "<A -->B>."
    "<B--> C>."
    "<A--> C>?"
    "50"
])

for be in [ben, beo, bep, bey, bej]
    @info "从「$(fes)字串」到「$(be)命令」"
    join(
        (be ∘ fes)("""
        /RES memory
        /LOA memory *
        # 下面输入一段基本的三段论推理
        # 基本逻辑：「A是B」「B是C」⇒「A是C」
        (SentenceJudgement (Inheritance (Word A) (Word B)) )
        (SentenceJudgement (Inheritance (Word B) (Word C)) )
        (SentenceQuestion  (Inheritance (Word A) (Word C)) )
        /VOL 10
        50
        /CYC 50
        /INF memory
        /SAV memory *
        """),
        "\n"
    ) |> println
end

# %% [12] markdown
# ## 尝试自编译


