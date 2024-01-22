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
@info "✅测试用前端 构建完成" fea fes

# %% [8] code
@testset "前端" begin


# %% [9] code
let cmds = transform(fea, "<A --> B>.")
    @test cmds |> length == 1
    @test cmds[1] isa NAVM.CMD_NSE
end

let cmds = fea("/VOL 10")
    @test cmds |> length == 1
    @test cmds[1] isa NAVM.CMD_VOL
    @test cmds[1].volume == 10
end

let cmds = fes([
    "(Inheritance (Word A) (Word B))"
    "12"
])
    @test cmds[1] isa NAVM.CMD_NSE
    @test cmds[1].narsese isa JuNarsese.AbstractTerm
    @test cmds[1].narsese isa JuNarsese.Inheritance
    @test cmds[1].narsese[1] isa JuNarsese.Word
    @test cmds[1].narsese[2] isa JuNarsese.Word
    @test cmds[1].narsese[1] |> JuNarsese.nameof == :A
    @test cmds[1].narsese[2] |> JuNarsese.nameof == :B

    @test cmds[2] isa NAVM.CMD_CYC
    @test cmds[2].cycles == 12
end

# %% [10] code
end # begin @test


# %% [11] markdown
# ## 测试 / 后端

# %% [12] code
ben = BE_OpenNARS()
beo = BE_ONA()
bep = BE_NARS_Python()
bey = BE_PyNARS()
bej = BE_OpenJunars()
@info "✅测试用后端 构建完成" ben beo bep bey bej

# %% [13] code
@testset "后端" begin


# %% [14] code
# 轮流测试
testset = [
    NAVM.CMD_REM("这是一段不会被翻译的注释")
    NAVM.CMD_NSE(nse"<A --> B>.")
    NAVM.CMD_NSE(nse"<B --> C>.")
    NAVM.CMD_CYC(5)
    # NAVM.CMD_UNK(5, Operator, Int, :a123, r"123", nse"<A --> B>.")
]
for be in [ben, beo, bep, bey, bej]
    @info "开始测试$(be)。。。"
    let result = be.(testset),
        result_combined = be(testset)
        @test length(result_combined) <= 4 # 不会超过四条
        # 测试Narsese的共有部分
        @test occursin("A --> B", result[2][1])
        @test occursin("B --> C", result[3][1])
        if be !== bep # NARS-Python 没有CYC
            @test occursin("5", result[4][1])
        end
        @info "测试成功！"
    end
end

# %% [15] code
end # begin @test


# %% [16] markdown
# # 测试 / 前后端协同

# %% [17] code
@testset "前后端协同" begin


# %% [18] code
testset_a = [
    # 多行文本测试
    """
    # 下面输入一段基本的三段论推理
    # 基本逻辑：「A是B」「B是C」⇒「A是C」
    """
    "<A -->B>."
    "<B--> C>."
    "<A--> C>?"
    "50"
]
testset_s = """
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
"""

let chain_aj = chain(fea, bej)
    result = chain_aj(testset_a)
    @test chain_aj isa Function
    @test occursin("A --> B", result[1])
    @test occursin(".", result[1])
    @test occursin("B --> C", result[2])
    @test occursin(".", result[2])
    @test occursin("A --> C", result[3])
    @test occursin("?", result[3])
    @test occursin("50", result[4])
end

for be in [ben, beo, bep, bey, bej]
    printstyled("字串 |> $(fes) |> $(be) = \n"; color=:light_cyan, bold=true)
    let result = join((be ∘ fes)(testset_s), "\n")
        # OpenNARS、ONA的音量指令
        if be in [ben, beo]
            @test occursin("*volume=10", result)
        end
        # 周期指令
        if be === bej
            # OpenJunars的周期指令
            @test occursin(":c", result)
        elseif be !== bep
            # 非NARS-Python的周期指令
            @test occursin("50", result)
        end
        # Narsese
        @test occursin("A --> B", result)
        @test occursin("B --> C", result)
        @test occursin("A --> C", result)
        @test occursin(".", result)
        @test occursin("?", result)
        # 打印结果
        result |> println
    end
end

# %% [19] code
end # begin @test


# %% [20] markdown
# ## 尝试自编译


