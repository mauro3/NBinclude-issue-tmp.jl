To reproduce:

```
$ julia --project

julia> using Pkg; Pkg.instantiate()

julia> include("gen-notebook.jl")
```

Backtrace:
````
julia> include("gen-notebook.jl")
[ Info: generating notebook from `~/julia/issues/literate-nbinclude/scripts/00.jl`
[ Info: executing notebook `00.ipynb`
[ Info: writing result to `~/julia/issues/literate-nbinclude/notebooks/00.ipynb`
[ Info: generating notebook from `~/julia/issues/literate-nbinclude/scripts/lit-script.jl`
[ Info: executing notebook `lit-script.ipynb`
┌ Error: error when executing notebook based on input file: `~/julia/issues/literate-nbinclude/scripts/lit-script.jl`
└ @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:748
ERROR: LoadError: LoadError: SystemError: opening file "~/julia/issues/literate-nbinclude/00.jl": No such file or directory
in expression starting at ~/julia/issues/literate-nbinclude/notebooks/lit-script.ipynb:2
when executing the following code block from inputfile `~/julia/issues/literate-nbinclude/scripts/lit-script.jl`

```julia
using NBInclude
@nbinclude("00.jl")
```


Stacktrace:
  [1] error(s::String)
    @ Base ./error.jl:35
  [2] execute_block(sb::Module, block::String; inputfile::String, fake_source::String)
    @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:866
  [3] execute_notebook(nb::Dict{Any, Any}; inputfile::String, fake_source::String)
    @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:764
  [4] (::Literate.var"#38#40"{Dict{String, Any}})()
    @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:744
  [5] cd(f::Literate.var"#38#40"{Dict{String, Any}}, dir::String)
    @ Base.Filesystem ./file.jl:112
  [6] jupyter_notebook(chunks::Vector{Literate.Chunk}, config::Dict{String, Any})
    @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:743
  [7] notebook(inputfile::String, outputdir::String; config::Dict{Any, Any}, kwargs::Base.Pairs{Symbol, Bool, Tuple{Symbol}, NamedTuple{(:execute,), Tuple{Bool}}})
    @ Literate ~/.julia/packages/Literate/VQn4b/src/Literate.jl:680
  [8] top-level scope
    @ ~/julia/issues/literate-nbinclude/gen-notebook.jl:6
  [9] include(fname::String)
    @ Base.MainInclude ./client.jl:476
 [10] top-level scope
    @ REPL[7]:1
in expression starting at ~/julia/issues/literate-nbinclude/gen-notebook.jl:6

julia>
````

What happens:
- Literate.jl tries to evaluate the generated notebook's cell via https://github.com/fredrikekre/Literate.jl/blob/60c08dc23e3f6dc6fb2ae04571f9f6e8a0c6d2fa/src/Literate.jl#L862 Of note is that it gets executed within the right directory, namely `notebooks` for this example, see https://github.com/fredrikekre/Literate.jl/blob/60c08dc23e3f6dc6fb2ae04571f9f6e8a0c6d2fa/src/Literate.jl#L743
- this then goes to NBInclude.jl to evaluate the `@nbinclude` call, at https://github.com/stevengj/NBInclude.jl/blob/d1cff61be648d2f8400f3eb4bc0509f622917088/src/NBInclude.jl#L65 the bug occurs.  The `path` variable changes from "00.jl" to ".../literate-nbinclude/00.jl".  I'm not sure what `Base._include_dependency(m, path)` is supposed to do but here it should return ".../literate-nbinclude/notebooks/00.jl"
